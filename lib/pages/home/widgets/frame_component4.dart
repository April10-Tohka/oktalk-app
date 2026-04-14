import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class FrameComponent41 extends StatelessWidget {
  const FrameComponent41({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 366,
      height: 189,
      padding: const EdgeInsets.only(left: padding24, bottom: padding19),
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        width: 342,
        height: 170,
        child: Flex(
          spacing: gap3,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.vertical,
          children: [
            SizedBox(
              width: 320,
              height: 111,
              child: Flex(
                spacing: 56.299999999999955,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                direction: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 149.7,
                    height: 111,
                    child: Flex(
                      spacing: 46,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      direction: Axis.vertical,
                      children: [
                        Container(
                          width: 135,
                          height: height37,
                          padding: const EdgeInsets.only(left: padding21),
                          alignment: AlignmentDirectional.topStart,
                          child: Container(
                            width: 114,
                            height: height37,
                            padding: const EdgeInsets.only(
                              top: padding8,
                              left: padding24,
                              right: padding24,
                              bottom: padding8,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(br20),
                              ),
                              color: gold300,
                            ),
                            alignment: AlignmentDirectional.topStart,
                            child: const SizedBox(
                              width: 66,
                              height: 21,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '我是女孩',
                                  style: TextStyle(
                                    fontSize: fs16,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.w600,
                                    height: 1.31,
                                    color: neutral0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 149.7,
                          height: height28,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,
                            child: Text(
                              '请问该如何称呼你：',
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
                  Container(
                    width: 114,
                    height: height37,
                    padding: const EdgeInsets.only(
                      top: 9,
                      left: padding24,
                      right: 23,
                      bottom: 7,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(br20)),
                      color: gold300,
                    ),
                    alignment: AlignmentDirectional.topStart,
                    child: const SizedBox(
                      width: 67,
                      height: 21,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Text(
                          '我是男孩',
                          style: TextStyle(
                            fontSize: fs16,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w600,
                            height: 1.31,
                            color: neutral0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              style: TextStyle(
                fontSize: fs18,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                color: gainsboro200,
              ),
              expands: true,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 4, color: gold300),
                  borderRadius: BorderRadius.all(Radius.circular(br15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 4, color: gold300),
                  borderRadius: BorderRadius.all(Radius.circular(br15)),
                ),
                fillColor: neutral0,
                filled: true,
                hintStyle: TextStyle(
                  fontSize: fs18,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w600,
                  color: gainsboro200,
                ),
                hintText: "为自己取个有趣的昵称吧~",
                contentPadding: EdgeInsets.only(
                  top: 0,
                  left: padding21,
                  bottom: 0,
                ),
                constraints: BoxConstraints.expand(
                  width: 342,
                  height: height56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
