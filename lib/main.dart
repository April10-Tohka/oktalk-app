import 'package:flutter/material.dart';

import 'pages/ai_home_page.dart' as aiHome;
import 'pages/beginner1/component.dart' as beginner1;
import 'pages/guide1/component.dart' as guide1;
import 'pages/guide2/component.dart' as guide2;
import 'pages/guide3/component.dart' as guide3;
import 'pages/home/component.dart' as home;
import 'pages/login/component.dart' as login;
import 'pages/shanpindonghua/component.dart' as splash;

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
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const splash.Component(), // 闪屏页
        '/guide1': (BuildContext context) => const guide1.Component(), // 引导页1
        '/guide2': (BuildContext context) => const guide2.Component(), // 引导页2
        '/guide3': (BuildContext context) => const guide3.Component(), // 引导页3
        '/login': (BuildContext context) => const login.Component(), // 登录页
        '/beginner1': (BuildContext context) =>
            const beginner1.Component(), // 引导完成后的起始页
        '/home': (BuildContext context) => const home.Component(), // 首页
        '/ai_home': (BuildContext context) =>
            const aiHome.AiHomePage(), // 你的 AI 专区首页
      },
    );
  }
}
