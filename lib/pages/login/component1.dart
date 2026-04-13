import 'package:flutter/material.dart';

import 'tokens.dart';

class Component1 extends StatelessWidget {
  const Component1({super.key});

  @override
  Widget build(BuildContext context) {
    // 整个白底卡片的宽度
    double cardWidth = width322;
    // 表单内容的宽度
    double contentWidth = width285;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // 主体表单容器
        Container(
          width: cardWidth,
          // 【关键修改1】删除写死的 height: 131，让内部 Column 自动撑开高度
          padding: const EdgeInsets.only(
            top: 30, // 【关键修改2】增加上边距，解决太贴上面的问题
            left: padding19,
            right: padding18,
            bottom: 40, // 底部留出空间给外挂的登录按钮
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 让 Column 高度包裹内容
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 手机号部分 ---
              const Text(
                '手机号',
                style: TextStyle(
                  fontSize: fs15,
                  fontFamily: 'PingFang SC',
                  color: dimgray100,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8), // 标签与输入框的间距
              // 【修复】真正的手机号输入框
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

              const SizedBox(height: 20), // 手机号与验证码区域的间距
              // --- 验证码部分 ---
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

              // 验证码输入框 + 发送按钮 (保持刚才完美的响应式 Row)
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
                    // 静态发送验证码按钮 (包了 GestureDetector 准备做第二步)
                    GestureDetector(
                      onTap: () {
                        // TODO: 第二步的倒计时逻辑
                      },
                      child: Container(
                        width: 100,
                        height: height50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: miscellaneousButtonDisabeldBG,
                          borderRadius: BorderRadius.circular(br15),
                        ),
                        child: const Text(
                          '发送验证码',
                          style: TextStyle(
                            fontSize: fs14,
                            fontFamily: 'PingFang SC',
                            color: dimgray100,
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

        // --- 登录按钮 ---
        // 使用 Positioned 挂在整个卡片的底部下方
        Positioned(
          bottom: -28, // 调整数值以让按钮悬浮在一半的位置
          child: Container(
            width: contentWidth,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              boxShadow: shadowDrop, // 确保 tokens.dart 里有这个定义
              borderRadius: BorderRadius.all(Radius.circular(br15)),
              gradient: gradient1, // 确保 tokens.dart 里有这个定义
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
