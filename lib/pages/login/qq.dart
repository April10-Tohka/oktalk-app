import 'package:flutter/material.dart';

import 'tokens.dart';

class QQ extends StatelessWidget {
  const QQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // “其他登录方式” 分割线
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container(height: 1, color: gainsboro)),
            const SizedBox(width: 12),
            const Text(
              '其他登陆方式',
              style: TextStyle(
                fontSize: fs10,
                fontFamily: 'PingFang SC',
                height: 1.4,
                color: darkgray,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: gainsboro)),
          ],
        ),

        // 三个登录图标 - 使用 FittedBox + Row 防止溢出
        FittedBox(
          fit: BoxFit.scaleDown, // ← 关键：如果空间不够就自动缩小
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 微信
              Image.asset('assets/images/微信.png', width: 32, height: 32),
              const SizedBox(width: 40),

              // QQ
              Image.asset('assets/images/qq.png', width: 32, height: 32),
              const SizedBox(width: 40),

              // 苹果
              Image.asset('assets/images/苹果.png', width: 32, height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
