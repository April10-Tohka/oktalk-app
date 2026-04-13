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
      padding: const EdgeInsets.only(left: 35, bottom: 86),
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: width322,
        height: 246,
        child: Flex(
          spacing: 90,
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
                child: Flex(
                  spacing: 111.1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      width: 62.9,
                      height: height25,
                      padding: const EdgeInsets.only(top: padding4),
                      alignment: AlignmentDirectional.topStart,
                      child: const SizedBox(
                        width: 62.9,
                        height: 21,
                        child: Text(
                          '快速登陆\n',
                          style: TextStyle(
                            fontSize: fs16,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 11.875,
                            color: orange200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 62.7,
                      height: 21,
                      child: Text(
                        '账号注册\n',
                        style: TextStyle(
                          fontSize: fs16,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 11.875,
                          color: orange200,
                        ),
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
