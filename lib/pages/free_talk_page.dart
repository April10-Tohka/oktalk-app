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
  String _statusText = '准备就绪...';
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
        if (mounted && _isAiSpeaking) {
          setState(() {
            _isAiSpeaking = false;
            _statusText = '正在听取您的声音...';
          });

          // --- 新增：音频播放完毕后，开启 5 秒倒计时淡出字幕 ---
          _subtitleFadeTimer?.cancel(); // 取消之前的计时器
          _subtitleFadeTimer = Timer(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _subtitleOpacity = 0.0;
              });
            }
          });
        }
      }
    });
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
            _statusText = '正在听取您的声音...';
            _subtitles.clear();
            _isAiSpeaking = false;
            _subtitleOpacity = 1.0; // 重置透明度供下一轮使用
          });
          _subtitleFadeTimer?.cancel(); // 用户说话了，停止之前的淡出计时
          _audioPlayer.stop();
          _playlist.clear();
          break;

        case 'llm_token':
          setState(() {
            _subtitles.write(json['text'] ?? '');
            _subtitleOpacity = 1.0;
          });
          break;

        case 'turn_end':
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
    if (!_isAiSpeaking) {
      setState(() {
        _isAiSpeaking = true;
        _statusText = 'AI 正在说话...';
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
    if (_isMicOn) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
    setState(() => _isMicOn = !_isMicOn);
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    if (await _recorder.hasPermission()) {
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _recordSubscription = stream.listen((data) {
        _audioBuffer.addAll(data);
      });

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
    // AI说话期间即使关闭麦克风也不发送
    // 只在 AI 没有说话时，才发送最后一段
    if (!_isAiSpeaking) {
      _sendAudioBuffer();
    } else {
      _audioBuffer.clear(); // AI在说话时，直接丢弃最后这段
    }
  }

  void _sendAudioBuffer() {
    // 如果 AI 正在说话，我们不仅不发，还要清空缓冲区，防止累积噪音
    if (_isAiSpeaking) {
      debugPrint("AI 正在说话，我们不仅不发，还要清空缓冲区");
      _audioBuffer.clear();
      return;
    }

    // 只有 AI 没在说话，且麦克风开启、缓冲区有数据时才发送
    if (_audioBuffer.isNotEmpty && _channel != null && _isMicOn) {
      debugPrint("只有 AI 没在说话，且麦克风开启、缓冲区有数据时才发送");
      _channel!.sink.add(Uint8List.fromList(_audioBuffer));
      _audioBuffer.clear();
    }
  }

  void _hangUp() {
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
