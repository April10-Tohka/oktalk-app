import 'tokens.dart';
import 'package:flutter/material.dart';

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
                color: neutral0,
                width: double.infinity,
                height: height844,
                child: Flex(
                  spacing: 116,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Container(
                      width: width390,
                      height: 476,
                      padding: const EdgeInsets.only(bottom: 429),
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
                    ),
                    Container(
                      width: 315,
                      height: 102,
                      padding: const EdgeInsets.only(left: 75),
                      alignment: AlignmentDirectional.topStart,
                      child: SizedBox(
                        width: 240,
                        height: 102,
                        child: Flex(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: 195,
                              height: height44,
                              padding: const EdgeInsets.only(left: 60),
                              alignment: AlignmentDirectional.topStart,
                              child: SizedBox(
                                width: 135,
                                height: height44,
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: fs32,
                                      fontFamily: 'PingFang SC',
                                      height: 1.38,
                                    ),
                                    children: [
                                      TextSpan(
                                        style: TextStyle(color: orange300),
                                        text: 'AI',
                                      ),
                                      TextSpan(
                                        style: TextStyle(color: black),
                                        text: '智陪伴',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 240,
                              height: height56,
                              child: Text(
                                '智能助手龙宝OK见证孩子\n每一次成长\n',
                                style: TextStyle(
                                  fontSize: fs20,
                                  fontFamily: 'PingFang SC',
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 7.469,
                                  color: gray,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
                      top: 710,
                      left: 174,
                      child: SizedBox(
                        width: 42,
                        height: height8,
                        child: Image(
                          image: AssetImage('assets/@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 225,
                      left: 54,
                      child: SizedBox(
                        width: 281.6,
                        height: 281.6,
                        child: Image(
                          image: AssetImage('assets/-1@2x.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -294,
                      left: -332,
                      child: SizedBox(
                        width: 899,
                        height: 1308,
                        child: Image(
                          image: AssetImage('assets/-2@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 356,
                      left: 75,
                      child: SizedBox(
                        width: 243.3,
                        height: 201.8,
                        child: Image(
                          image: AssetImage('assets/Frame@2x.png'),
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
    );
  }
}
