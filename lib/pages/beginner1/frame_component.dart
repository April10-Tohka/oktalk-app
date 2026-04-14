import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'tokens.dart';

class FrameComponent extends StatefulWidget {
  const FrameComponent({super.key});

  @override
  State<FrameComponent> createState() => _FrameComponentState();
}

class _FrameComponentState extends State<FrameComponent> {
  String? selectedGender; // 记录 'boy' 或 'girl'
  String? selectedAvatarUrl; // 记录对应的 url1 或 url2
  final TextEditingController _nameController = TextEditingController();

  static const String _apiBaseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  // 定义头像对应的 URL 常量（请根据实际后端需求替换）
  static const String urlGirl =
      "https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/girl.png";
  static const String urlBoy =
      "https://oktalk.oss-cn-heyuan.aliyuncs.com/assets/images/boy.png";

  Future<void> _submitProfile() async {
    final String username = _nameController.text.trim();

    if (selectedGender == null || username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择性别并输入昵称')));
      return;
    }

    try {
      // 发送请求，包含 avatar_url
      final uri = Uri.parse('$_apiBaseUrl/api/v1/user/profile');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'gender': selectedGender,
          'username': username,
          'avatar_url': selectedAvatarUrl, // 将选中的 URL 作为参数发送
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('更新失败');
      }
    } catch (e) {
      // 调试用：如果接口未通，直接跳转
      debugPrint("请求出错: $e");
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 人物图片选择区域
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGenderImage(
                'girl',
                urlGirl,
                'assets/images/beginner1/Rectangle-608@2x.png',
              ),
              const SizedBox(width: 20),
              _buildGenderImage(
                'boy',
                urlBoy,
                'assets/images/beginner1/Rectangle-609@2x.png',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. 性别文字标签
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGenderTag('我是女孩', 'girl', urlGirl),
              _buildGenderTag('我是男孩', 'boy', urlBoy),
            ],
          ),

          const SizedBox(height: 30),

          // ... 引导文字和输入框部分保持不变 ...
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Text(
                '请问该如何称呼你：',
                style: TextStyle(
                  fontSize: fs18,
                  fontFamily: 'Alimama ShuHeiTi',
                  fontWeight: FontWeight.w700,
                  color: darkorange200,
                ),
              ),
              Positioned(
                bottom: -2,
                right: 15,
                child: Image.asset(
                  'assets/images/beginner1/Vector-1452@2x.png',
                  width: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "为自己取个有趣的昵称吧~",
              hintStyle: const TextStyle(color: gainsboro200, fontSize: fs16),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: gold300),
                borderRadius: BorderRadius.circular(br20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: gold300),
                borderRadius: BorderRadius.circular(br20),
              ),
            ),
          ),
          const SizedBox(height: 60),

          // 3. 开启学习之旅按钮
          Center(
            child: GestureDetector(
              onTap: _submitProfile,
              child: Container(
                width: 285,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFCC00),
                      Color(0xFFFFCF29),
                      Color(0xFFFBDBA0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '开启学习之旅 ->',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 修改后的构建方法：增加 avatarUrl 参数
  Widget _buildGenderImage(String gender, String avatarUrl, String assetPath) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() {
        selectedGender = gender;
        selectedAvatarUrl = avatarUrl; // 记录对应的 URL
      }),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? darkorange200 : Colors.transparent,
            width: 4,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            assetPath,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderTag(String text, String gender, String avatarUrl) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() {
        selectedGender = gender;
        selectedAvatarUrl = avatarUrl;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? darkorange200 : gold300,
          borderRadius: BorderRadius.circular(br20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: fs16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
