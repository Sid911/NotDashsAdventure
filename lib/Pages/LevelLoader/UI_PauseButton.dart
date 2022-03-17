import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoader.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key, required this.levelLoader}) : super(key: key);
  final LevelLoader levelLoader;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.blueGrey.shade500, boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Colors.blueGrey,
          blurRadius: 15,
          offset: Offset(0, 15),
          spreadRadius: -15,
        )
      ]),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
            onPressed: () {
              levelLoader.overlays.add("pauseMenu");
              levelLoader.paused = true;
            },
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
            )),
      ),
    );
  }
}
