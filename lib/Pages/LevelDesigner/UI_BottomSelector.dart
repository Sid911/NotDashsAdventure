import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BlocksList.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_TileCategories.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSelector extends StatefulWidget {
  const BottomSelector({Key? key}) : super(key: key);

  @override
  _BottomSelectorState createState() => _BottomSelectorState();
}

class _BottomSelectorState extends State<BottomSelector> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlidingUpPanel(
        backdropEnabled: false,
        backdropColor: Colors.black26,
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        minHeight: 60,
        panel: Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              BlocksList(logger: Logger("BlockList")),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: TileCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
