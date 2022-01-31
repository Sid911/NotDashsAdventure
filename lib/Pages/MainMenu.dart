import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BlocksList.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_NavAndOptions.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

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
          CircularClipRoute(
            builder: (BuildContext context) => GameWidget(
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
                  return BlocProvider(
                    create: (context) => LevelGenUiCubit(),
                    child: const NavAndOptions(),
                  );
                },
                "blocksList": (context, _) {
                  return const BlocksList();
                }
              },
            ),
            expandFrom: context,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
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
                  levelDesignButton,
                ],
              ), // Menu
            ],
          ),
        ),
      ),
    );
  }
}
