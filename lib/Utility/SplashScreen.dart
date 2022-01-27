import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/MainMenu.dart';

class SplashScreenGame extends StatefulWidget {
  const SplashScreenGame({Key? key}) : super(key: key);

  @override
  _SplashScreenGameState createState() => _SplashScreenGameState();
}

class _SplashScreenGameState extends State<SplashScreenGame> {
  late FlameSplashController controller;
  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(fadeInDuration: const Duration(seconds: 1), fadeOutDuration: const Duration(milliseconds: 250), waitDuration: const Duration(seconds: 2), autoStart: true);
  }

  @override
  void dispose() {
    controller.dispose(); // dispose it when necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showBefore: (BuildContext context) {
          return const Text("Before the logo");
        },
        showAfter: (BuildContext context) {
          return const Text("After the logo");
        },
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainMenu())),
        controller: controller,
      ),
    );
  }
}
