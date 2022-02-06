import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/SplashScreen.dart';

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  // ensure flutter initialization
  WidgetsFlutterBinding.ensureInitialized();
  // define application behaviour
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  Flame.device.setLandscape();
  Flame.device.fullScreen();
  // initialize Hive
  await Hive.initFlutter();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SplashScreenGame(),
    ),
  ));
}
