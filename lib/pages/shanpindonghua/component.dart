import 'package:flutter/material.dart';

import 'tokens.dart';

class Component extends StatefulWidget {
  const Component({super.key});

  @override
  State<Component> createState() => _ComponentState();
}

class _ComponentState extends State<Component> {
  @override
  void initState() {
    super.initState();
    // 2-3s 后跳转到 guide1
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/guide1');
      }
    });
  }

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
                padding: const EdgeInsets.only(top: 810),
                alignment: AlignmentDirectional.bottomStart,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: width390,
                  height: height844,
                  child: Flex(
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
                                color: white300,
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
                        height: 797,
                        alignment: AlignmentDirectional.topStart,
                        child: OverflowBox(
                          maxHeight: 837,
                          alignment: Alignment.bottomLeft,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: width390,
                                height: 837,
                                padding: const EdgeInsets.only(
                                  top: padding15,
                                  left: 35,
                                  right: 35,
                                  bottom: 506,
                                ),
                                child: const Flex(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: 223.4,
                                      height: 316,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/logo-1@2x.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                bottom: -5,
                                right: -16,
                                child: SizedBox(
                                  width: 421,
                                  height: 842,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/cgi-bin-mmwebwx-bin-webwxgetmsgimg-MsgID-5359121137159821205-skey-crypt-f1e81e92-f9981e0168a504aa066d02602f79a193-mmweb-appid-wx-webfilehelper-1@2x.png',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
