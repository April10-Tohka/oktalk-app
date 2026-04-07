import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

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
  static const String _default_ai_avatar =
      'assets/images/default_ai_avatar.png';

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
  bool _isMicOn = true; // 页面初始是开启状态
  bool _isAiSpeaking = false;
  StringBuffer _subtitles = StringBuffer();
  double _subtitleOpacity = 1.0;
  Timer? _subtitleFadeTimer;

  @override
  void initState() {
    super.initState();
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

  // 初始化会话
  Future<void> _initSession() async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/chat/session/start');
      final response = await http.post(uri);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 假设返回结构为 {"code": 200, "data": {"session_id": "..."}} 或 {"session_id": "..."}
        // 根据 ai_guided_chat_page.dart 的模式，通常有 code: 200
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

  // 1. 建立 WebSocket 连接
  void _connectWebSocket() {
    if (_sessionId == null) return;
    
    final wsUrl = 'ws://${_apiBaseUrl.replaceFirst('http://', '')}/api/v1/chat/freetalk?session_id=$_sessionId';
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
        debugPrint('WebSocket closed');
        if (mounted) {
          _callTimer?.cancel();
        }
      },
      onError: (err) {
        debugPrint('WebSocket error: $err');
      },
    );

    setState(() {
      _isLoading = false;
    });
    
    _startCallTimer();
    // 默认开启麦克风录音
    _startRecording();
  }

  // 2. 处理文字字幕 (流式拼接)
  void _handleTextData(String text) {
    setState(() {
      _subtitles.write(text);
      _subtitleOpacity = 1.0;
    });

    // 5秒后淡出
    _subtitleFadeTimer?.cancel();
    _subtitleFadeTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _subtitleOpacity = 0.0;
        });
      }
    });
  }

  // 3. 处理二进制音频 (WAV 格式)
  Future<void> _handleBinaryData(List<int> bytes) async {
    setState(() {
      _isAiSpeaking = true;
    });
    
    try {
      // 播放 WAV 音频
      await _audioPlayer.play(BytesSource(Uint8List.fromList(bytes)));
      
      // 监听播放完成
      _audioPlayer.onPlayerComplete.first.then((_) {
        if (mounted) {
          setState(() {
            _isAiSpeaking = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      setState(() {
        _isAiSpeaking = false;
      });
    }
  }

  // 4. 麦克风录音与 PCM 推流
  Future<void> _toggleMic() async {
    if (_isMicOn) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  Future<void> _startRecording() async {
    // 权限检查
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    if (await _recorder.hasPermission()) {
      // 原始 PCM, 16000Hz, 单声道
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

      // 每 500ms 发送一次 Buffer
      _sendBufferTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _sendAudioBuffer();
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recordSubscription?.cancel();
    _recordSubscription = null;
    await _recorder.stop();
    _sendBufferTimer?.cancel();
    _sendAudioBuffer(); // 发送剩余数据
  }

  void _sendAudioBuffer() {
    if (_audioBuffer.isNotEmpty && _channel != null) {
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
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
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
          // 1. 沉浸式径向渐变背景
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A3D2B), Color(0xFF050F08)],
              ),
            ),
          ),

          // 2. 地形纹理叠加层
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: TopographicPainter()),
            ),
          ),

          // 3. 主要内容区域
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        _buildAICharacter(),
                        const SizedBox(height: 40),
                        _buildSubtitleCard(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. 底部操作区域
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _hangUp,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDuration(_elapsedSeconds),
                style: const TextStyle(
                  fontSize: 22,
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

  Widget _buildAICharacter() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF71A66E).withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            Image.network(
              _aiAvatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(_default_ai_avatar, fit: BoxFit.cover),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // 仅在 AI 说话时显示指示器
        Opacity(
          opacity: _isAiSpeaking ? 1.0 : 0.0,
          child: const SpeakingIndicator(),
        ),
        const SizedBox(height: 16),
        Text(
          _isAiSpeaking ? 'AI 正在说话...' : '正在听取您的声音...',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitleCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          AnimatedOpacity(
            opacity: _subtitleOpacity,
            duration: const Duration(milliseconds: 500),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Text(
                    _subtitles.isEmpty ? '等待 AI 回复...' : _subtitles.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48, top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _toggleMic,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isMicOn ? Colors.white.withOpacity(0.15) : Colors.red.withOpacity(0.2),
                    border: Border.all(color: _isMicOn ? Colors.white.withOpacity(0.25) : Colors.red.withOpacity(0.5)),
                  ),
                  child: Icon(
                    _isMicOn ? Icons.mic : Icons.mic_off, 
                    color: _isMicOn ? Colors.white : Colors.redAccent, 
                    size: 24
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '麦克风',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _hangUp,
                child: Container(
                  height: 72,
                  width: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE53935), Color(0xFFC62828)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x8C000000),
                        blurRadius: 24,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '挂断',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
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
    // 绘制一些波浪线模拟地形纹理
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
      children: [
        _buildBar(10),
        const SizedBox(width: 5),
        _buildBar(20),
        const SizedBox(width: 5),
        _buildBar(30),
        const SizedBox(width: 5),
        _buildBar(18),
        const SizedBox(width: 5),
        _buildBar(12),
      ],
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
