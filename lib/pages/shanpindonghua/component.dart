import 'package:flutter/material.dart';

class Component extends StatefulWidget {
  const Component({super.key});

  @override
  State<Component> createState() => _ComponentState();
}

class _ComponentState extends State<Component> {
  @override
  void initState() {
    super.initState();
    // 修改跳转时间为正常的 2-3s
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/guide1');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用黑色或背景图主色防止闪烁
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 背景图：铺满全屏
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Logo 区域
          SafeArea(
            child: Align(
              // 原来是 topCenter (即 0.0, -1.0)
              // 向左移：x 从 0.0 改为 -0.2 (数值越小越靠左)
              // 向上移：由于已经是在顶部，可以通过调整 Padding 或使用负 y 值（若外层有空间）
              alignment: const Alignment(-1.0, -1.5),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                ), // 减小 top padding 也会让它更靠上
                child: SizedBox(
                  width: 240,
                  child: Image.asset(
                    'assets/images/splash/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
