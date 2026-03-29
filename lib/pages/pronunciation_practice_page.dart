import 'dart:ui';
import 'package:flutter/material.dart';

class PronunciationPracticePage extends StatelessWidget {
  const PronunciationPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 1. 全局背景：从黑到绿的线性渐变
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010101), // 顶部深黑
              Color(0xFF3D6620), // 底部深绿
            ],
            stops: [0.13, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. 顶部导航栏
              _buildHeader(context),

              // 3. 顶部进度条
              _buildProgressBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    children: [
                      // 4. 单词练习卡片 (毛玻璃效果)
                      _buildPracticeCard(),

                      const SizedBox(height: 40),

                      // 5. 录音按钮区域
                      _buildRecordingSection(),

                      const SizedBox(height: 40),

                      // 6. 反馈评分区域 (录音后显示)
                      _buildFeedbackSection(),

                      // const SizedBox(height: 120), // 为底部操作栏留空
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 7. 底部操作按钮
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  // 顶部标题栏
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          const Text(
            'Food - Word Practice',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '1 / 10',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 进度条
  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 4,
      color: Colors.white.withOpacity(0.1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 40, // 10% 进度
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFFFDC003), // 黄色进度
            borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
            boxShadow: [BoxShadow(color: Color(0x80FDC003), blurRadius: 8)],
          ),
        ),
      ),
    );
  }

  // 练习卡片 (毛玻璃)
  Widget _buildPracticeCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              // Container(
              //   width: 64,
              //   height: 64,
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.1),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Icon(
              //     Icons.headset,
              //     color: Colors.white70,
              //     size: 32,
              //   ),
              // ),
              // const SizedBox(height: 24),
              const Text(
                'Good morning',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '/ɡʊd ˈmɔːrnɪŋ/',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_circle_filled, color: Colors.black),
                label: const Text(
                  'Play Standard Audio',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 录音按钮
  Widget _buildRecordingSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // 脉冲动画装饰 (静态模拟)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 4,
                ),
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 36),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'TAP TO SPEAK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // 反馈评分区域
  Widget _buildFeedbackSection() {
    return Column(
      children: [
        // 星级
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 36,
              color: index < 4 ? const Color(0xFFFDC003) : Colors.white24,
            );
          }),
        ),
        const SizedBox(height: 24),
        // 纠错提示
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF95630).withOpacity(0.15),
            border: Border.all(color: const Color(0xFFF95630).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFF95630),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: '注意 '),
                      TextSpan(
                        text: "'oo'",
                        style: TextStyle(
                          color: Color(0xFFF95630),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' 的发音，嘴型更圆一些'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 录音对比行
        _buildComparisonRow(Icons.volume_up, '我的录音', const Color(0xFFB2E28D)),
      ],
    );
  }

  Widget _buildComparisonRow(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  // 底部操作栏
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            children: [
              // 再来一次
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('再试一次'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 下一条
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('下一条'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D6620),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                    elevation: 10,
                    shadowColor: const Color(0xFF3D6620).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
