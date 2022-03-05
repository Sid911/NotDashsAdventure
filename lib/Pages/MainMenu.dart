import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BottomSelector.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_DesignerSettings.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_LevelAndVisibility.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_NavAndOptions.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_SaveAndTest.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final levelDesignButton = Builder(builder: (BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider(
              create: (context) => LevelGenUiCubit(),
              child: GameWidget(
                game: LevelDesigner(),
                loadingBuilder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: const LinearProgressIndicator(),
                  );
                },
                overlayBuilderMap: {
                  'options': (context, _) {
                    return const NavAndOptions();
                  },
                  "saveAndTest": (context, _) {
                    return const SaveAndTest();
                  },
                  "levelAndVisibility": (context, _) {
                    return const LevelAndVisibility();
                  },
                  "bottomSelector": (context, _) {
                    return const BottomSelector();
                  },
                  'settings': (context, LevelDesigner designer) {
                    return DesignerSettings(
                      designer: designer,
                    );
                  },
                },
                initialActiveOverlays: const [
                  "options",
                  "saveAndTest",
                  "levelAndVisibility",
                  "bottomSelector",
                  "settings",
                ],
              ),
            ),
          ),
        );
      },
      color: Colors.blueGrey,
      elevation: 10,
      child: const Text(
        "Level Designer",
        style: TextStyle(color: Colors.white),
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Not dash's Adventure",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
                ],
              ),
            ),
            // Logo , settings button etc.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: const Text("Play Story"),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: const Text("Tile Sheets And Sprites"),
                ),
                levelDesignButton,
              ],
            ), // Menu
          ],
        ),
      ),
    );
  }
}
