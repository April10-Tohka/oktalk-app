import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class FreeTalkPage extends StatelessWidget {
  const FreeTalkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 沉浸式径向渐变背景
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF1A3D2B),
                  Color(0xFF050F08),
                ],
              ),
            ),
          ),

          // 2. 地形纹理叠加层 (Topographic Overlay)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(
                painter: TopographicPainter(),
              ),
            ),
          ),

          // 3. 主要内容区域 - 调整布局避免与底部按钮重叠
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                // 使用 Expanded 让中间内容占据可用空间，但向上对齐
                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(), // 禁用滚动，仅用于布局
                    child: Column(
                      children: [
                        const SizedBox(height: 100), // 顶部间距加大，内容向下移
                        _buildAICharacter(),
                        const SizedBox(height: 40), // AI 和字幕之间的间距
                        _buildSubtitleCard(),
                        const SizedBox(height: 100), // 关键：为底部按钮留出足够空间
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
          // 返回按钮放左边
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
            ),
          ),

          // 计时器居中
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '00:42',
                style: TextStyle(
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
            // 光晕背景 (Aura Glow)
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
            // 恐龙吉祥物
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAdOe38iKsPB3oQr-z1ofHdsU6WEG4DQ_mMibKq8CKOyj58WG0GHpyoOP3DrR-z8cH_QExTyiYK6d3hqU1W99vs2eGTUwtDrFja4dtGIel_PxT2LkhlCqXkPP6dC3DVABMrFW5pmKz9bZ7OEAV6NPKK8nLxx5AxHyxZ2ho6wrt7K5mtym-76lhLQV4Y7LrBzgwJRR38d0bRSN-hyfvsZNaG3rrn7O_-yqxsCa4LHFeEOMxAIw7E0RXzPuaIWuDvpKEP7hY1mvYbBD4S',
              height: 240,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const SizedBox(height: 32),
        // 说话指示器 (Speaking Indicator)
        const SpeakingIndicator(),
        const SizedBox(height: 16),
        Text(
          'AI 正在说话...',
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
          ClipRRect(
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
                  'How are you doing today? I hope you\'re having a wonderful day!',
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
          const SizedBox(height: 12),
          // Text(
          //   '字幕将在几秒后消失',
          //   style: GoogleFonts.plusJakartaSans(
          //     fontSize: 10,
          //     color: Colors.white.withOpacity(0.35),
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
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
          // 麦克风切换按钮
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 24),
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
          // 挂断按钮
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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