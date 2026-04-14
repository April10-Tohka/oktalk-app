import 'package:flutter/material.dart';

import 'component.dart';

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
        '/': (BuildContext context) => const Component(),
      },
    );
  }
}
