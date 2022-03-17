import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/UserLevels/userLevelCard.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:not_dashs_adventure/Utility/Repositories/LevelsRepository.dart';

class ViewUserLevels extends StatefulWidget {
  const ViewUserLevels({Key? key}) : super(key: key);

  @override
  State<ViewUserLevels> createState() => _ViewUserLevelsState();
}

class _ViewUserLevelsState extends State<ViewUserLevels> {
  LevelsRepository levelsRepository = LevelsRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.chevron_left_rounded)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "User Levels",
                      style: TextStyle(fontSize: 20, fontFamily: "Pixel"),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: ValueListenableBuilder<Box<LevelModel>>(
                  valueListenable: levelsRepository.userBox.listenable(),
                  builder: (context, box, _) {
                    return Row(
                      children: levelsRepository.getUserLevelCards(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
