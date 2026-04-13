import 'package:flutter/material.dart';

import 'component1.dart';
import 'tokens.dart';

class FrameComponent extends StatelessWidget {
  const FrameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      // 【关键修改】去掉了写死的 height: 332
      padding: const EdgeInsets.only(left: 35, bottom: 20), // 稍微减小底部 padding
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: width322,
        // 【关键修改】去掉了写死的 height: 246
        child: Column(
          // 【关键修改】将 Flex 改为 Column
          mainAxisSize: MainAxisSize.min, // 自动包裹内容高度
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 275.7,
              padding: const EdgeInsets.only(
                top: 14,
                left: 39,
                bottom: 15,
              ), // 给标题加一点下边距
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 快速登陆
                  Text(
                    '快速登陆',
                    style: TextStyle(
                      fontSize: fs16,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: orange200,
                    ),
                  ),
                  Spacer(), // 自动推开两个文字
                  // 账号注册
                  Text(
                    '账号注册',
                    style: TextStyle(
                      fontSize: fs16,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: orange200,
                    ),
                  ),
                ],
              ),
            ),
            const Component1(),
          ],
        ),
      ),
    );
  }
}
