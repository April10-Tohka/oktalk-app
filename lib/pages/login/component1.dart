import 'package:flutter/material.dart';

import 'tokens.dart';

class Component1 extends StatelessWidget {
  const Component1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: width322,
          height: 131,
          padding: const EdgeInsets.only(
            top: padding14,
            left: padding19,
            right: padding18,
          ),
          child: Flex(
            spacing: gap19,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Container(
                width: 110,
                height: height22,
                padding: const EdgeInsets.only(left: padding14),
                alignment: AlignmentDirectional.topStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '请输入手机号',
                    style: TextStyle(
                      fontSize: fs16,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w300,
                      height: 1.38,
                      color: dimgray300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width285,
                height: 76,
                child: Flex(
                  spacing: gap5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    const Text(
                      '密码',
                      style: TextStyle(
                        fontSize: fs15,
                        fontFamily: 'PingFang SC',
                        height: 1.4,
                        color: dimgray100,
                      ),
                    ),
                    TextField(
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(br15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(br15)),
                        ),
                        fillColor: miscellaneousButtonDisabeldBG,
                        filled: true,
                        contentPadding: EdgeInsets.only(
                          top: padding0,
                          bottom: padding0,
                        ),
                        constraints: BoxConstraints.expand(
                          width: width285,
                          height: height50,
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
          right: 18,
          child: TextField(
            expands: true,
            maxLines: null,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(br15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(br15)),
              ),
              fillColor: miscellaneousButtonDisabeldBG,
              filled: true,
              contentPadding: EdgeInsets.only(top: padding0, bottom: padding0),
              constraints: BoxConstraints.expand(
                width: width285,
                height: height50,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -115,
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: fs12,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w300,
                height: 1.42,
              ),
              children: [
                TextSpan(
                  style: TextStyle(color: gray100),
                  text: '登录即代表同意',
                ),
                TextSpan(
                  style: TextStyle(color: darkslategray),
                  text: '《用户协议》',
                ),
                TextSpan(
                  style: TextStyle(color: gray100),
                  text: '和',
                ),
                TextSpan(
                  style: TextStyle(color: darkslategray),
                  text: '《隐私协议》',
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 19,
          bottom: -115,
          child: Container(
            width: width16,
            height: height16,
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(width: 2, color: gainsboro),
              ),
              borderRadius: BorderRadius.all(Radius.circular(58.5)),
            ),
          ),
        ),
        Positioned(
          bottom: -77,
          right: 18,
          child: Container(
            width: width285,
            height: 56,
            decoration: const BoxDecoration(
              boxShadow: shadowDrop,
              borderRadius: BorderRadius.all(Radius.circular(br15)),
              gradient: gradient1,
            ),
          ),
        ),
        const Positioned(
          bottom: -64,
          child: Text(
            '登录',
            style: TextStyle(
              fontSize: fs20,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: white200,
            ),
          ),
        ),
        const Positioned(
          left: 33,
          bottom: 14,
          child: Text(
            '请输入密码',
            style: TextStyle(
              fontSize: fs16,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w300,
              height: 1.38,
              color: dimgray300,
            ),
          ),
        ),
        const Positioned(
          top: -26,
          left: 19,
          child: Text(
            '用户名/手机号',
            style: TextStyle(
              fontSize: fs15,
              fontFamily: 'PingFang SC',
              height: 1.4,
              color: dimgray100,
            ),
          ),
        ),
      ],
    );
  }
}
