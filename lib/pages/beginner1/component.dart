import 'package:flutter/material.dart';

import 'frame_component.dart';
import 'tokens.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 背景图
          Positioned.fill(
            child: Image.asset(
              'assets/images/beginner1/@2x.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. 主体内容
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Hi 头部
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'hi',
                          style: TextStyle(
                            fontSize: 48,
                            fontFamily: 'Alimama ShuHeiTi',
                            fontWeight: FontWeight.w700,
                            color: darkorange200,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/beginner1/emoji.png',
                          width: 45,
                        ),
                      ],
                    ),
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, top: 10, bottom: 20),
                      child: Text(
                        '请问你是：',
                        style: TextStyle(
                          fontSize: 18,
                          color: darkorange200,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 3. 核心交互区域 (包含图片选择、输入框和提交按钮)
                  const FrameComponent(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
