import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

class LevelAndVisibility extends StatelessWidget {
  const LevelAndVisibility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CustomNumberPicker(onValue: (value) {}, initialValue: 0, maxValue: 10, minValue: 0, step: 1),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.disabled_visible_outlined,
                color: Colors.white54,
              )),
        ],
      ),
    );
  }
}
