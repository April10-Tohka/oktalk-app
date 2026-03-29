import 'dart:ui';
import 'package:flutter/material.dart';
import 'ai_chat_page.dart';
import 'smart_report_page.dart';
import 'free_talk_page.dart';

class AiAssistantPage extends StatelessWidget {
  const AiAssistantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0518, 0.6632, 1.0],
                colors: [
                  Color(0xFF3B6832),
                  Color(0xFFC7E29C),
                  Color(0xFFCDE082),
                ],
              ),
            ),
          ),

          // 2. 模糊光圈背景 (根据CSS参数通过叠加发光效果实现)
          Positioned(
            left: 150,
            top: 150,
            child: _buildBlurCircle(
              128,
              const Color.fromRGBO(76, 142, 63, 0.5),
            ),
          ),
          Positioned(
            left: 4,
            top: 278,
            child: _buildBlurCircle(
              239,
              const Color.fromRGBO(76, 142, 63, 0.3),
            ),
          ),
          Positioned(
            left: 139,
            top: 422,
            child: _buildBlurCircle(
              246,
              const Color.fromRGBO(217, 242, 102, 0.3),
            ),
          ),

          // 3. 主体内容区，使用 SafeArea 避开刘海屏
          SafeArea(
            child: Column(
              children: [
                // 顶部导航栏 (AppBar)
                _buildAppBar(),
                const SizedBox(height: 20),

                // 4个功能图标模块
                _buildFeatureIcons(context),

                // 中间的3D龙宝占位符区
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // 获取可用高度，计算合适的尺寸
                      final availableHeight = constraints.maxHeight;
                      final availableWidth = constraints.maxWidth;

                      // 取宽高中较小值的 65% 作为容器尺寸，确保不溢出
                      // 同时限制最小 200、最大 320，避免极端情况
                      final containerSize = (availableHeight * 0.65).clamp(
                        200.0,
                        320.0,
                      );
                      return Center(
                        child: Container(
                          width: containerSize,
                          height: containerSize,
                          child: Center(
                            child: Image.asset(
                              'assets/images/3Ddragon.png', // 替换成你真实的龙宝图片名称
                              width: containerSize * 0.95,
                              height: containerSize * 0.95,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 底部的毛玻璃卡片区域
                _buildBottomCard(context),
                const SizedBox(height: 34), // 底部指示条的安全距离适应
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底层由于设计要求的大基数模糊光圈
  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  /// 顶部导航行
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // 返回上一页
            },
          ),
          const Expanded(
            child: Center(
              child: const Text(
                'AI助手',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // IconButton 默认大约 48px
        ],
      ),
    );
  }

  /// 构建中间的四个功能图标区
  Widget _buildFeatureIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconItem(context, '了解OK', 'assets/images/AboutOK.png'),
          _buildIconItem(context, '智能报告', 'assets/images/AIReport.png'),
          _buildIconItem(context, '智能规划', 'assets/images/AISchedule.png'),
          _buildIconItem(context, 'OK衣橱', 'assets/images/closet.png'),
        ],
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (title == '智能报告') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SmartReportPage()),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.69),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 底部带毛玻璃、操作按钮及输入框的卡片
  Widget _buildBottomCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      // 叠加内外部阴影设计
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.57),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(145, 145, 145, 0.05),
            offset: Offset(-2, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color.fromRGBO(145, 145, 145, 0.04),
            offset: Offset(-7, 17),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 毛玻璃特效
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '你好，我是你的AI小助手~',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B9910),
                  ),
                ),
                const SizedBox(height: 18),

                // 单行可滑动或灵活排列的3个操作标签
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTagButton(
                        context,
                        '自由说',
                        const Color.fromRGBO(255, 185, 35, 0.54),
                      ),
                      const SizedBox(width: 8),
                      _buildTagButton(context, 'AI纠音', const Color(0xFF93D020)),
                      const SizedBox(width: 8),
                      _buildTagButton(context, '一句一句', const Color(0xFF93D020)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // // 底部输入/语音唤醒条区
                // Container(
                //   height: 56.92,
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.71),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // 左侧语音图标
                //       const Icon(Icons.mic, color: Color(0xFF0B3D03), size: 28),
                //       // 右侧键盘按钮
                //       Container(
                //         padding: const EdgeInsets.all(6),
                //         decoration: const BoxDecoration(
                //           color: Color(0xFF0B3D03),
                //           shape: BoxShape.circle,
                //         ),
                //         child: const Icon(
                //           Icons.grid_view_sharp,
                //           color: Colors.white,
                //           size: 16,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 封装圆角小标签组件
  Widget _buildTagButton(BuildContext context, String text, Color bgColor) {
    return GestureDetector(
      onTap: () {
        if (text == '一句一句') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiChatPage()),
          );
        } else if (text == '自由说') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FreeTalkPage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        height: 39,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
