import 'package:flutter/material.dart';

import 'tokens.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/guide3'),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // 向左滑
          Navigator.pushReplacementNamed(context, '/guide3');
        } else if (details.primaryVelocity! > 0) {
          // 向右滑，回上一页
          Navigator.pushReplacementNamed(context, '/guide1');
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),

          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: neutral0,
                  width: double.infinity,
                  height: height844,
                  child: Flex(
                    spacing: 116,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      Container(
                        width: width390,
                        height: 478,
                        padding: const EdgeInsets.only(bottom: 431),
                        alignment: AlignmentDirectional.topStart,
                        child: SizedBox(
                          width: width390,
                          height: height47,
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            direction: Axis.horizontal,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: double.infinity,
                                  child: Image(
                                    image: AssetImage('assets/Time@2x.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: width172,
                                height: height47,
                                child: Image(
                                  image: AssetImage(
                                    'assets/Notch-Frame@2x.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: white200,
                                  height: double.infinity,
                                  child: const Flex(
                                    spacing: gap8,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: width18,
                                        height: height12,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Reception@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width18,
                                        height: height12,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Wi-fi@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width28,
                                        height: height13,
                                        child: Image(
                                          image: AssetImage(
                                            'assets/Battery@2x.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 313,
                        height: height100,
                        padding: const EdgeInsets.only(right: 73),
                        alignment: AlignmentDirectional.topEnd,
                        child: SizedBox(
                          width: 240,
                          height: height100,
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            direction: Axis.vertical,
                            children: [
                              Container(
                                width: 201,
                                height: 44,
                                padding: const EdgeInsets.only(left: 39),
                                alignment: AlignmentDirectional.topStart,
                                child: SizedBox(
                                  width: 162,
                                  height: 44,
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(),
                                      children: [
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: fs32,
                                            fontFamily: 'PingFang SC',
                                          ),
                                          children: [
                                            TextSpan(
                                              style: TextStyle(color: black),
                                              text: '英语',
                                            ),
                                            TextSpan(
                                              style: TextStyle(
                                                color: orange300,
                                              ),
                                              text: '趣学习\n',
                                            ),
                                          ],
                                        ),
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: fs20,
                                            fontFamily: 'PingFang SC',
                                            fontWeight: FontWeight.w100,
                                            color: gray,
                                          ),
                                          text: ' ',
                                        ),
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: fs32,
                                            fontFamily: 'PingFang SC',
                                            color: orange300,
                                          ),
                                          text: ' ',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                '体验丰富有趣英语学习功能\n在玩中解决“哑巴口语”',
                                style: TextStyle(
                                  fontSize: fs20,
                                  fontFamily: 'PingFang SC',
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 6.362,
                                  color: gray,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        direction: Axis.horizontal,
                      ),
                      Positioned(
                        top: -325,
                        left: -161,
                        child: SizedBox(
                          width: 727,
                          height: 1370,
                          child: Image(
                            image: AssetImage('assets/@2x.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 191,
                        left: 83,
                        child: SizedBox(
                          width: 229,
                          height: 367,
                          child: Image(
                            image: AssetImage('assets/Visual-Element@2x.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 710,
                        left: 174,
                        child: SizedBox(
                          width: 42,
                          height: 8,
                          child: Image(
                            image: AssetImage('assets/-1@2x.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
