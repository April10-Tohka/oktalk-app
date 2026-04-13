import 'dart:async';

import 'package:flutter/material.dart';

import 'tokens.dart';

// 【升级为 StatefulWidget 以支持倒计时状态更新】
class Component1 extends StatefulWidget {
  const Component1({super.key});

  @override
  State<Component1> createState() => _Component1State();
}

class _Component1State extends State<Component1> {
  int _seconds = 60;
  bool _isCounting = false;
  Timer? _timer;

  // 倒计时逻辑
  void _startCountdown() {
    if (_isCounting) return; // 防止重复点击

    // 输出 Mock 日志
    debugPrint('Mock: 发送验证码请求开始执行...');

    setState(() {
      _isCounting = true;
      _seconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 1) {
        setState(() {
          _seconds--;
        });
      } else {
        // 倒计时结束，恢复初始状态
        _timer?.cancel();
        setState(() {
          _isCounting = false;
          _seconds = 60;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 页面销毁时务必清理定时器，防止内存泄漏
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = width322;
    double contentWidth = width285;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: cardWidth,
          padding: const EdgeInsets.only(
            top: 30,
            left: padding19,
            right: padding18,
            bottom: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '手机号',
                style: TextStyle(
                  fontSize: fs15,
                  fontFamily: 'PingFang SC',
                  color: dimgray100,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: contentWidth,
                height: height50,
                decoration: BoxDecoration(
                  color: miscellaneousButtonDisabeldBG,
                  borderRadius: BorderRadius.circular(br15),
                ),
                child: const TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '请输入手机号',
                    hintStyle: TextStyle(
                      fontSize: fs16,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w300,
                      color: dimgray300,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: padding14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '验证码',
                style: TextStyle(
                  fontSize: fs15,
                  fontFamily: 'PingFang SC',
                  color: dimgray100,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: contentWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: height50,
                        decoration: BoxDecoration(
                          color: miscellaneousButtonDisabeldBG,
                          borderRadius: BorderRadius.circular(br15),
                        ),
                        child: const TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '请输入验证码',
                            hintStyle: TextStyle(
                              fontSize: fs16,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w300,
                              color: dimgray300,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: padding14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // 【关键更新】绑定倒计时逻辑与动态 UI
                    GestureDetector(
                      onTap: _isCounting ? null : _startCountdown, // 倒计时期间禁用点击
                      child: Container(
                        width: 100,
                        height: height50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: miscellaneousButtonDisabeldBG,
                          borderRadius: BorderRadius.circular(br15),
                        ),
                        child: Text(
                          _isCounting ? '${_seconds}s' : '发送验证码',
                          style: TextStyle(
                            fontSize: fs14,
                            fontFamily: 'PingFang SC',
                            // 倒计时期间让文字颜色变浅，增强视觉反馈
                            color: _isCounting ? dimgray300 : dimgray100,
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

        Positioned(
          bottom: -28,
          child: Container(
            width: contentWidth,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              boxShadow: shadowDrop,
              borderRadius: BorderRadius.all(Radius.circular(br15)),
              gradient: gradient1,
            ),
            child: const Text(
              '登录',
              style: TextStyle(
                fontSize: fs20,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: white200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
