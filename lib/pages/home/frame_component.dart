import 'package:flutter/material.dart';

class FrameComponent extends StatelessWidget {
  const FrameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // 底部对齐
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
              // 将原来游离的龙宝图片移入此处
              Image.asset(
                'assets/images/home/3Ddragon.png',
                height: 120,
                fit: BoxFit.contain,
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
              image: const DecorationImage(
                image: AssetImage('assets/images/home/-14@2x.png'), // 黄橙色格子背景图
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 12,
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
                            ..color = const Color(0xFFFFB300), // 橘色描边
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
                Positioned(
                  bottom: 0,
                  right: -5,
                  child: Image.asset(
                    'assets/images/home/3D@2x.png',
                    width: 95,
                  ), // 3D日历图标
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
