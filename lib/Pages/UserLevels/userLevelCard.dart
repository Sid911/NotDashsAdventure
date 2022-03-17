import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesignerWrapper.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoaderWrapper.dart';

import '../../Levels/JsonLevelModel.dart';
import '../../Utility/Repositories/LevelsRepository.dart';

class UserLevelCard extends StatelessWidget {
  const UserLevelCard({Key? key, required this.model, required this.repository}) : super(key: key);
  final LevelModel model;
  final LevelsRepository repository;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.lightBlueAccent,
              blurRadius: 15,
              offset: Offset(0, 15),
              spreadRadius: -15,
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => getLevelLoader(model)));
                    },
                    icon: const Icon(Icons.play_arrow_outlined)),
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => getDesigner(model)));
                    },
                    icon: const Icon(Icons.edit_outlined)),
                SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.blueGrey.shade700,
                    thickness: 2,
                    width: 5,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      repository.userBox.delete(model.LevelName);
                    },
                    icon: const Icon(Icons.delete_outlined)),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Tooltip(
                preferBelow: true,
                message: jsonEncode(model.toJson()),
                child: Text(
                  model.LevelName,
                  style: TextStyle(color: Colors.grey.shade900, fontFamily: "Pixel", fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
