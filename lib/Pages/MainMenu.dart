import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BottomSelector.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_DesignerSettings.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_LevelAndVisibility.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_NavAndOptions.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_ResourceSelector.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_SaveAndTest.dart';
import 'package:not_dashs_adventure/Pages/UserLevels/UserLevels.dart';

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
                  "saveAndTest": (context, LevelDesigner designer) {
                    return SaveAndTest(levelDesigner: designer);
                  },
                  "levelAndVisibility": (context, LevelDesigner designer) {
                    return LevelAndVisibility(designer: designer);
                  },
                  "bottomSelector": (context, _) {
                    return const BottomSelector();
                  },
                  'settings': (context, LevelDesigner designer) {
                    return DesignerSettings(designer: designer);
                  },
                  'resourceSelector': (BuildContext context, LevelDesigner designer) {
                    return const ResourceSelector();
                  }
                },
                initialActiveOverlays: const [
                  "options",
                  "saveAndTest",
                  "levelAndVisibility",
                  'resourceSelector',
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
                    "Iso worlds",
                    style: TextStyle(color: Colors.black87, fontFamily: "Pixel", fontSize: 30),
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewUserLevels()));
                  },
                  child: const Text("User Levels"),
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
