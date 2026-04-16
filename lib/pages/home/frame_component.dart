import 'package:flutter/material.dart';

class FrameComponent extends StatelessWidget {
  const FrameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 左侧：AI助手龙宝 + 按钮
        Expanded(
          flex: 11,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'AI助手龙宝OK',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // 【修改点】使用 GestureDetector 包裹龙宝图片，添加点击跳转逻辑
              GestureDetector(
                onTap: () {
                  // 点击触发路由跳转
                  Navigator.pushNamed(context, '/ai_home');
                },
                child: Image.asset(
                  'assets/images/home/3Ddragon.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 4),
              // 底部语音帮助按钮
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFFFB300), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/home/Bold-Volume-Small@2x.png",
                      width: 14,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "需要帮助请点我开启对话哦",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // 右侧：签到-任务中心 卡片
        Expanded(
          flex: 10,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD54F), width: 3),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.12, 1.0],
                colors: [
                  Color(0xFFFFC53D), // 0% 位置
                  Color(0xFFFFC743), // 12% 位置
                  Color(0xFFFDD473), // 100% 位置
                ],
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. 内部格子背景 (-14@2x)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9), // 圆角比外框略小一点
                    child: Image.asset(
                      'assets/images/home/-14@2x.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 2. 文字
                Positioned(
                  top: 14,
                  left: 10,
                  child: Stack(
                    children: [
                      Text(
                        '签到-任务\n中心',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = const Color(0xFFFFB300),
                        ),
                      ),
                      const Text(
                        '签到-任务\n中心',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // 3. 3D 日历图标
                Positioned(
                  bottom: -10, // 稍微溢出一点增加立体感
                  right: -8,
                  child: Image.asset('assets/images/home/3D@2x.png', width: 95),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
