import 'dart:async';
import 'dart:convert'; // 用于 JSON 编解码

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 引入 http 库
import 'package:shared_preferences/shared_preferences.dart';

import 'tokens.dart';

class Component1 extends StatefulWidget {
  const Component1({super.key});

  @override
  State<Component1> createState() => _Component1State();
}

class _Component1State extends State<Component1> {
  // === 1. 新增：控制器与状态变量 ===
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  int _seconds = 60;
  bool _isCounting = false;
  bool _isLoginLoading = false; // 控制登录按钮的 loading 状态
  Timer? _timer;

  // TODO: 【注意】配置你的后端 API 基础地址
  // 如果你在用 Android 模拟器测试本地 Go 服务，请使用 'http://10.0.2.2:8080/api/v1'
  // 如果是 iOS 模拟器，使用 'http://127.0.0.1:8080/api/v1'
  // 如果是真机，请使用你电脑的局域网 IP，例如 'http://192.168.1.100:8080/api/v1'
  static const String _baseUrl = String.fromEnvironment(
    'OKTALK_API_BASE_URL',
    defaultValue: 'http://8.155.145.36:8080',
  );

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose(); // 释放控制器
    _codeController.dispose();
    super.dispose();
  }

  // === 2. 新增：校验手机号正则 ===
  bool _isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  // === 3. 联调：发送短信验证码 API ===
  Future<void> _sendSmsCode() async {
    if (_isCounting) return; // 倒计时中不可点击

    String phone = _phoneController.text.trim();
    if (!_isValidPhone(phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入正确的手机号')));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/sms/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      // 解析后端返回（注意处理中文乱码，使用 utf8.decode）
      final resBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        // 请求成功，开始倒计时
        _startCountdown();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('验证码已发送')));
      } else {
        // 请求失败（如 429 频繁，400 格式错），展示后端返回的 message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(resBody['message'] ?? '发送失败')));
      }
    } catch (e) {
      debugPrint('发送验证码网络错误: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('网络连接失败，请检查网络')));
    }
  }

  // 纯倒计时 UI 逻辑（被 _sendSmsCode 成功后调用）
  void _startCountdown() {
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
        _timer?.cancel();
        setState(() {
          _isCounting = false;
          _seconds = 60;
        });
      }
    });
  }

  // === 4. 联调：短信登录 API ===
  Future<void> _login() async {
    if (_isLoginLoading) return;

    String phone = _phoneController.text.trim();
    String code = _codeController.text.trim();

    if (!_isValidPhone(phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入正确的手机号')));
      return;
    }
    if (code.length != 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入4位验证码')));
      return;
    }

    setState(() {
      _isLoginLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/sms/login'),
        headers: {'Content-Type': 'application/json'},
        // 可以根据需要传入 platform 或 device_id
        body: jsonEncode({'phone': phone, 'code': code, 'platform': 'app'}),
      );

      final resBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        // 1. 提取 Token 数据
        final data = resBody['data'];
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        // 2. 持久化存储
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('登录成功！')));

        // 3. 路由跳转 (使用 pushReplacement 避免用户按返回键回到登录页)
        Navigator.pushReplacementNamed(context, '/beginner1');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(resBody['message'] ?? '登录失败')));
      }
    } catch (e) {
      debugPrint('登录网络错误: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('网络连接失败，请检查网络')));
    } finally {
      setState(() {
        _isLoginLoading = false;
      });
    }
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
                child: TextField(
                  controller: _phoneController, // 绑定控制器
                  keyboardType: TextInputType.phone,
                  maxLength: 11, // 限制手机号 11 位
                  decoration: const InputDecoration(
                    counterText: '', // 隐藏自带的字数统计
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
                        child: TextField(
                          controller: _codeController, // 绑定控制器
                          keyboardType: TextInputType.number,
                          maxLength: 6, // 限制验证码 6 位
                          decoration: const InputDecoration(
                            counterText: '',
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

                    // 修改为调用 API 方法 _sendSmsCode
                    GestureDetector(
                      onTap: _isCounting ? null : _sendSmsCode,
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
          // 为登录按钮包裹 GestureDetector
          child: GestureDetector(
            onTap: _login, // 点击触发登录请求
            child: Container(
              width: contentWidth,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: shadowDrop,
                borderRadius: const BorderRadius.all(Radius.circular(br15)),
                // loading 时置灰或者保持渐变均可，这里保持渐变体验更好
                gradient: _isLoginLoading ? null : gradient1,
                color: _isLoginLoading ? dimgray300 : null,
              ),
              // 如果在请求中，显示菊花 Loading，否则显示“登录”文字
              child: _isLoginLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: white200,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
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
        ),
      ],
    );
  }
}
