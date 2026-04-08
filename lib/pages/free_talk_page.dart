import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ai_home_page.dart';

enum VoiceSessionState {
  idle, // 刚连上，等待开口
  listening, // 收到 type: listening
  thinking, // 收到 type: thinking
  speaking, // 收到音频流数据
}

class FreeTalkPage extends StatefulWidget {
  const FreeTalkPage({super.key});

  @override
  State<FreeTalkPage> createState() => _FreeTalkPageState();
}

class _FreeTalkPageState extends State<FreeTalkPage> {
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  static const String _aiAvatarUrl =
      'https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/3Ddragon.png';
  static const String _defaultAiAvatar = 'assets/images/default_ai_avatar.png';

  // 1. 会话与连接状态
  String? _sessionId;
  WebSocketChannel? _channel;
  bool _isLoading = true;
  String? _errorMessage;

  // 2. 计时器
  Timer? _callTimer;
  int _elapsedSeconds = 0;

  // 3. 音频与录音
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _recordSubscription;
  List<int> _audioBuffer = [];
  Timer? _sendBufferTimer;

  // 4. UI 状态
  bool _isMicOn = true;
  bool _isAiSpeaking = false;
  bool _isTurnEnded = false; // 用于 Bug 3：标记本轮 TTS 是否推送完毕
  VoiceSessionState _sessionState = VoiceSessionState.idle;
  String _statusText = '有什么可以帮您的？';
  final StringBuffer _subtitles = StringBuffer();
  double _subtitleOpacity = 1.0;
  Timer? _subtitleFadeTimer;

  late ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _initSession();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _sendBufferTimer?.cancel();
    _subtitleFadeTimer?.cancel();
    _recordSubscription?.cancel();
    _channel?.sink.close();
    _audioPlayer.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    _playlist = ConcatenatingAudioSource(children: []);
    await _audioPlayer.setAudioSource(_playlist);

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          debugPrint("音频播放完毕, 状态: ${state.processingState}, _isTurnEnded: $_isTurnEnded");
          // --- 新增：音频播放完毕后，开启 5 秒倒计时淡出字幕 ---
          _subtitleFadeTimer?.cancel();
          _subtitleFadeTimer = Timer(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _subtitleOpacity = 0.0;
              });
            }
          });

          // Bug 3：播放完之后，且收到了 turn_end 事件才能转变状态为 idle
          if (_isTurnEnded) {
            _transitionToIdle();
          }
        }
      }
    });
  }

  void _transitionToIdle() {
    debugPrint("状态转换: 从 $_sessionState 转换为 idle");
    setState(() {
      _sessionState = VoiceSessionState.idle;
      _statusText = '有什么可以帮您的？';
      _isAiSpeaking = false;
      _isTurnEnded = false; // 重置
    });

    // P0 Fix: 在回归 idle 时，确保录音引擎是开启且活跃的。
    // 如果之前因为 focus loss 导致录音停止，强制重新启动它。
    if (_isMicOn) {
      debugPrint("正在回归 idle，强制重新启动录音以确保活跃状态...");
      _restartRecording();
    }
  }

  Future<void> _initSession() async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/chat/session/start');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessionId = data['data']?['session_id'] ?? data['session_id'];

        if (sessionId != null) {
          setState(() {
            _sessionId = sessionId.toString();
          });
          _connectWebSocket();
        } else {
          throw Exception('Failed to get session_id');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _connectWebSocket() {
    if (_sessionId == null) return;

    final wsUrl =
        'ws://${_apiBaseUrl.replaceFirst('http://', '')}/api/v1/chat/freetalk?session_id=$_sessionId';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel!.stream.listen(
      (data) {
        if (data is String) {
          _handleTextData(data);
        } else if (data is List<int>) {
          _handleBinaryData(data);
        }
      },
      onDone: () {
        if (mounted) _callTimer?.cancel();
      },
      onError: (err) {
        debugPrint('WebSocket error: $err');
      },
    );

    setState(() => _isLoading = false);
    _startCallTimer();
    _startRecording();
  }

  void _handleTextData(String text) {
    try {
      final json = jsonDecode(text) as Map<String, dynamic>;
      final type = json['type'] as String?;

      switch (type) {
        case 'listening':
          setState(() {
            _sessionState = VoiceSessionState.listening;
            _statusText = '正在听您的声音。。。';
            _subtitles.clear();
            _isAiSpeaking = false;
            _isTurnEnded = false; // 用户开始说话了，重置 turn_end 状态
            _subtitleOpacity = 1.0; // 重置透明度供下一轮使用
          });
          _subtitleFadeTimer?.cancel(); // 用户说话了，停止之前的淡出计时
          _audioPlayer.stop();
          _playlist.clear();
          break;

        case 'thinking':
          setState(() {
            _sessionState = VoiceSessionState.thinking;
            _statusText = '正在听您的声音。。。';
            _isAiSpeaking = false;
          });
          break;

        case 'llm_token':
          setState(() {
            _subtitles.write(json['text'] ?? '');
            _subtitleOpacity = 1.0;
          });
          break;

        case 'turn_end':
          setState(() {
            _isTurnEnded = true;
          });
          // 如果当前没有在播放音频，或者播放器已经完成了，直接转换回 idle
          if (!_audioPlayer.playing || _audioPlayer.processingState == ProcessingState.completed) {
            _transitionToIdle();
          }
          break;

        case 'error':
          break;

        default:
      }
    } catch (e) {
      debugPrint('Failed to parse text frame: $e');
    }
  }

  Future<void> _handleBinaryData(List<int> bytes) async {
    if (_sessionState != VoiceSessionState.speaking) {
      setState(() {
        _sessionState = VoiceSessionState.speaking;
        _isAiSpeaking = true;
        _statusText = 'AI正在说话。。。';
      });

      if (!_audioPlayer.playing) {
        _audioPlayer.play();
      }
    }

    final wavBytes = _createWavHeader(bytes.length, 16000, 1);
    final fullAudio = Uint8List.fromList([...wavBytes, ...bytes]);

    _playlist.add(
      AudioSource.uri(Uri.dataFromBytes(fullAudio, mimeType: 'audio/wav')),
    );
  }

  Uint8List _createWavHeader(int dataLength, int sampleRate, int channels) {
    final byteData = ByteData(44);
    _writeString(byteData, 0, 'RIFF');
    byteData.setUint32(4, 36 + dataLength, Endian.little);
    _writeString(byteData, 8, 'WAVE');
    _writeString(byteData, 12, 'fmt ');
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, channels, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * channels * 2, Endian.little);
    byteData.setUint16(32, channels * 2, Endian.little);
    byteData.setUint16(34, 16, Endian.little);
    _writeString(byteData, 36, 'data');
    byteData.setUint32(40, dataLength, Endian.little);
    return byteData.buffer.asUint8List();
  }

  void _writeString(ByteData data, int offset, String str) {
    for (int i = 0; i < str.length; i++) {
      data.setUint8(offset + i, str.codeUnitAt(i));
    }
  }

  Future<void> _toggleMic() async {
    setState(() => _isMicOn = !_isMicOn);
    debugPrint("麦克风状态切换: $_isMicOn, 当前状态: $_sessionState");

    // Bug 2 修复 (P1)：只有在 AI 不说话/不思考时，才真正操作录音引擎
    // 如果 AI 正在说话，切换麦克风只改标志位，由 _sendAudioBuffer 负责丢弃数据，
    // 这样就不会因为重新启动录音而抢夺音频播放器的焦点，从而避免打断播放。
    if (_sessionState == VoiceSessionState.idle ||
        _sessionState == VoiceSessionState.listening) {
      if (_isMicOn) {
        // 强制重启录音引擎，确保从 speaking 切换回来的录音状态是干净的，且拥有音频焦点
        _restartRecording();
      } else {
        _stopRecording();
      }
    }
  }

  Future<void> _restartRecording() async {
    debugPrint("强制重启录音引擎...");
    await _stopRecording();
    await _startRecording();
  }

  Future<void> _startRecording() async {
    // 检查录音引擎是否已经在工作
    bool isActuallyRecording = await _recorder.isRecording();

    if (isActuallyRecording &&
        _recordSubscription != null &&
        _sendBufferTimer != null &&
        _sendBufferTimer!.isActive) {
      debugPrint("录音已在进行中且 Subscription/Timer 活跃，跳过启动");
      return;
    }

    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    if (await _recorder.hasPermission()) {
      debugPrint("启动录音引擎...");
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _recordSubscription?.cancel();
      _recordSubscription = stream.listen((data) {
        if (data.isNotEmpty) {
          _audioBuffer.addAll(data);
        }
      }, onError: (err) {
        debugPrint("录音流发生错误: $err");
      }, onDone: () {
        debugPrint("录音流意外结束");
      });

      _sendBufferTimer?.cancel();
      _sendBufferTimer = Timer.periodic(const Duration(milliseconds: 500), (
        timer,
      ) {
        _sendAudioBuffer();
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recordSubscription?.cancel();
    _recordSubscription = null;
    await _recorder.stop();
    _sendBufferTimer?.cancel();
    // 只有在 idle 和 listening 状态下才发送最后一段音频
    if (_sessionState == VoiceSessionState.idle ||
        _sessionState == VoiceSessionState.listening) {
      _sendAudioBuffer();
    } else {
      _audioBuffer.clear(); // 其他状态下采集到用户音频不发送给后端，直接丢弃
    }
  }

  void _sendAudioBuffer() {
    if (_channel == null) return;

    // 只有在 idle 和 listening 状态下才发送音频给后端
    if (_sessionState == VoiceSessionState.idle ||
        _sessionState == VoiceSessionState.listening) {
      if (_isMicOn) {
        if (_audioBuffer.isNotEmpty) {
          debugPrint("发送音频数据, 状态: $_sessionState, 长度: ${_audioBuffer.length}");
          _channel!.sink.add(Uint8List.fromList(_audioBuffer));
          _audioBuffer.clear();
        }
      } else {
        // 麦克风关闭时，直接丢弃数据，防止重新打开时堆积
        if (_audioBuffer.isNotEmpty) {
          debugPrint("麦克风已关闭，丢弃数据");
          _audioBuffer.clear();
        }
      }
    } else {
      // thinking 和 speaking 状态下采集到用户音频不发送给后端，直接丢弃
      if (_audioBuffer.isNotEmpty) {
        debugPrint("非发送状态 ($_sessionState)，丢弃数据");
        _audioBuffer.clear();
      }
    }
  }

  void _hangUp() {
    _stopRecording();
    _channel?.sink.close();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AiHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A3D2B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF71A66E)),
              const SizedBox(height: 16),
              Text(
                '正在初始化通话...',
                style: GoogleFonts.plusJakartaSans(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A3D2B),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  '连接失败: $_errorMessage',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('返回'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. 背景层
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A3D2B), Color(0xFF050F08)],
              ),
            ),
          ),

          // 2. 地形纹理
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: TopographicPainter()),
            ),
          ),

          // 3. 响应式内容布局
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 计算响应式尺寸
                double screenHeight = constraints.maxHeight;
                double avatarSize = (screenHeight * 0.3).clamp(180.0, 280.0);

                return Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAICharacter(avatarSize),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: SingleChildScrollView(
                                child: _buildSubtitleCard(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBottomActions(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _hangUp,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(_elapsedSeconds),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '通话时长',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.45),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAICharacter(double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF71A66E).withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size * 0.85,
              height: size * 0.85,
              child: Image.network(
                _aiAvatarUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(_defaultAiAvatar, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Opacity(
          opacity: _isAiSpeaking ? 1.0 : 0.0,
          child: const SpeakingIndicator(),
        ),
        const SizedBox(height: 8),
        Text(
          _statusText,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitleCard() {
    return AnimatedOpacity(
      opacity: _subtitleOpacity,
      duration: const Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: Text(
              _subtitles.isEmpty ? '等待 AI 回复...' : _subtitles.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            onTap: _toggleMic,
            icon: _isMicOn ? Icons.mic : Icons.mic_off,
            label: '麦克风',
            color: _isMicOn
                ? Colors.white.withOpacity(0.15)
                : Colors.red.withOpacity(0.2),
            iconColor: _isMicOn ? Colors.white : Colors.redAccent,
          ),
          const SizedBox(width: 48),
          _buildActionButton(
            onTap: _hangUp,
            icon: Icons.call_end,
            label: '挂断',
            size: 72,
            isGradient: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    double size = 60,
    Color? color,
    Color iconColor = Colors.white,
    bool isGradient = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isGradient ? null : color,
              gradient: isGradient
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE53935), Color(0xFFC62828)],
                    )
                  : null,
              border: isGradient
                  ? null
                  : Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: isGradient
                  ? [
                      const BoxShadow(
                        color: Colors.black45,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class TopographicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF71A66E)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 1; i <= 3; i++) {
      double y = size.height * (i / 4);
      path.moveTo(0, y);
      path.quadraticBezierTo(size.width * 0.25, y - 50, size.width * 0.5, y);
      path.quadraticBezierTo(size.width * 0.75, y + 50, size.width, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SpeakingIndicator extends StatelessWidget {
  const SpeakingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        double h = [10.0, 20.0, 30.0, 18.0, 12.0][index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: 4,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
