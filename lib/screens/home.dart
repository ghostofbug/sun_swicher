import 'package:flutter/material.dart';
import 'package:sun_switcher/widget/sun_moon_switcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SunMoonSwitcher(
          height: 145 / 2,
          width: 369 / 2,
          initBrightness: Theme.of(context).brightness,
        ),
      ),
    );
  }
}
