import 'package:flutter/material.dart';
import 'package:jembergo_mobile_app/core/constants/app_constants.dart';
import 'package:jembergo_mobile_app/core/theme/app_theme.dart';
import 'package:jembergo_mobile_app/features/auth/presentation/welcome_screen.dart';

class JemberGoApp extends StatelessWidget {
  const JemberGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
