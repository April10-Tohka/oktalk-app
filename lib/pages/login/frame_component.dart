import 'package:flutter/material.dart';

import 'component1.dart';
import 'tokens.dart';

class FrameComponent extends StatelessWidget {
  const FrameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 332,
      padding: const EdgeInsets.only(left: 35, bottom: 60),
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: width322,
        height: 246,
        child: Flex(
          spacing: 40,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Container(
              width: 275.7,
              height: height25,
              padding: const EdgeInsets.only(left: 39),
              alignment: AlignmentDirectional.topStart,
              child: SizedBox(
                width: 236.7,
                height: height25,
                child: Row(
                  // 改用 Row，更直观
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 快速登陆
                    const Text(
                      '快速登陆',
                      style: TextStyle(
                        fontSize: fs16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: orange200,
                      ),
                    ),

                    const Spacer(), // ← 关键：自动推开两个文字
                    // 账号注册（往右移）
                    const Text(
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
            ),
            const Component1(),
          ],
        ),
      ),
    );
  }
}
