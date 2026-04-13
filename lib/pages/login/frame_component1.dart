import 'package:flutter/material.dart';

import 'qq.dart';
import 'tokens.dart';

class FrameComponent1 extends StatelessWidget {
  const FrameComponent1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width390,
      // 【关键修改】去掉死高度 height: 95
      padding: const EdgeInsets.symmetric(horizontal: 40), // 左右对称留白，让内部自然居中
      child: const QQ(),
    );
  }
}
