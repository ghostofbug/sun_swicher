import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_switcher/theme/themes.dart';

class SharedPrefs {
  static SharedPreferences? instance;

  static Future<SharedPreferences> init() async =>
      instance ??= await SharedPreferences.getInstance();

  static void saveTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        {
          instance?.setString("Theme", AppTheme.lightStr);
          break;
        }
      case Brightness.dark:
        {
          instance?.setString("Theme", AppTheme.darkStr);
          break;
        }
    }
  }

  static ThemeData getTheme() {
    var read = instance?.getString("Theme");
    if (read == null || read == "") {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      switch (brightness) {
        case Brightness.dark:
          {
            return AppTheme.dark;
          }
        case Brightness.light:
          {
            return AppTheme.light;
          }
      }
    } else if (read == AppTheme.darkStr) {
      return AppTheme.dark;
    } else {
      return AppTheme.light;
    }
  }
}
