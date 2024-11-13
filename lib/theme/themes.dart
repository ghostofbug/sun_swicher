import 'package:flutter/material.dart';

class AppTheme {
  static const String lightStr = "Light";
  static const String darkStr = "Dark";

  static ThemeData light = ThemeData.light()
      .copyWith(scaffoldBackgroundColor: const Color(0xFFFFFFFF));
  static ThemeData dark = ThemeData.dark()
      .copyWith(scaffoldBackgroundColor: const Color(0xFF2F2F2F));
}
