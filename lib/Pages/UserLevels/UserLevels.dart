import 'package:flutter/material.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  "User Levels",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.lightGreenAccent,
                    height: 100,
                    width: 200,
                  );
                },
                itemCount: levelsRepository.getAllUserLevels.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
