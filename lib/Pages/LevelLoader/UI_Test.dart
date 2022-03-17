import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoader.dart';

class TestButton extends StatelessWidget {
  const TestButton({Key? key, required this.levelLoader}) : super(key: key);
  final LevelLoader levelLoader;
  @override
  Widget build(BuildContext context) {
    final offset = MediaQuery.of(context).size.topRight(const Offset(-120, 10));
    return Container(
      margin: EdgeInsets.only(top: offset.dy, left: offset.dx),
      padding: const EdgeInsets.all(5),
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
        child: TextButton.icon(
          onPressed: () {
            levelLoader.computeLinePath();
          },
          icon: const Icon(
            Icons.construction,
            color: Colors.white,
          ),
          label: Text(
            "Test ",
            style: TextStyle(fontFamily: "Pixel", color: Colors.blueGrey.shade50, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
