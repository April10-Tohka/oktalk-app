import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class FrameComponent21 extends StatelessWidget {
  const FrameComponent21({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380.2,
      height: height1709,
      padding: const EdgeInsets.only(left: padding16),
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: 364.2,
        height: height1709,
        child: Flex(
          spacing: gap15,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Container(
              width: 180,
              height: 41.9,
              padding: const EdgeInsets.only(bottom: 2.900000000000091),
              alignment: AlignmentDirectional.bottomStart,
              child: ElevatedButton.icon(
                icon: Image(
                  image: AssetImage("assets/Bold-Volume-Small@2x.png"),
                ),
                iconAlignment: IconAlignment.start,
                label: Text(
                  "需要帮助请点我开启对话哦",
                  style: TextStyle(
                    fontSize: fs10,
                    fontFamily: 'Alimama FangYuanTi VF',
                    fontWeight: FontWeight.w500,
                    height: 2.8,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: white100,
                  foregroundColor: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(br10)),
                  ),
                  side: BorderSide(width: 3, color: gold100),
                  padding: EdgeInsets.only(
                    top: padding2,
                    left: padding10,
                    right: padding10,
                    bottom: padding3,
                  ),
                  fixedSize: Size(180, height39),
                  minimumSize: Size(180, 39),
                  elevation: 0,
                ),
                onPressed: () {},
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 169.2,
                  height: height1709,
                  padding: const EdgeInsets.only(bottom: 2.900000000000091),
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        width: 163,
                        height: 168,
                        padding: const EdgeInsets.only(
                          top: padding5,
                          left: padding4,
                          right: padding4,
                          bottom: padding3,
                        ),
                        decoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(width: 4, color: goldenrod100),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(br10)),
                          gradient: gradient1,
                        ),
                        alignment: AlignmentDirectional.topStart,
                        child: Stack(
                          children: [
                            Container(
                              width: 155,
                              height: 160,
                              padding: const EdgeInsets.only(
                                top: padding8,
                                left: padding10,
                                right: padding6,
                                bottom: 113,
                              ),
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                direction: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    width: 139,
                                    height: height39,
                                    child: Stack(
                                      children: [
                                        Text(
                                          '签到-任务中心',
                                          style: TextStyle(
                                            fontSize: fs28,
                                            fontFamily: 'Alimama ShuHeiTi',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 16.132,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 3
                                              ..color = orange100,
                                          ),
                                        ),
                                        const Text(
                                          '签到-任务中心',
                                          style: TextStyle(
                                            fontSize: fs28,
                                            fontFamily: 'Alimama ShuHeiTi',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 16.132,
                                            color: neutral0,
                                          ),
                                        ),
                                      ],
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
                                image: AssetImage('assets/-14@2x.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: 113.2,
                    height: 109.9,
                    child: Image(
                      image: AssetImage('assets/3D@2x.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
