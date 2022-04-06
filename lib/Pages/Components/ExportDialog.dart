import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    Key? key,
    required this.darkMode,
    required this.levelDesigner,
    required this.initialSaveDir,
  }) : super(key: key);
  final LevelDesigner levelDesigner;
  final bool darkMode;
  final String initialSaveDir;
  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.levelDesigner.gameState.levelName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                widget.darkMode ? Colors.grey.shade800 : Colors.grey.shade200,
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
                  style: TextStyle(
                      color: widget.darkMode ? Colors.white : Colors.black),
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Unique Level Name",
                      hintStyle: TextStyle(
                          color: widget.darkMode ? Colors.white : Colors.black),
                      labelStyle: TextStyle(
                          color: widget.darkMode ? Colors.white : Colors.black),
                      fillColor: widget.darkMode ? Colors.white : Colors.black),
                  keyboardType: TextInputType.name,
                ),
                CustomAccentButton(
                  tapUpFunction: () {
                    if (controller.text.isNotEmpty) {
                      widget.levelDesigner.saveLevel(
                        includeTileSet: false,
                        export: true,
                        name: controller.text,
                        path: widget.initialSaveDir,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color: widget.darkMode ? Colors.white : Colors.black),
                  ),
                  backgroundColor: widget.darkMode
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
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
