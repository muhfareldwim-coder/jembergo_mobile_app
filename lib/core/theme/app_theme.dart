import 'package:flutter/material.dart';
import 'package:jembergo_mobile_app/core/theme/app_colors.dart';
import 'package:jembergo_mobile_app/core/constants/app_constants.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: AppConstants.fontFamily,
  );
}
