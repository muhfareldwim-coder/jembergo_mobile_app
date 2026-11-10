import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const JemberGoApp());
}

class JemberGoApp extends StatelessWidget {
  const JemberGoApp({super.key});

  static const _brandBlue = Color(0xFF007AFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JemberGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
    );
  }
}
