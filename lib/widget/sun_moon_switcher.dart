import 'package:flutter/material.dart';
import 'package:sun_switcher/theme/themes.dart';
import 'package:sun_switcher/widget/theme_switcher.dart';

class SunMoonSwitcher extends StatefulWidget {
  const SunMoonSwitcher(
      {super.key,
      required this.height,
      required this.width,
      required this.initBrightness})
      : assert(width / height == 369 / 145,
            'Width height must have aspect ratio of 369/145');

  final double width;
  final double height;
  final Brightness initBrightness;

  @override
  State<SunMoonSwitcher> createState() => _SunMoonSwitcherState();
}

class _SunMoonSwitcherState extends State<SunMoonSwitcher>
    with TickerProviderStateMixin {
  late double height;
  late double width;

  Duration duration = const Duration(milliseconds: 500);

  late AnimationController sunController =
      AnimationController(vsync: this, duration: duration);

  late AnimationController moonController =
      AnimationController(vsync: this, duration: duration);

  late Animation<Offset> sunAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1, 0.0),
  ).animate(CurvedAnimation(
    parent: sunController,
    curve: const Interval(
      0.0,
      1,
      curve: Curves.ease,
    ),
  ));

  late Animation<Offset> moonAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.5, 0.0),
  ).animate(CurvedAnimation(
    parent: moonController,
    curve: Curves.easeIn,
  ));

  late Animation<Offset> cloudAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 1.0),
  ).animate(CurvedAnimation(
    parent: sunController,
    curve: const Interval(
      0.125,
      1,
      curve: Curves.ease,
    ),
  ));

  late Animation<Offset> starAnimation = Tween<Offset>(
    begin: const Offset(0, -1.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: sunController,
    curve: const Interval(
      0.15,
      1,
      curve: Curves.ease,
    ),
  ));

  late Animation<double> sunOpacity = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).animate(CurvedAnimation(
    parent: sunController,
    curve: const Interval(
      0.15,
      1,
      curve: Curves.ease,
    ),
  ));

  bool isMoon = true;

  void sunListener() {
    if (sunController.value == 1) {
      moonController.reset();
      setState(() {
        isMoon = true;
      });
    }
  }

  void moonListener() {
    if (moonController.value == 1) {
      sunController.reset();
      setState(() {
        isMoon = false;
      });
    } else if (moonController.value > 0.25) {
      if (!sunController.isAnimating) {
        sunController.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;

    switch (widget.initBrightness) {
      case Brightness.light:
        {
          isMoon = false;
          break;
        }
      case Brightness.dark:
        {
          {
            isMoon = true;
            sunController.animateTo(1.0, duration: Duration.zero);
            break;
          }
        }
    }

    sunController.addListener(sunListener);
    moonController.addListener(moonListener);
  }

  Future<void> onTap() async {
    try {
      if (isMoon) {
        await moonController.forward();
        if (mounted) {
          ThemeSwitcher.of(context)!.streamController.add(AppTheme.light);
        }
      } else {
        await sunController.forward();
        if (mounted) {
          ThemeSwitcher.of(context)!.streamController.add(AppTheme.dark);
        }
      }
    } on TickerCanceled {
      debugPrint("Animation cancel");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                isMoon ? "assets/moon_bg.png" : "assets/sun_bg.png",
              ),
              fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
            ),
            BoxShadow(
              color: isMoon ? const Color(0xFF2F2F2F) : const Color(0xFF2384BA),
              spreadRadius: -7,
              blurRadius: 12,
            ),
          ],
          borderRadius: BorderRadius.circular(200),
        ),
        child: Stack(
          children: [
            SlideTransition(
              position: cloudAnimation,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/clouds_backs.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/clouds.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                FadeTransition(
                  opacity: sunOpacity,
                  child: SlideTransition(
                    position: sunAnimation,
                    child: Stack(
                      children: [
                        Stack(
                            children: List.generate(3, (index) {
                          return Container(
                            width: (height * index / 4) + width / 2.25,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(250),
                            ),
                          );
                        })),
                        Positioned(
                            top: 0,
                            bottom: 0,
                            left: 12,
                            child: Image.asset(
                              "assets/sun.png",
                              width: height - 12,
                              height: height - 12,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Opacity(
              opacity: 1 - sunOpacity.value,
              child: SlideTransition(
                position: moonAnimation,
                child: Stack(
                  children: [
                    Stack(
                      children: List.generate(3, (index) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: (height * index / 3) + width / 2.25,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(250))),
                          ),
                        );
                      }).toList(),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: 12,
                        child: Image.asset(
                          "assets/moon.png",
                          width: height - 12,
                          height: height - 12,
                        ))
                  ],
                ),
              ),
            ),

            // }),
            SlideTransition(
              position: starAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                child: Image.asset(
                  "assets/stars.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sunController.removeListener(sunListener);
    sunController.dispose();
    moonController.removeListener(moonListener);
    moonController.dispose();
    super.dispose();
  }
}
