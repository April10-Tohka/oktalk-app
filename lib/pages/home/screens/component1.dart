import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/frame_component2.dart';
import '../widgets/frame_component3.dart';

class Component1 extends StatelessWidget {
  const Component1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 844,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    transform: GradientRotation(3.14 * 0.5),
                    colors: [
                      Color(0xFFBBE739),
                      Color(0xFFE3FF91),
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFFFF),
                    ],
                    stops: [0, 0.12, 0.22, 0.33],
                  ),
                ),
                child: const Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.vertical,
                ),
              ),
              Positioned(
                top: 357,
                left: 40,
                child: SizedBox(
                  width: 71,
                  height: 95,
                  child: Stack(
                    children: [
                      Text(
                        '主题学习',
                        style: TextStyle(
                          fontSize: fs32,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 23.75,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = neutral0,
                        ),
                      ),
                      const Text(
                        '主题学习',
                        style: TextStyle(
                          fontSize: fs32,
                          fontFamily: 'Alimama ShuHeiTi',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 23.75,
                          color: darkgreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 639,
                left: 16,
                child: SizedBox(
                  width: width358,
                  height: height101,
                  child: Flex(
                    spacing: 17.066666666666606,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: width767,
                        height: height101,
                        child: Flex(
                          spacing: 8.599999999999909,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: width767,
                              height: 77.4,
                              padding: const EdgeInsets.only(
                                top: 9,
                                left: 9,
                                right: 5.7000000000000455,
                                bottom: 7.400000000000091,
                              ),
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(width: 3, color: gold200),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(br15),
                                ),
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 62,
                                height: 61,
                                child: Image(
                                  image: AssetImage('assets/-4@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: 70.3,
                              height: height15,
                              padding: const EdgeInsets.only(
                                left: 6.399999999999977,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 63.9,
                                height: height15,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '趣味听英语',
                                    style: TextStyle(
                                      fontSize: fs12,
                                      fontFamily: 'Alimama FangYuanTi VF',
                                      height: 1.25,
                                      color: darkolivegreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width767,
                        height: height101,
                        child: Flex(
                          spacing: 8.599999999999909,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: width767,
                              height: 77.4,
                              padding: const EdgeInsets.only(
                                top: padding8,
                                left: 12.200000000000044,
                                right: 10.5,
                                bottom: 11.400000000000093,
                              ),
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(width: 3, color: gold200),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(br15),
                                ),
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 54,
                                height: 58,
                                child: Image(
                                  image: AssetImage('assets/-5@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: 70.3,
                              height: height15,
                              padding: const EdgeInsets.only(
                                left: 6.400000000000091,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 63.9,
                                height: height15,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '趣味背单词',
                                    style: TextStyle(
                                      fontSize: fs12,
                                      fontFamily: 'Alimama FangYuanTi VF',
                                      height: 1.25,
                                      color: darkolivegreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width767,
                        height: height101,
                        child: Flex(
                          spacing: 8.599999999999909,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: width767,
                              height: 77.4,
                              padding: const EdgeInsets.only(
                                top: padding14,
                                left: 10.5,
                                right: 9.200000000000044,
                                bottom: 12.400000000000093,
                              ),
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(width: 3, color: gold200),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(br15),
                                ),
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 57,
                                height: 51,
                                child: Image(
                                  image: AssetImage('assets/-6@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: 70.3,
                              height: height15,
                              padding: const EdgeInsets.only(
                                left: 6.399999999999977,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 63.9,
                                height: height15,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '趣味学音标',
                                    style: TextStyle(
                                      fontSize: fs12,
                                      fontFamily: 'Alimama FangYuanTi VF',
                                      height: 1.25,
                                      color: darkolivegreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width767,
                        height: height101,
                        child: Flex(
                          spacing: 8.599999999999909,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              width: width767,
                              height: 77.4,
                              padding: const EdgeInsets.only(
                                top: padding11,
                                left: 8.700000000000045,
                                right: 8.700000000000045,
                                bottom: 10.400000000000093,
                              ),
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(width: 3, color: gold200),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(br15),
                                ),
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 57,
                                height: height56,
                                child: Image(
                                  image: AssetImage('assets/-7@2x.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: 70.3,
                              height: height15,
                              padding: const EdgeInsets.only(
                                left: 6.400000000000091,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 63.9,
                                height: height15,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '趣味看视频',
                                    style: TextStyle(
                                      fontSize: fs12,
                                      fontFamily: 'Alimama FangYuanTi VF',
                                      height: 1.25,
                                      color: darkolivegreen,
                                    ),
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
              ),
              const Positioned(
                top: 48,
                left: 219,
                child: SizedBox(
                  width: 36,
                  height: height36,
                  child: Image(
                    image: AssetImage('assets/OK-1@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                top: 50,
                left: 302,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image(
                    image: AssetImage('assets/11@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                top: 126,
                left: 7,
                child: SizedBox(
                  width: 183,
                  height: 183,
                  child: Image(
                    image: AssetImage('assets/3D-1@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                top: 331,
                left: 16,
                child: Stack(
                  children: [
                    SizedBox(
                      width: width358,
                      height: 139,
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        direction: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 0,
                      child: SizedBox(
                        width: width358,
                        height: 127,
                        child: Image(
                          image: AssetImage('assets/-10@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 161,
                      child: SizedBox(
                        width: 187,
                        height: 139,
                        child: Image(
                          image: AssetImage('assets/Background-Rect@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 697,
                left: 0,
                child: SizedBox(
                  width: width390,
                  height: 147,
                  child: Image(
                    image: AssetImage('assets/-11@2x.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: width390,
                  height: 614,
                  child: Flex(
                    spacing: 122.09999999999992,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      SizedBox(
                        width: width390,
                        height: 319.9,
                        child: Flex(
                          spacing: 7,
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
                                    width: 172,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                              width: 376,
                              height: height47,
                              padding: const EdgeInsets.only(
                                left: padding24,
                                bottom: padding5,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: SizedBox(
                                width: 352,
                                height: 42,
                                child: Flex(
                                  spacing: 75,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 136,
                                      height: 42,
                                      child: Flex(
                                        spacing: 11,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        direction: Axis.horizontal,
                                        children: [
                                          const Stack(
                                            children: [
                                              SizedBox(
                                                width: 42,
                                                height: 42,
                                                child: Flex(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: SizedBox(
                                                  width: 42,
                                                  height: 42,
                                                  child: Image(
                                                    image: AssetImage(
                                                      'assets/-12@2x.png',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 3,
                                                left: 5,
                                                child: SizedBox(
                                                  width: width32,
                                                  height: height39,
                                                  child: Image(
                                                    image: AssetImage(
                                                      'assets/-13@2x.png',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: 83,
                                            height: 35,
                                            padding: const EdgeInsets.only(
                                              top: padding2,
                                            ),
                                            alignment:
                                                AlignmentDirectional.topStart,
                                            child: const SizedBox(
                                              width: 83,
                                              height: height33,
                                              child: Flex(
                                                spacing: gap3,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                direction: Axis.vertical,
                                                children: [
                                                  Text(
                                                    'Hello,Ryujin!',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'Alimama ShuHeiTi',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.23,
                                                      color: black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 47,
                                                    height: height14,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'Level.17',
                                                        style: TextStyle(
                                                          fontSize: fs12,
                                                          fontFamily:
                                                              'Alimama FangYuanTi VF',
                                                          height: 1.17,
                                                          color: forestgreen,
                                                        ),
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
                                    Container(
                                      width: 141,
                                      height: 22,
                                      padding: const EdgeInsets.only(
                                        top: padding2,
                                      ),
                                      alignment: AlignmentDirectional.topStart,
                                      child: SizedBox(
                                        width: 141,
                                        height: height20,
                                        child: Flex(
                                          spacing: gap15,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          direction: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: 63,
                                              height: height20,
                                              padding: const EdgeInsets.only(
                                                top: padding3,
                                                left: padding4,
                                                right: padding3,
                                                bottom: padding3,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br20),
                                                ),
                                                color: goldenrod200,
                                              ),
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              child: Container(
                                                width: 56,
                                                height: height14,
                                                padding: const EdgeInsets.only(
                                                  top: padding1,
                                                  left: 22,
                                                  right: padding16,
                                                  bottom: padding3,
                                                ),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(br20),
                                                      ),
                                                  color: neutral0,
                                                ),
                                                alignment: AlignmentDirectional
                                                    .topStart,
                                                child: const SizedBox(
                                                  width: width18,
                                                  height: height10,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '812',
                                                      style: TextStyle(
                                                        fontSize: fs10,
                                                        fontFamily:
                                                            'Alimama ShuHeiTi',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1,
                                                        letterSpacing: -0.92,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 63,
                                              height: height20,
                                              padding: const EdgeInsets.only(
                                                top: padding3,
                                                left: padding4,
                                                right: padding3,
                                                bottom: padding3,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(br20),
                                                ),
                                                color: goldenrod200,
                                              ),
                                              alignment:
                                                  AlignmentDirectional.topStart,
                                              child: Container(
                                                width: 56,
                                                height: height14,
                                                padding: const EdgeInsets.only(
                                                  top: padding1,
                                                  left: padding21,
                                                  right: padding11,
                                                  bottom: padding2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(br20),
                                                      ),
                                                  color: neutral0,
                                                ),
                                                alignment: AlignmentDirectional
                                                    .topStart,
                                                child: const SizedBox(
                                                  width: width24,
                                                  height: 11,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '5/10',
                                                      style: TextStyle(
                                                        fontSize: fs10,
                                                        fontFamily:
                                                            'Alimama ShuHeiTi',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.1,
                                                        letterSpacing: -0.36,
                                                        color: black,
                                                      ),
                                                    ),
                                                  ),
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
                            ),
                            Container(
                              width: 126.2,
                              height: 34,
                              padding: const EdgeInsets.only(
                                left: 63,
                                bottom: padding5,
                              ),
                              alignment: AlignmentDirectional.topStart,
                              child: const SizedBox(
                                width: 63.2,
                                height: 29,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'AI助手龙宝OK',
                                    style: TextStyle(
                                      fontSize: fs10,
                                      fontFamily: 'Alimama FangYuanTi VF',
                                      fontWeight: FontWeight.w500,
                                      height: 2.8,
                                      color: dimgray,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                            const FrameComponent21(),
                          ],
                        ),
                      ),
                      const FrameComponent31(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
