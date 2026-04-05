import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 新增引入
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'guided_chat_summary_page.dart';

// 1. 定义一个简单的数据模型，用来装载消息
class ChatMessage {
  final bool isUser;
  final String message;
  final String translation;
  final String avatarUrl;
  final String audioUrl; // 新增：音频的 OSS URL

  ChatMessage({
    required this.isUser,
    required this.message,
    required this.translation,
    required this.avatarUrl,
    required this.audioUrl,
  });
}

// 2. 将页面改为 StatefulWidget，以便管理列表状态和滚动控制器
class AiGuidedChatPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final Map<String, dynamic> startData;

  const AiGuidedChatPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.startData,
  });

  @override
  State<AiGuidedChatPage> createState() => _AiGuidedChatPageState();
}

class _AiGuidedChatPageState extends State<AiGuidedChatPage> {
  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  // 核心：滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 新增：创建一个音频播放器实例
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  static const String _aiAvatarUrl =
      'https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/3Ddragon.png';
  static const String _userAvatarUrl =
      'https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/default_user_avatar.jpg';
  static const String _default_ai_avatar =
      'assets/images/default_ai_avatar.png';
  static const String _default_user_avatar =
      'assets/images/default_user_avatar.jpg';

  bool _isLoading = true;
  String? _error;
  bool _isRequesting = false;
  String? _recordingFilePath;

  late final String _sessionId;
  late int _currentStep;
  late String _question;
  late String _questionAudioUrl;

  // 动态消息列表（从后端 history 初始化）
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    final start = widget.startData;
    _sessionId = (start['session_id'] ?? '').toString();
    _currentStep = int.tryParse((start['current_step'] ?? 1).toString()) ?? 1;
    _question = (start['question'] ?? '').toString();
    _questionAudioUrl = (start['question_audio_url'] ?? '').toString();

    _init();
  }

  Future<void> _init() async {
    await _fetchHistory();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_questionAudioUrl.isNotEmpty) {
        _playAudio(_questionAudioUrl);
      }
    });
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _messages.clear();
    });
    try {
      final uri = Uri.parse(
        '$_apiBaseUrl/api/v1/scene/session/$_sessionId/history',
      );
      final res = await http.get(uri);
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? '加载历史失败');
      }
      final data = decoded['data'] as Map<String, dynamic>;
      final list = data['messages'];
      final messages = list is List ? list : <dynamic>[];

      final built = <ChatMessage>[];
      for (final item in messages) {
        if (item is! Map) continue;
        final m = Map<String, dynamic>.from(item);
        final userText = (m['user_text'] ?? '').toString();
        final userAudioUrl = (m['user_audio_url'] ?? '').toString();
        final aiText = (m['ai_reply_text'] ?? '').toString();
        final aiAudioUrl = (m['ai_audio_url'] ?? '').toString();
        final translation = (m['translation'] ?? '').toString();

        if (userText.isNotEmpty) {
          built.add(
            ChatMessage(
              isUser: true,
              message: userText,
              translation: translation,
              avatarUrl: _userAvatarUrl,
              audioUrl: userAudioUrl,
            ),
          );
        }
        if (aiText.isNotEmpty) {
          built.add(
            ChatMessage(
              isUser: false,
              message: aiText,
              translation: '',
              avatarUrl: _aiAvatarUrl,
              audioUrl: aiAudioUrl,
            ),
          );
        }
      }

      if (!mounted) return;
      setState(() {
        _messages.addAll(built);
        // 总是添加 startData 中的当前问题（无论历史是否为空）
        if (_question.isNotEmpty) {
          _messages.add(
            ChatMessage(
              isUser: false,
              message: _question,
              translation: '',
              avatarUrl: _aiAvatarUrl,
              audioUrl: _questionAudioUrl,
            ),
          );
        }
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioPlayer.dispose(); // 新增：页面销毁时释放播放器资源
    _audioRecorder.dispose();
    super.dispose();
  }

  // 新增：播放音频的核心方法
  Future<void> _playAudio(String url) async {
    if (url.isEmpty) return;
    try {
      // 每次播放前先停止上一条可能还在播放的语音，防止声音重叠
      await _audioPlayer.stop();
      // 创建一个 Completer 来等待播放完成
      final completer = Completer<void>();

      // 设置完成监听器
      late StreamSubscription<void> subscription;
      subscription = _audioPlayer.onPlayerComplete.listen((_) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        subscription.cancel();
      });
      // 直接播放网络 URL
      await _audioPlayer.play(UrlSource(url));
      // 等待播放完成
      await completer.future;
    } catch (e) {
      debugPrint("播放音频失败: $e");
    }
  }

  Future<void> _startRecording() async {
    if (_isRequesting) return;

    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('需要麦克风权限才能录音')));
        return;
      }
    }

    if (!await _audioRecorder.hasPermission()) return;

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/scene_record_${DateTime.now().millisecondsSinceEpoch}.wav';
      _recordingFilePath = filePath;

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('录音启动失败: $e');
    }
  }

  Future<void> _stopRecordingAndSend() async {
    if (_isRequesting) return;
    try {
      final path = await _audioRecorder.stop();
      final filePath = path ?? _recordingFilePath;
      if (filePath == null || filePath.isEmpty) return;
      await _sendNext(filePath);
    } catch (e) {
      debugPrint('录音停止失败: $e');
    } finally {
      _recordingFilePath = null;
    }
  }

  Future<void> _sendNext(String filePath) async {
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF3D6620)),
      ),
    );

    bool isCompleted = false;

    try {
      final uri = Uri.parse('$_apiBaseUrl/api/v1/scene/session/next');
      final req = http.MultipartRequest('POST', uri);
      req.fields['session_id'] = _sessionId;
      req.fields['step_id'] = _currentStep.toString();
      req.fields['audio_type'] = 'wav';
      req.files.add(await http.MultipartFile.fromPath('audio_file', filePath));

      final streamed = await req.send();
      final body = await streamed.stream.bytesToString();
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      if (decoded['code'] != 200) {
        throw Exception(decoded['message'] ?? 'next failed');
      }

      final data = decoded['data'] as Map<String, dynamic>;
      final userText = (data['user_text'] ?? '').toString();
      final userAudioUrl = (data['user_audio_url'] ?? '').toString();
      final aiReplyText = (data['ai_reply_text'] ?? '').toString();
      final aiAudioUrl = (data['ai_audio_url'] ?? '').toString();
      final stepAdvanced = data['step_advanced'] == true;
      final sceneCompleted = data['scene_completed'] == true;
      final currentStep =
          int.tryParse((data['current_step'] ?? _currentStep).toString()) ??
          _currentStep;
      final nextQuestion = (data['next_question'] ?? '').toString();
      final nextQuestionAudioUrl = (data['next_question_audio_url'] ?? '')
          .toString();

      if (!mounted) return;
      // 1. 先添加用户消息和 AI 回复消息到界面
      setState(() {
        if (userText.isNotEmpty) {
          _messages.add(
            ChatMessage(
              isUser: true,
              message: userText,
              translation: '',
              avatarUrl: _userAvatarUrl,
              audioUrl: userAudioUrl,
            ),
          );
        }
        if (aiReplyText.isNotEmpty) {
          _messages.add(
            ChatMessage(
              isUser: false,
              message: aiReplyText,
              translation: '',
              avatarUrl: _aiAvatarUrl,
              audioUrl: aiAudioUrl,
            ),
          );
        }
        _currentStep = currentStep;
      });
      _scrollToBottom();

      // 2. 播放 AI 回复的音频，并等待播放完成
      if (aiAudioUrl.isNotEmpty) {
        await _playAudio(aiAudioUrl);
      }

      // 3. 等 AI 回复音频播放完成后，再添加并播放下一个问题
      if (nextQuestion.isNotEmpty && nextQuestionAudioUrl.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _question = nextQuestion;
          _questionAudioUrl = nextQuestionAudioUrl;
          _messages.add(
            ChatMessage(
              isUser: false,
              message: nextQuestion,
              translation: '',
              avatarUrl: _aiAvatarUrl,
              audioUrl: nextQuestionAudioUrl,
            ),
          );
        });
        _scrollToBottom();
        // 播放下一个问题的音频，并等待完成
        await _playAudio(nextQuestionAudioUrl);
      }

      // 4. 如果 sceneCompleted 为 true，记录状态并停止播放器
      if (sceneCompleted) {
        debugPrint("查看sceneComplete:$sceneCompleted");
        await _audioPlayer.stop();
        isCompleted = true;
      }
    } catch (e) {
      debugPrint('调用 next 失败: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('发送失败：$e')));
    } finally {
      if (mounted) {
        Navigator.pop(context);
        setState(() => _isRequesting = false);
      }
    }

    // 5. 在弹窗关闭后，执行页面跳转
    if (isCompleted && mounted) {
      debugPrint("页面跳转到GuidedChatSummaryPage,传递的参数为$_sessionId");
      debugPrint(widget.title);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              GuidedChatSummaryPage(sessionId: _sessionId, title: widget.title),
        ),
      );
    }
  }

  // 核心功能：丝滑滚动到最底部
  void _scrollToBottom() {
    // 延迟到当前帧渲染结束后再执行滚动，确保能获取到最新的列表高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // 滚动到最大高度
          duration: const Duration(milliseconds: 300), // 滚动动画时长
          curve: Curves.easeOut, // 动画曲线，显得更自然
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EC), // 浅绿色背景
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // 聊天内容区域
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF3D6620)),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _fetchHistory,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3D6620),
                      ),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              controller: _scrollController, // 绑定控制器！
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
              itemCount: _messages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg.isUser) {
                  return _buildUserBubble(
                    context,
                    message: msg.message,
                    translation: msg.translation,
                    avatarUrl: msg.avatarUrl,
                    audioUrl: msg.audioUrl,
                  );
                } else {
                  return _buildAiBubble(
                    context,
                    message: msg.message,
                    translation: msg.translation,
                    avatarUrl: msg.avatarUrl,
                    audioUrl: msg.audioUrl,
                  );
                }
              },
            ),
          // 底部录音区域
          _buildBottomActionArea(),
        ],
      ),
    );
  }

  // 顶部导航栏 (保持不变)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF3D6620)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.subtitle}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // AI 对话气泡 (略微调整了喇叭的位置对齐)
  Widget _buildAiBubble(
    BuildContext context, {
    required String message,
    required String translation,
    required String avatarUrl,
    required String audioUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(avatarUrl, const Color(0xFFFDC003), isAI: true),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFC0F19A), width: 2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _playAudio(audioUrl), // 点击时调用播放方法
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                        ), // 扩大一点点击热区
                        child: Icon(
                          Icons.volume_up,
                          color: const Color(0xFF3D6620).withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  translation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 48), // 留白
      ],
    );
  }

  // 用户对话气泡 (略微调整了喇叭的位置对齐)
  Widget _buildUserBubble(
    BuildContext context, {
    required String message,
    required String translation,
    required String avatarUrl,
    required String audioUrl,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 48), // 留白
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC8EFC8), Color(0xFFA8DFA8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _playAudio(audioUrl), // 点击时调用播放方法
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                        ), // 扩大一点点击热区
                        child: Icon(
                          Icons.volume_up,
                          color: const Color(0xFF3D6620).withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3D2B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  translation,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF1A3D2B).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildAvatar(avatarUrl, const Color(0xFFC0F19A), isAI: false),
      ],
    );
  }

  // 头像组件 (保持不变)
  Widget _buildAvatar(String url, Color borderColor, {required bool isAI}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        // 这里为了防报错加了 errorBuilder，你可以替换成真实的默认头像
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            isAI ? _default_ai_avatar : _default_user_avatar,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // 底部录音区域
  Widget _buildBottomActionArea() {
    return VoiceRecordButton(
      onRecordStart: _startRecording,
      onRecordStop: _stopRecordingAndSend,
    );
  }
}

// 独立的动态录音按钮组件
class VoiceRecordButton extends StatefulWidget {
  final Future<void> Function() onRecordStart;
  final Future<void> Function() onRecordStop;

  const VoiceRecordButton({
    Key? key,
    required this.onRecordStart,
    required this.onRecordStop,
  }) : super(key: key);

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // 初始化波浪动画控制器，800毫秒为一个周期
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  // 按下开始录音
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isRecording = true;
    });
    _waveController.repeat(); // 开启波浪循环动画
    widget.onRecordStart();
  }

  // 松开手指或移出按钮区域结束录音
  void _handleTapUp(TapUpDetails details) => _stopRecording();
  void _handleTapCancel() => _stopRecording();

  void _stopRecording() {
    if (!_isRecording) return;
    setState(() {
      _isRecording = false;
    });
    _waveController.reset(); // 停止波浪
    widget.onRecordStop();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            // 1. 实现按压回弹的缩小效果
            child: AnimatedScale(
              scale: _isRecording ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              // 2. 实现颜色和阴影的平滑过渡
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  // 录音时颜色变深
                  color: _isRecording
                      ? const Color(0xFF009AA6)
                      : const Color(0xFF00C4D1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00C4D1,
                      ).withOpacity(_isRecording ? 0.1 : 0.3),
                      blurRadius: _isRecording ? 4 : 10,
                      offset: Offset(0, _isRecording ? 2 : 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 左侧白色圆圈区域
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        // 根据状态切换：录音时显示波浪，否则显示麦克风
                        child: _isRecording
                            ? _buildWaveAnimation()
                            : const Icon(
                                Icons.mic,
                                color: Color(0xFF00C4D1),
                                size: 20,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 右侧文字动态切换
                    Text(
                      _isRecording ? '松开 发送...' : '按住说话',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 3. 纯原生手绘的丝滑波浪组件
  Widget _buildWaveAnimation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            // 利用正弦函数计算出每个跳动柱子的高度，加上 index 产生波浪落差感
            final t = _waveController.value * 2 * math.pi;
            final height = 8 + 6 * math.sin(t + index * 1.5);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: height.clamp(4.0, 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF009AA6), // 波浪的颜色
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}
