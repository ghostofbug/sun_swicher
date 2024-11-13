import 'package:flutter/material.dart';
import 'package:sun_switcher/screens/home.dart';
import 'package:sun_switcher/ultis/share_prefs.dart';
import 'package:sun_switcher/widget/theme_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(ThemeSwitcher(
      child: MyApp(
    initTheme: SharedPrefs.getTheme(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initTheme});

  final ThemeData initTheme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
        initialData: initTheme,
        stream: ThemeSwitcher.of(context)?.streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SharedPrefs.saveTheme(snapshot.data!.brightness);
            return MaterialApp(
              title: 'SunMoon Swicher demo',
              theme: snapshot.data,
              home: const HomeScreen(),
            );
          }
          return const Center(
              child: Text("Error Please kill app and open again"));
        });
  }
}
