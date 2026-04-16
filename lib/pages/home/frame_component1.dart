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
                image: AssetImage('assets/images/home/记忆卡片.png'),
                fit: BoxFit.fill, // 使用 fill 拉伸填满
              ),
            ),
          ),
        ),
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
