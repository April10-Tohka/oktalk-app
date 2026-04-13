import 'package:flutter/material.dart';

import 'pages/ai_home_page.dart';
import 'pages/login/component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
      ),
      initialRoute: "/login",
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const Component(), // 登录页
        '/ai_home': (BuildContext context) => const AiHomePage(), // 你的 AI 专区首页
        // 以后继续在这里添加其他页面，例如：
        // '/profile': (context) => const ProfilePage(),
        // '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
