import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/frame_component4.dart';

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
                height: 844,
                child: Flex(
                  spacing: 48,
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
                                      image: AssetImage('assets/Wi-fi@2x.png'),
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
                      width: 132,
                      height: 261,
                      padding: const EdgeInsets.only(
                        left: padding24,
                        bottom: 146,
                      ),
                      alignment: AlignmentDirectional.topStart,
                      child: SizedBox(
                        width: 108,
                        height: 115,
                        child: Flex(
                          spacing: 27,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            SizedBox(
                              width: 108,
                              height: height60,
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  Container(
                                    width: 59,
                                    height: height60,
                                    padding: const EdgeInsets.only(
                                      top: padding2,
                                    ),
                                    alignment: AlignmentDirectional.topStart,
                                    child: const SizedBox(
                                      width: 59,
                                      height: 58,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'hi',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontFamily: 'Alimama ShuHeiTi',
                                            fontWeight: FontWeight.w700,
                                            height: 1.21,
                                            letterSpacing: -1.19,
                                            color: darkorange200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 49,
                                    height: height60,
                                    alignment: AlignmentDirectional.topStart,
                                    child: OverflowBox(
                                      maxWidth: 60,
                                      alignment: Alignment.topRight,
                                      child: const SizedBox(
                                        width: 60,
                                        height: height60,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 96,
                              height: height28,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '请问你是：',
                                  style: TextStyle(
                                    fontSize: fs18,
                                    fontFamily: 'Alimama ShuHeiTi',
                                    fontWeight: FontWeight.w700,
                                    height: 1.56,
                                    color: darkorange200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const FrameComponent41(),
                    Container(
                      width: 237,
                      height: 121,
                      padding: const EdgeInsets.only(left: 157, bottom: 41),
                      alignment: AlignmentDirectional.topStart,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(padding24),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x266C3808),
                                  blurRadius: 0,
                                  spreadRadius: 0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(96),
                              ),
                              color: yellowgreen200,
                            ),
                            child: const Flex(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: width32,
                                  height: height32,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/Bold-Arrow-Right@2x.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            top: 8,
                            right: 6.9,
                            child: SizedBox(
                              width: 28.1,
                              height: 19.2,
                              child: Image(
                                image: AssetImage('assets/Ellipse@2x.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 19,
                            left: 6,
                            child: SizedBox(
                              width: 11.2,
                              height: height13,
                              child: Image(
                                image: AssetImage('assets/Vector@2x.png'),
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
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 231,
                        left: 28,
                        right: padding24,
                        bottom: 456,
                      ),
                      width: 390,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: const Flex(
                          spacing: 40,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: width150,
                              height: 157,
                              child: Image(
                                image: AssetImage(
                                  'assets/Rectangle-608@2x.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 148,
                              height: 157,
                              child: Image(
                                image: AssetImage(
                                  'assets/Rectangle-609@2x.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: -166,
                      bottom: -158,
                      child: SizedBox(
                        width: 587,
                        height: 1158,
                        child: Image(
                          image: AssetImage('assets/@2x.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 106,
                      bottom: 334,
                      child: SizedBox(
                        width: 70,
                        height: height32,
                        child: Image(
                          image: AssetImage('assets/Vector-1452@2x.png'),
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
