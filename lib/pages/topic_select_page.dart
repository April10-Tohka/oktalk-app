import 'dart:ui';
import 'package:flutter/material.dart';

class TopicSelectPage extends StatelessWidget {
  const TopicSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 1. 全局线性渐变背景
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010101), // 顶部深黑
              Color(0xFF2D4F2B), // 底部深绿
            ],
            stops: [0.13, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 2. 自定义导航栏
              _buildAppBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // 3. 标题部分
                      const Text(
                        'Choose a Topic',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a category to start practicing',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 4. 话题网格 (2列)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0, // 正方形卡片
                        children: [
                          _buildTopicCard('👋', 'Greeting'),
                          _buildTopicCard('☀️', 'Daily Talk'),
                          _buildTopicCard('🍽️', 'Food Order'),
                          _buildTopicCard('✈️', 'Travel'),
                          _buildTopicCard('🛍️', 'Shopping'),
                          _buildTopicCard('🏥', 'Health'),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 5. 挑战横幅 (吉祥物)
                      // TODO: 看情况要不要
                      _buildChallengeBanner(),

                      const SizedBox(height: 120), // 为底部导航留出空间
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 导航栏组件
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFDC003),
            ), // 黄色箭头
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '单词练习',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 话题卡片组件 (毛玻璃效果)
  Widget _buildTopicCard(String emoji, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 挑战横幅组件
  Widget _buildChallengeBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFDC003).withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ready for a challenge?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Practice daily to unlock new special categories!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAi2KCXJ31F0WYJDa4QI1O8G5WQ1xki_nGKWMvTAfljZzK5jXfLfY2RAUWF1M9TgpV4WEQPCDTrg6N8aEHvc-ZG8n6RkwAPdhDKqkWMw6Fmgvt4wH9D02U4cAaXJjxN3dRYsCp34oPNvi3ZO-K9WWxzo8TLiFKEN-mDXfrqOWosfyvGxH8eIjuqdpyPX4TvyKQkHEjagYk4dp_JFLDxrrsnLRhyLJSSxbsrNcovZ5hkowdFUyvvFjARSeH4Gik9NWCv7bbCYgW-70ia',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
