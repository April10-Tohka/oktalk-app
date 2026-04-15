import 'package:flutter/material.dart';

class FrameComponent1 extends StatelessWidget {
  const FrameComponent1({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧：记忆卡片
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/home/-16@2x.png'), // 黄色格子背景图
                fit: BoxFit.fill, // 填满容器
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 16,
                  left: 12,
                  child: Stack(
                    children: [
                      Text(
                        '记忆\n卡片',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.white, // 白色描边
                        ),
                      ),
                      const Text(
                        '记忆\n卡片',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: Color(0xFFFF9800), // 橘色文字
                        ),
                      ),
                    ],
                  ),
                ),
                // 底部 3D 物品图案
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Image.asset(
                    'assets/images/home/3D-1@2x.png', // 根据你提供的文件猜测是这图
                    width: 90,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 右侧：PK 赛区
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // 原设计图中 PK 赛区的内容已经融合在一张图里了
              image: const DecorationImage(
                image: AssetImage('assets/images/home/PK@2x.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
