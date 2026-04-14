import 'package:flutter/material.dart';

import 'screens/component.dart';
import 'screens/component1.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),

      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const Component1(),
        '新手引导1_': (BuildContext context) => const Component(),
      },
    );
  }
}
