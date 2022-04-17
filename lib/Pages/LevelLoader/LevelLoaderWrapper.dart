import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoader.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/UI_LevelCompleted.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/UI_PauseButton.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/UI_PauseMenu.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/UI_Test.dart';

Widget getLevelLoader(LevelModel model) {
  return GameWidget(
    game: LevelLoader(iModel: model),
    loadingBuilder: (BuildContext context) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const LinearProgressIndicator(),
        ),
      );
    },
    overlayBuilderMap: {
      "pauseMenu": (BuildContext context, LevelLoader loader) {
        return PauseMenu(loader: loader);
      },
      "pauseButton": (BuildContext context, LevelLoader loader) {
        return PauseButton(levelLoader: loader);
      },
      "testButton": (BuildContext context, LevelLoader loader) {
        return TestButton(levelLoader: loader);
      },
      "levelComplete": (BuildContext context, LevelLoader loader) {
        return LevelComplete(loader: loader);
      }
    },
    initialActiveOverlays: const ["pauseButton", "testButton"],
  );
}
