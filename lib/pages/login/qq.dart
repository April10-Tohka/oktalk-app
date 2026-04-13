import 'package:flutter/material.dart';

import 'tokens.dart';

class QQ extends StatelessWidget {
  const QQ({super.key});

  // 提取一个公共方法，专门用来构建带有灰色圆圈边框的图标
  Widget _buildCircleIcon(String imagePath) {
    return Container(
      // padding 控制图标与灰色边框之间的距离，根据视觉效果可以微调
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle, // 设置为圆形
        border: Border.all(
          color: gainsboro, // 使用 tokens.dart 里的 #D9D9D9
          width: 2, // 边框粗细 2px
        ),
      ),
      child: Image.asset(imagePath, width: 32, height: 32),
    );
  }

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

        // 【新增】增加分割线和下方图标之间的垂直间距
        const SizedBox(height: 20),

        // 三个登录图标 - 使用 FittedBox + Row 防止溢出
        FittedBox(
          fit: BoxFit.scaleDown, // 如果空间不够就自动缩小
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 微信
              _buildCircleIcon('assets/images/微信.png'),

              // 因为外部加了 padding 和边框，图标整体变大了，所以这里的间距适当缩小到 30
              const SizedBox(width: 30),

              // QQ
              _buildCircleIcon('assets/images/qq.png'),
              const SizedBox(width: 30),

              // 苹果
              _buildCircleIcon('assets/images/苹果.png'),
            ],
          ),
        ),
      ],
    );
  }
}
