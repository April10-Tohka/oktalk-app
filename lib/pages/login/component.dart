import 'package:flutter/material.dart';

import 'frame_component.dart';
import 'frame_component1.dart';
import 'tokens.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),

        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: white200,
                width: double.infinity,
                height: 844,
                child: const Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.vertical,
                ),
              ),
              //  2. Welcome! 标题文字（橙色大字 + 描边效果）
              Positioned(
                top: 45,
                left: 34,
                child: SizedBox(
                  width: 334,
                  height: 60,
                  child: Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = orange100,
                          ),
                          children: const [
                            TextSpan(
                              style: TextStyle(
                                fontSize: fs48,
                                fontFamily: 'Inter',
                                color: orange100,
                              ),
                              text: 'Welcome!\n',
                            ),
                            TextSpan(
                              style: TextStyle(
                                fontSize: fs24,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w300,
                                color: gray200,
                              ),
                              text: ' ',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontSize: fs48,
                                fontFamily: 'Inter',
                                color: orange100,
                              ),
                              text: 'Welcome!\n',
                            ),
                            TextSpan(
                              style: TextStyle(
                                fontSize: fs24,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w300,
                                color: gray200,
                              ),
                              text: ' ',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 3. 整个顶部装饰区域（背景渐变图形 + 小狮子头像 + 标签页）
              Positioned(
                top: 0,
                left: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(
                      width: width390,
                      height: 810,
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        direction: Axis.horizontal,
                      ),
                    ),
                    const Positioned(
                      top: -151,
                      left: -121,
                      child: SizedBox(
                        width: 281.6,
                        height: 281.6,
                        child: Image(
                          image: AssetImage('assets/images/渐变圆.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 139,
                      left: -214,
                      child: SizedBox(
                        width: 340.7,
                        height: 271.8,
                        child: Image(
                          image: AssetImage('assets/images/芒果泡泡.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: -60,
                      left: 142,
                      child: SizedBox(
                        width: 463.1,
                        height: 372,
                        child: Image(
                          image: AssetImage('assets/images/右上角.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 269,
                      left: 118,
                      child: Container(
                        width: 248,
                        height: 94,
                        decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(width: 5, color: palegoldenrod),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(br20)),
                          color: white200,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 266,
                      left: 29,
                      child: SizedBox(
                        width: 332,
                        height: 544,
                        child: Image(
                          image: AssetImage('assets/images/登录弹窗.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 308,
                      left: 88,
                      child: Container(
                        width: 37,
                        height: 5,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(br20)),
                          color: sandybrown,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 146,
                      left: 194,
                      child: SizedBox(
                        width: 172,
                        height: 140,
                        child: Image(
                          image: AssetImage('assets/images/龙宝插画.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. 欢迎文字（保留在上方）
              Positioned(
                top: 105,
                left: 0,
                child: Container(
                  width: 204,
                  padding: const EdgeInsets.only(left: 34),
                  alignment: AlignmentDirectional.topStart,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topLeft,
                    child: Text(
                      '欢迎来到OKtalk',
                      style: TextStyle(
                        fontSize: fs24,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w300,
                        height: 1.42,
                        color: dimgray200,
                      ),
                    ),
                  ),
                ),
              ),

              // 6. 核心表单与第三方登录（锁定在背景图的 top: 266 起点）
              Positioned(
                top: 266, // 【关键修复】精准对齐底部黄色卡片图片的 top: 266
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FrameComponent(), // 登录表单
                    const SizedBox(height: 130), // 调整表单和第三方登录的间距
                    const FrameComponent1(), // 其他登录方式
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
