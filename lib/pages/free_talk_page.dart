/*
 * =========================================================================
 * 依赖说明 (Dependencies Requirement)
 * 请在项目的 pubspec.yaml 中添加下述依赖（或在终端运行相应的 flutter pub add 命令）
 * 推荐版本：
 * dependencies:
 *   web_socket_channel: ^3.0.0      // 用于 WebSocket 通信
 *   record: ^5.0.0                  // 用于捕获麦克风原始 PCM 音频流
 *   sound_stream: ^4.0.0            // 用于直接播放 PCM 字节流，如果报错可尝试 flutter_sound 等其他库
 *   permission_handler: ^11.0.0     // 用于获取麦克风权限
 * =========================================================================
 */
// ignore_for_file: unused_field, unused_element, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// 若未在 pubspec.yaml 引入，以下包可能会报错。请确认引入后取消这些注释。
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:record/record.dart';
// import 'package:sound_stream/sound_stream.dart';

class FreeTalkPage extends StatefulWidget {
  const FreeTalkPage({Key? key}) : super(key: key);

  @override
  State<FreeTalkPage> createState() => _FreeTalkPageState();
}

class _FreeTalkPageState extends State<FreeTalkPage> {
  // === UI 状态 ===
  bool _isMicOn = true;
  String _subtitleText = '';
  bool _showSubtitle = false;
  Timer? _subtitleFadeTimer;

  // === 音频与网络底层状态（类型占位声明） ===
  // late WebSocketChannel _channel;
  // final _audioRecorder = AudioRecorder();
  // PlayerStream _playerStream = PlayerStream();
  StreamSubscription? _recordSub;

  // 用于收集 PCM 数据，达到约 200ms 再发送 (16000采样率 * 16bit * 1声道 = 32000 bytes/s -> 200ms = 6400 bytes)
  final int _chunkSize = 6400;
  List<int> _pcmBuffer = [];

  @override
  void initState() {
    super.initState();
    _initWebSocketAndAudio();
  }

  /// 1. 初始化 WebSocket 与 音频流
  Future<void> _initWebSocketAndAudio() async {
    // 建立 WebSocket 连接
    // _channel = WebSocketChannel.connect(Uri.parse('ws://your_backend_url/ws'));
    // _channel.stream.listen(_handleIncomingMessage, onError: (e) {
    //   print("WS Error: $e");
    // }, onDone: () {
    //   print("WS Closed");
    // });

    // 初始化播放器
    // await _playerStream.initialize();

    // 获取麦克风流并开启录音
    if (_isMicOn) {
      _startRecordingStream();
    }
  }

  /// 开始采集音频流
  Future<void> _startRecordingStream() async {
    // bool hasPermission = await _audioRecorder.hasPermission();
    // if (!hasPermission) return;

    // 监听 PCM 16kHz 16bit 单声道流
    // final stream = await _audioRecorder.startStream(
    //   const RecordConfig(
    //     encoder: AudioEncoder.pcm16bits,
    //     sampleRate: 16000,
    //     numChannels: 1,
    //   ),
    // );

    // _recordSub = stream.listen((data) {
    //   if (!_isMicOn) return; // 静音状态不发送

    //   _pcmBuffer.addAll(data);
    //   if (_pcmBuffer.length >= _chunkSize) {
    //     _sendAudioChunk(_pcmBuffer);
    //     _pcmBuffer.clear();
    //   }
    // });
  }

  /// 停止采集流
  Future<void> _stopRecordingStream() async {
    await _recordSub?.cancel();
    // await _audioRecorder.stop();
  }

  /// 2. 构建并发送 200ms 音频帧
  void _sendAudioChunk(List<int> pcmBytes) {
    // 将 PCM 字节数组转成 Base64
    final base64Audio = base64Encode(pcmBytes);
    final payload = {"type": "audio", "data": base64Audio};
    print("Sent audio chunk of size \${pcmBytes.length} bytes");
    // 按需求可能还会序列化成二进制流，这里是基于JSON混合传输的基础示例
    // _channel.sink.add(jsonEncode(payload));
  }

  /// 3. 解析从 WebSocket 返回的消息分发处理 (后端 -> App)
  void _handleIncomingMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message);
      final String type = data['type'] ?? '';

      if (type == 'llm_text') {
        // [处理字幕]
        final String text = data['text'] ?? '';
        _updateSubtitle(text);
      } else if (type == 'tts_audio') {
        // [处理语音]
        final String base64Payload = data['data'] ?? '';
        if (base64Payload.isNotEmpty) {
          final Uint8List pcmData = base64Decode(base64Payload);
          // 实时送入播放器队列
          // _playerStream.writeChunk(pcmData);
        }
      }
    } catch (e) {
      debugPrint("Message parsing error: \$e");
    }
  }

  /// 更新字幕，并重置 5 秒的淡出隐藏定时器
  void _updateSubtitle(String text) {
    setState(() {
      _subtitleText = text;
      _showSubtitle = true;
    });

    // 如果之前有计时器，取消它
    _subtitleFadeTimer?.cancel();

    // 重新开启 5 秒倒计时
    _subtitleFadeTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showSubtitle = false;
        });
      }
    });
  }

  /// 离开页面时的深度资源清理
  @override
  void dispose() {
    _subtitleFadeTimer?.cancel();
    _stopRecordingStream();
    // _playerStream.stop();
    // _channel.sink.close();
    // _audioRecorder.dispose();
    super.dispose();
  }

  // === 交互操作 ===

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
    // 静音/开启麦克风均在此切换；实际物理流收集已在 listen 层通过 _isMicOn 状态进行拦截。
  }

  void _hangUp() {
    // 退出并销毁页面从而触发 dispose 彻底断开流
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1305, 1.0],
            colors: [Color(0xFF010101), Color(0xFF71A66E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部区域：返回按钮
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: _hangUp,
                    ),
                  ],
                ),
              ),

              // 中部内容区：龙宝 3D 图像与字幕框
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 放大显示的 AI 龙宝
                    Image.asset(
                      'assets/images/3Ddragon.png', // 龙宝图片资源占用
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 半透明黑色圆角字幕框，由 _showSubtitle 控制淡入淡出动画
                    AnimatedOpacity(
                      opacity: _showSubtitle ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _subtitleText.isEmpty ? "等待语音..." : _subtitleText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 底部控制区：麦克风与挂断
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 左侧：麦克风切换
                    _buildControlButton(
                      onTap: _toggleMic,
                      icon: _isMicOn ? Icons.mic : Icons.mic_off,
                      backgroundColor: _isMicOn
                          ? Colors.greenAccent.shade400
                          : Colors.grey.shade700,
                      iconColor: Colors.white,
                    ),
                    const SizedBox(width: 40),
                    // 右侧：挂断退出 (红色)
                    _buildControlButton(
                      onTap: _hangUp,
                      icon: Icons.call_end,
                      backgroundColor: Colors.redAccent,
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 32),
      ),
    );
  }
}
