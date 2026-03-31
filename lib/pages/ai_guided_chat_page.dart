import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 新增引入

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
  const AiGuidedChatPage({super.key});

  @override
  State<AiGuidedChatPage> createState() => _AiGuidedChatPageState();
}

class _AiGuidedChatPageState extends State<AiGuidedChatPage> {
  // 核心：滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 新增：创建一个音频播放器实例
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 动态消息列表（初始化放入一些历史聊天记录）
  final List<ChatMessage> _messages = [
    ChatMessage(
      isUser: false,
      message: "Hello! How are you today?",
      translation: "你好！你今天过得怎么样？",
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBxO0JZA5GxGgzW8WQNz1ntF9xNUg9_SB64QKAXzuxW0ZchX_TLh1THmqKRtX3K1zuP1OOSOXC8bWI9SHefKSi1HYTbixRgPrQNHQ8j7ics6LZEJ0JyDu6ryZ8yjR7LIAfnXrtCiTHDRMNoUOQ38e1vt5amVBz2GigluhwRoq6kQcmQ148JhLnAlX8HvlLPvOJrOo5dj2w3_toZ1syQZCqV0dsiuCH1U2TkQPdXy7dd-3b4mi2n2GnNFvjZQ3X_TD0CoNupirRrHwVk',
      audioUrl:
          'https://oktalk.oss-cn-heyuan.aliyuncs.com/scene/0420b0b4-9167-47f5-8a42-3a91c53539a8/ai_50103999-f8a5-4a69-93e9-b3bd4350afa4.wav?Expires=1774802243&OSSAccessKeyId=TMP.3KvUVTtM1QdeTPhkJaTLCG7gzPv8E1HVtdymnj3EuB2Ct74V4f3FyhVsZn2qFXrPbyifsS8ay7zzvgHvWTWakNUnKQ1sWP&Signature=BS%2Fzs%2B9Ha45Z4WsjG07CRpLxy0A%3D',
    ),
    ChatMessage(
      isUser: true,
      message: "I am fine, thank you!",
      translation: "我挺好的，谢谢！",
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDzs9GykjnkQeNn73Nyj4ObXT07n-PslY-0aswBKdr0kgxpSFu2jgVCGrugGIlY9eSUR5A5gL2w60AR7fEHx3KGZAZiUxth3YwNf5rzftHddfY5xwxrJGVYqNr1zSrFHHyqufPUqq-cxzRNUQYRSxHsTOq_cVqQfhws2zAU9bFjx5O8kSBJ1Cz_VZlVIJtYNuftkZ3fgCdGiUPnhd_nlL8VrNDazdkalBeUX0WofwAYWnSuxMjTxDy3vnWwDec4tN91F_iJgnDHVn6r',
      audioUrl:
          'https://oktalk.oss-cn-heyuan.aliyuncs.com/scene/0420b0b4-9167-47f5-8a42-3a91c53539a8/ai_50103999-f8a5-4a69-93e9-b3bd4350afa4.wav?Expires=1774802243&OSSAccessKeyId=TMP.3KvUVTtM1QdeTPhkJaTLCG7gzPv8E1HVtdymnj3EuB2Ct74V4f3FyhVsZn2qFXrPbyifsS8ay7zzvgHvWTWakNUnKQ1sWP&Signature=BS%2Fzs%2B9Ha45Z4WsjG07CRpLxy0A%3D',
    ),
    ChatMessage(
      isUser: false,
      message: "That's great! What did you do today?",
      translation: "太好了！你今天做了什么？",
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBnr2qITN-PxhsJpb3ETqKq0t0YDYCiZFhiCvf7WB2f1QlvnxDpCEQskZEM2xvM-LVqhrYICNnFXg4WQkrmjhD6oOHAlISXrNof02vpkqyJrguZSf_D9jUEJz0TtdcGmpaBg2bTjLtYHckJnmhs-aVN6pC7ceUg1YB6NpXiPt-wiH1zHkt9lQkXaEyfnwg9oua6r42j60sKeS59tYeC8zTUzCCGKkMW3KPtIC8tDeATHoUskaiu0lForDXLw4ErnPXshqfqblG3CqAT',
      audioUrl:
          'https://oktalk.oss-cn-heyuan.aliyuncs.com/scene/0420b0b4-9167-47f5-8a42-3a91c53539a8/ai_50103999-f8a5-4a69-93e9-b3bd4350afa4.wav?Expires=1774802243&OSSAccessKeyId=TMP.3KvUVTtM1QdeTPhkJaTLCG7gzPv8E1HVtdymnj3EuB2Ct74V4f3FyhVsZn2qFXrPbyifsS8ay7zzvgHvWTWakNUnKQ1sWP&Signature=BS%2Fzs%2B9Ha45Z4WsjG07CRpLxy0A%3D',
    ),
    ChatMessage(
      isUser: true,
      message: "I went to school.",
      translation: "我去上学了。",
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAd9KBX1M6TWv1vCNjF_hY96lZjGdAbrhUuKn1mSLSITn0htzFJhpLi9iqvlrQ_IKY_hcx2G6V9xX9oS7QR0PROvg17-8u8h93Ti7jxwFgO2A5DktgZer4gWzicW-oNL6hVePnHUY2hJwnsOW6LXB3_5de03cYIWviTsmUnID3LhdAwRZScV__2fq7EOFXI5_Lk2Lj41I72hPONZNUGJt1yPS9ie77eizkgCU6ezQbNq4KrOx3dO_bX4Np6onZLLCeBcp4Xbj80AiBo',
      audioUrl:
          'https://oktalk.oss-cn-heyuan.aliyuncs.com/scene/0420b0b4-9167-47f5-8a42-3a91c53539a8/ai_50103999-f8a5-4a69-93e9-b3bd4350afa4.wav?Expires=1774802243&OSSAccessKeyId=TMP.3KvUVTtM1QdeTPhkJaTLCG7gzPv8E1HVtdymnj3EuB2Ct74V4f3FyhVsZn2qFXrPbyifsS8ay7zzvgHvWTWakNUnKQ1sWP&Signature=BS%2Fzs%2B9Ha45Z4WsjG07CRpLxy0A%3D',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _audioPlayer.dispose(); // 新增：页面销毁时释放播放器资源
    super.dispose();
  }

  // 新增：播放音频的核心方法
  Future<void> _playAudio(String url) async {
    try {
      // 每次播放前先停止上一条可能还在播放的语音，防止声音重叠
      await _audioPlayer.stop();
      // 直接播放网络 URL
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print("播放音频失败: $e");
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

  // 模拟发送新消息的逻辑
  void _sendNewMessage(String text, String translation) {
    setState(() {
      _messages.add(
        ChatMessage(
          isUser: true,
          message: text,
          translation: translation,
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDzs9GykjnkQeNn73Nyj4ObXT07n-PslY-0aswBKdr0kgxpSFu2jgVCGrugGIlY9eSUR5A5gL2w60AR7fEHx3KGZAZiUxth3YwNf5rzftHddfY5xwxrJGVYqNr1zSrFHHyqufPUqq-cxzRNUQYRSxHsTOq_cVqQfhws2zAU9bFjx5O8kSBJ1Cz_VZlVIJtYNuftkZ3fgCdGiUPnhd_nlL8VrNDazdkalBeUX0WofwAYWnSuxMjTxDy3vnWwDec4tN91F_iJgnDHVn6r',
          audioUrl: '',
        ),
      );
    });
    _scrollToBottom(); // 消息添加后，立即触发滚动到底部
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EC), // 浅绿色背景
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // 聊天内容区域
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
          const Text(
            'Greeting',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '学习如何打招呼',
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
        _buildAvatar(avatarUrl, const Color(0xFFFDC003)),
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
        _buildAvatar(avatarUrl, const Color(0xFFC0F19A)),
      ],
    );
  }

  // 头像组件 (保持不变)
  Widget _buildAvatar(String url, Color borderColor) {
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
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, color: borderColor),
        ),
      ),
    );
  }

  // 底部录音区域
  Widget _buildBottomActionArea() {
    return VoiceRecordButton(
      onRecordStart: () {
        print('UI 触发：开始录制音频流...');
      },
      onRecordStop: () {
        print('UI 触发：停止录音并发送结束信号...');
        // 测试：模拟录音结束后发送了一条新消息
        _sendNewMessage("I want to play games.", "我想玩游戏。");
      },
    );
  }
}

// 独立的动态录音按钮组件
class VoiceRecordButton extends StatefulWidget {
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;

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
