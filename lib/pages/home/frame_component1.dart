import 'package:flutter/material.dart';

class FrameComponent1 extends StatelessWidget {
  const FrameComponent1({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧：记忆卡片
        Expanded(
          child: SizedBox(
            height: 140, // 固定高度，宽度由 Expanded 自适应
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. 最底层：斜角边框图 (-15@2x)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home/-15@2x.png',
                    fit: BoxFit.fill,
                  ),
                ),
                // 2. 中间层：黄色格子内容底图 (-16@2x)
                // 原代码中相对边框有轻微的左侧位移
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 4,
                  right: 0,
                  child: Image.asset(
                    'assets/images/home/-16@2x.png',
                    fit: BoxFit.fill,
                  ),
                ),
                // 3. 上层：文字
                Positioned(
                  top: 16,
                  left: 14,
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
                            ..color = Colors.white,
                        ),
                      ),
                      const Text(
                        '记忆\n卡片',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: Color(0xFFFF9800), // 橘色
                        ),
                      ),
                    ],
                  ),
                ),
                // 4. 上层：3D 物品图案
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Image.asset(
                    'assets/images/home/3D-1@2x.png',
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
              image: const DecorationImage(
                image: AssetImage('assets/images/home/PK@2x.png'),
                fit: BoxFit.fill, // 使用 fill 拉伸填满
              ),
            ),
          ),
        ),
      ],
    );
  }
}
