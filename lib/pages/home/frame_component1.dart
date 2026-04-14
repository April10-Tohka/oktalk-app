import 'package:flutter/material.dart';

import 'tokens.dart';

class FrameComponent1 extends StatelessWidget {
  const FrameComponent1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 374,
      height: 172,
      padding: const EdgeInsets.only(left: padding16),
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: width358,
        height: 172,
        child: Flex(
          spacing: gap15,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            Container(
              width: 139,
              height: height19,
              padding: const EdgeInsets.only(left: padding24),
              alignment: AlignmentDirectional.topStart,
              child: const SizedBox(
                width: 115,
                height: height19,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Text(
                    '海量口语主题等你来挑战',
                    style: TextStyle(
                      fontSize: fs10,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w600,
                      height: 1.9,
                      color: yellowgreen200,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width358,
              height: height138,
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Stack(
                    children: [
                      const SizedBox(width: 184, height: height138),
                      const Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          width: 184,
                          height: height138,
                          child: Image(
                            image: AssetImage('assets/images/home/-15@2x.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 4,
                        child: Stack(
                          children: [
                            Container(
                              width: 176,
                              height: height138,
                              padding: const EdgeInsets.only(
                                top: padding14,
                                bottom: padding2,
                              ),
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                direction: Axis.vertical,
                                children: [
                                  Container(
                                    width: 61,
                                    height: height49,
                                    padding: const EdgeInsets.only(
                                      left: padding12,
                                    ),
                                    alignment: AlignmentDirectional.topStart,
                                    child: SizedBox(
                                      width: 49,
                                      height: height49,
                                      child: Stack(
                                        children: [
                                          Text(
                                            '记忆卡片',
                                            style: TextStyle(
                                              fontSize: fs22,
                                              fontFamily: 'Alimama ShuHeiTi',
                                              fontWeight: FontWeight.w700,
                                              height: 1.11,
                                              letterSpacing: 16.328,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 2
                                                ..color = neutral0,
                                            ),
                                          ),
                                          const Text(
                                            '记忆卡片',
                                            style: TextStyle(
                                              fontSize: fs22,
                                              fontFamily: 'Alimama ShuHeiTi',
                                              fontWeight: FontWeight.w700,
                                              height: 1.11,
                                              letterSpacing: 16.328,
                                              color: darkorange200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width174,
                                    height: 73,
                                    alignment: AlignmentDirectional.topStart,
                                    child: OverflowBox(
                                      maxHeight: 107,
                                      alignment: Alignment.bottomLeft,
                                      child: const Stack(
                                        children: [
                                          SizedBox(
                                            width: width174,
                                            height: 107,
                                            child: Flex(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              direction: Axis.horizontal,
                                            ),
                                          ),
                                          Positioned(
                                            top: 68,
                                            left: 0,
                                            child: SizedBox(
                                              width: width174,
                                              height: height37,
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/home/-17@2x.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 46,
                                            child: SizedBox(
                                              width: 121,
                                              height: 107,
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/home/3D-1@2x.png',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
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
                              child: Image(
                                image: AssetImage(
                                  'assets/images/home/-16@2x.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: width174,
                    height: height138,
                    alignment: AlignmentDirectional.topStart,
                    child: OverflowBox(
                      maxWidth: 203,
                      alignment: Alignment.topRight,
                      child: const SizedBox(
                        width: 203,
                        height: height138,
                        child: Image(
                          image: AssetImage('assets/images/home/PK@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
