import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoader.dart';

class PauseMenu extends StatefulWidget {
  const PauseMenu({Key? key, required this.loader}) : super(key: key);
  final LevelLoader loader;
  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.loader.paused = false;
          widget.loader.overlays.remove("pauseMenu");
        },
        child: Container(
          color: Colors.white70,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Container(
              width: 250,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              color: Colors.blue.shade100,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      widget.loader.paused = false;
                      widget.loader.overlays.remove("pauseMenu");
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.blueGrey.shade800,
                    ),
                    label: Text("Continue", style: TextStyle(color: Colors.blueGrey.shade700, fontFamily: "Pixel")),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.blueGrey.shade800,
                    ),
                    label: Text("Exit Level", style: TextStyle(color: Colors.blueGrey.shade700, fontFamily: "Pixel")),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
