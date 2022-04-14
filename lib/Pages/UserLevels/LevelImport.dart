import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Utility/Repositories/LevelsRepository.dart';

class LevelImport extends StatefulWidget {
  const LevelImport({Key? key, required this.darkMode}) : super(key: key);
  final bool darkMode;
  @override
  State<LevelImport> createState() => _LevelImportState();
}

class _LevelImportState extends State<LevelImport> {
  @override
  Widget build(BuildContext context) {
    return CustomAccentButton(
      tapUpFunction: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          final File file = File(result.files.single.path!);
          final String readString = await file.readAsString();
          final Map<String, dynamic> data = jsonDecode(readString);
          // verify
          bool verify = true;
          verify &= data.containsKey("LevelName");
          verify &= data.containsKey("StoryLevel");
          verify &= data.containsKey("Layers");
          verify &= data.containsKey("TilesetUID");
          verify &= data.containsKey("PuzzleLayer");
          verify &= data.containsKey("hexGradientStart");
          verify &= data.containsKey("hexGradientEnd");
          if (verify) {
            LevelModel model = LevelModel.fromJson(data);
            LevelsRepository levelsRepository = LevelsRepository();
            levelsRepository.importLevel(model);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("The File doesn't contain All the data"),
              backgroundColor: Colors.redAccent,
            ));
          }
        } else {
          // User canceled the picker
        }
      },
      padding: const EdgeInsets.all(20),
      backgroundColor:
          widget.darkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      child: const Text("Import  💾"),
    );
  }
}
