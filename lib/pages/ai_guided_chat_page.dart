import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AiGuidedChatPage extends StatelessWidget {
  const AiGuidedChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8EC), // 浅绿色背景
      // 1. 顶部导航栏
      appBar: _buildAppBar(context),

      body: Stack(
        children: [
          // 2. 聊天内容区域
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 160),
            children: [
              _buildAiBubble(
                context,
                message: "Hello! How are you today?",
                translation: "你好！你今天过得怎么样？",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxO0JZA5GxGgzW8WQNz1ntF9xNUg9_SB64QKAXzuxW0ZchX_TLh1THmqKRtX3K1zuP1OOSOXC8bWI9SHefKSi1HYTbixRgPrQNHQ8j7ics6LZEJ0JyDu6ryZ8yjR7LIAfnXrtCiTHDRMNoUOQ38e1vt5amVBz2GigluhwRoq6kQcmQ148JhLnAlX8HvlLPvOJrOo5dj2w3_toZ1syQZCqV0dsiuCH1U2TkQPdXy7dd-3b4mi2n2GnNFvjZQ3X_TD0CoNupirRrHwVk',
              ),
              const SizedBox(height: 24),
              _buildUserBubble(
                context,
                message: "I am fine, thank you!",
                translation: "我挺好的，谢谢！",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDzs9GykjnkQeNn73Nyj4ObXT07n-PslY-0aswBKdr0kgxpSFu2jgVCGrugGIlY9eSUR5A5gL2w60AR7fEHx3KGZAZiUxth3YwNf5rzftHddfY5xwxrJGVYqNr1zSrFHHyqufPUqq-cxzRNUQYRSxHsTOq_cVqQfhws2zAU9bFjx5O8kSBJ1Cz_VZlVIJtYNuftkZ3fgCdGiUPnhd_nlL8VrNDazdkalBeUX0WofwAYWnSuxMjTxDy3vnWwDec4tN91F_iJgnDHVn6r',
              ),
              const SizedBox(height: 24),
              _buildAiBubble(
                context,
                message: "That's great! What did you do today?",
                translation: "太好了！你今天做了什么？",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnr2qITN-PxhsJpb3ETqKq0t0YDYCiZFhiCvf7WB2f1QlvnxDpCEQskZEM2xvM-LVqhrYICNnFXg4WQkrmjhD6oOHAlISXrNof02vpkqyJrguZSf_D9jUEJz0TtdcGmpaBg2bTjLtYHckJnmhs-aVN6pC7ceUg1YB6NpXiPt-wiH1zHkt9lQkXaEyfnwg9oua6r42j60sKeS59tYeC8zTUzCCGKkMW3KPtIC8tDeATHoUskaiu0lForDXLw4ErnPXshqfqblG3CqAT',
              ),
              const SizedBox(height: 24),
              _buildUserBubble(
                context,
                message: "I went to school.",
                translation: "我去上学了。",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAd9KBX1M6TWv1vCNjF_hY96lZjGdAbrhUuKn1mSLSITn0htzFJhpLi9iqvlrQ_IKY_hcx2G6V9xX9oS7QR0PROvg17-8u8h93Ti7jxwFgO2A5DktgZer4gWzicW-oNL6hVePnHUY2hJwnsOW6LXB3_5de03cYIWviTsmUnID3LhdAwRZScV__2fq7EOFXI5_Lk2Lj41I72hPONZNUGJt1yPS9ie77eizkgCU6ezQbNq4KrOx3dO_bX4Np6onZLLCeBcp4Xbj80AiBo',
              ),
              const SizedBox(height: 24),
              _buildAiBubble(
                context,
                message: "That's great! What did you do today?",
                translation: "太好了！你今天做了什么？",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnr2qITN-PxhsJpb3ETqKq0t0YDYCiZFhiCvf7WB2f1QlvnxDpCEQskZEM2xvM-LVqhrYICNnFXg4WQkrmjhD6oOHAlISXrNof02vpkqyJrguZSf_D9jUEJz0TtdcGmpaBg2bTjLtYHckJnmhs-aVN6pC7ceUg1YB6NpXiPt-wiH1zHkt9lQkXaEyfnwg9oua6r42j60sKeS59tYeC8zTUzCCGKkMW3KPtIC8tDeATHoUskaiu0lForDXLw4ErnPXshqfqblG3CqAT',
              ),
              const SizedBox(height: 24),
              _buildUserBubble(
                context,
                message: "I went to school.",
                translation: "我去上学了。",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAd9KBX1M6TWv1vCNjF_hY96lZjGdAbrhUuKn1mSLSITn0htzFJhpLi9iqvlrQ_IKY_hcx2G6V9xX9oS7QR0PROvg17-8u8h93Ti7jxwFgO2A5DktgZer4gWzicW-oNL6hVePnHUY2hJwnsOW6LXB3_5de03cYIWviTsmUnID3LhdAwRZScV__2fq7EOFXI5_Lk2Lj41I72hPONZNUGJt1yPS9ie77eizkgCU6ezQbNq4KrOx3dO_bX4Np6onZLLCeBcp4Xbj80AiBo',
              ),
              const SizedBox(height: 24),
              _buildAiBubble(
                context,
                message: "That's great! What did you do today?",
                translation: "太好了！你今天做了什么？",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnr2qITN-PxhsJpb3ETqKq0t0YDYCiZFhiCvf7WB2f1QlvnxDpCEQskZEM2xvM-LVqhrYICNnFXg4WQkrmjhD6oOHAlISXrNof02vpkqyJrguZSf_D9jUEJz0TtdcGmpaBg2bTjLtYHckJnmhs-aVN6pC7ceUg1YB6NpXiPt-wiH1zHkt9lQkXaEyfnwg9oua6r42j60sKeS59tYeC8zTUzCCGKkMW3KPtIC8tDeATHoUskaiu0lForDXLw4ErnPXshqfqblG3CqAT',
              ),
              const SizedBox(height: 24),
              _buildUserBubble(
                context,
                message: "I went to school.",
                translation: "我去上学了。",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAd9KBX1M6TWv1vCNjF_hY96lZjGdAbrhUuKn1mSLSITn0htzFJhpLi9iqvlrQ_IKY_hcx2G6V9xX9oS7QR0PROvg17-8u8h93Ti7jxwFgO2A5DktgZer4gWzicW-oNL6hVePnHUY2hJwnsOW6LXB3_5de03cYIWviTsmUnID3LhdAwRZScV__2fq7EOFXI5_Lk2Lj41I72hPONZNUGJt1yPS9ie77eizkgCU6ezQbNq4KrOx3dO_bX4Np6onZLLCeBcp4Xbj80AiBo',
              ),
              const SizedBox(height: 24),
              _buildAiBubble(
                context,
                message: "That's great! What did you do today?",
                translation: "太好了！你今天做了什么？",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnr2qITN-PxhsJpb3ETqKq0t0YDYCiZFhiCvf7WB2f1QlvnxDpCEQskZEM2xvM-LVqhrYICNnFXg4WQkrmjhD6oOHAlISXrNof02vpkqyJrguZSf_D9jUEJz0TtdcGmpaBg2bTjLtYHckJnmhs-aVN6pC7ceUg1YB6NpXiPt-wiH1zHkt9lQkXaEyfnwg9oua6r42j60sKeS59tYeC8zTUzCCGKkMW3KPtIC8tDeATHoUskaiu0lForDXLw4ErnPXshqfqblG3CqAT',
              ),
              const SizedBox(height: 24),
              _buildUserBubble(
                context,
                message: "I went to school.",
                translation: "我去上学了。",
                avatarUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAd9KBX1M6TWv1vCNjF_hY96lZjGdAbrhUuKn1mSLSITn0htzFJhpLi9iqvlrQ_IKY_hcx2G6V9xX9oS7QR0PROvg17-8u8h93Ti7jxwFgO2A5DktgZer4gWzicW-oNL6hVePnHUY2hJwnsOW6LXB3_5de03cYIWviTsmUnID3LhdAwRZScV__2fq7EOFXI5_Lk2Lj41I72hPONZNUGJt1yPS9ie77eizkgCU6ezQbNq4KrOx3dO_bX4Np6onZLLCeBcp4Xbj80AiBo',
              ),
            ],
          ),

          // 3. 底部录音区域
          _buildBottomActionArea(),
        ],
      ),
    );
  }

  // 顶部导航栏
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

  // AI 对话气泡
  Widget _buildAiBubble(
    BuildContext context, {
    required String message,
    required String translation,
    required String avatarUrl,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                Icon(
                  Icons.volume_up,
                  color: const Color(0xFF3D6620).withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 48), // 留白
      ],
    );
  }

  // 用户对话气泡
  Widget _buildUserBubble(
    BuildContext context, {
    required String message,
    required String translation,
    required String avatarUrl,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.volume_up,
                  color: const Color(0xFF1A3D2B).withOpacity(0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3D2B),
                        ),
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
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildAvatar(avatarUrl, const Color(0xFFC0F19A)),
      ],
    );
  }

  // 头像组件
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
      child: ClipOval(child: Image.network(url, fit: BoxFit.cover)),
    );
  }

  // 底部录音区域
  Widget _buildBottomActionArea() {
    return VoiceRecordButton(
      onRecordStart: () {
        print('UI 触发：开始录制音频流...');
        // TODO: 在这里调用你真实的 WebSocket 音频采集逻辑
      },
      onRecordStop: () {
        print('UI 触发：停止录音并发送结束信号...');
        // TODO: 在这里处理录音结束逻辑
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
