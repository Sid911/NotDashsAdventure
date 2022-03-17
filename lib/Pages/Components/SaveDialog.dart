import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

class SaveDialog extends StatefulWidget {
  const SaveDialog({Key? key, required this.darkMode, required this.levelDesigner}) : super(key: key);
  final LevelDesigner levelDesigner;
  final bool darkMode;
  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.darkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextField(
                  controller: controller,
                  autocorrect: false,
                  style: TextStyle(color: widget.darkMode ? Colors.white : Colors.black),
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Unique Level Name",
                      hintStyle: TextStyle(color: widget.darkMode ? Colors.white : Colors.black),
                      labelStyle: TextStyle(color: widget.darkMode ? Colors.white : Colors.black),
                      fillColor: widget.darkMode ? Colors.white : Colors.black),
                  keyboardType: TextInputType.name,
                ),
                CustomAccentButton(
                  tapUpFunction: () {
                    if (controller.text.isNotEmpty) {
                      widget.levelDesigner.saveLevel(includeTileSet: false, export: false, name: controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(color: widget.darkMode ? Colors.white : Colors.black),
                  ),
                  backgroundColor: widget.darkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                  padding: const EdgeInsets.all(20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
