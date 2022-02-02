import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/SplashScreen.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SplashScreenGame(),
    ),
  ));
}

// GameWidget(
// game: IsometricTileMapExample(),
// backgroundBuilder: (BuildContext context) {
// return Container(
// decoration: const BoxDecoration(
// gradient: LinearGradient(
// colors: [Colors.lightBlueAccent, Colors.blue],
// stops: [0, 1],
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// ),
// ),
// );
// },
// )
