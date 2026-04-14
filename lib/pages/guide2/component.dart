import 'package:flutter/material.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/guide3'),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // 向左滑
          Navigator.pushReplacementNamed(context, '/guide3');
        } else if (details.primaryVelocity! > 0) {
          // 向右滑，回上一页
          Navigator.pushReplacementNamed(context, '/guide1');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white, // 基础底色为白色
        body: Stack(
          children: [
            // 1. 背景层：绿橙弥散图
            Positioned.fill(
              child: Image.asset(
                'assets/images/guide2/绿橙弥散.png',
                fit: BoxFit.cover,
              ),
            ),

            // 2. 内容层：使用 Column 纵向排列图片和文字
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- 插画部分 ---
                    SizedBox(
                      height: 350, // 设定一个插画区域高度
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //
                          Positioned(
                            top: 100,
                            child: Image.asset(
                              'assets/images/guide2/Frame.png',
                              width: 170,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40), // 插画与文字的间距
                    // --- 文字部分 ---
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '英语',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PingFang SC',
                            ),
                          ),
                          TextSpan(
                            text: '趣学习',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFFFFB74D), // 对应你的 orange300
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PingFang SC',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '体验丰富有趣英语学习功能\n在玩中解决“哑巴口语”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 底部滑动小标 ---
                    Image.asset(
                      'assets/images/guide2/滑动小标2.png',
                      width: 42,
                      height: 8,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
