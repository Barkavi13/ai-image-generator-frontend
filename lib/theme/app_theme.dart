import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background1,

    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),

      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
  );
}
