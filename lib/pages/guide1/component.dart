import 'package:flutter/material.dart';

import 'tokens.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/guide2'),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // 向左滑
          Navigator.pushReplacementNamed(context, '/guide2');
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
                    spacing: 551,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      SizedBox(
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
                                image: AssetImage('assets/Notch-Frame@2x.png'),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      Container(
                        width: width390,
                        height: 246,
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: 293,
                          height: 94,
                          padding: const EdgeInsets.only(right: 96),
                          alignment: AlignmentDirectional.topEnd,
                          child: SizedBox(
                            width: 197,
                            height: 94,
                            child: RichText(
                              textAlign: TextAlign.center,
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
                                        text: '口语',
                                      ),
                                      TextSpan(
                                        style: TextStyle(color: orange300),
                                        text: '云探索\n',
                                      ),
                                    ],
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: fs20,
                                      fontFamily: 'PingFang SC',
                                      fontWeight: FontWeight.w100,
                                      color: black,
                                    ),
                                    text: '跟龙宝OK一起用口语打卡世界!',
                                  ),
                                ],
                              ),
                            ),
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
                        top: -213,
                        left: -123,
                        child: SizedBox(
                          width: 1166,
                          height: 1227.8,
                          child: Image(
                            image: AssetImage('assets/@2x.png'),
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
                      Positioned(
                        top: 264,
                        left: 56,
                        child: SizedBox(
                          width: 278,
                          height: 199,
                          child: Image(
                            image: AssetImage('assets/Rectangle@2x.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 354,
                        left: 113,
                        child: SizedBox(
                          width: 164,
                          height: 202,
                          child: Image(
                            image: AssetImage('assets/Rectangle-1@2x.png'),
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
