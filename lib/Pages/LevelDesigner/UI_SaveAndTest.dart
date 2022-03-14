import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Pages/Components/ExportDialog.dart';
import 'package:not_dashs_adventure/Pages/Components/SaveDialog.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

class SaveAndTest extends StatelessWidget {
  const SaveAndTest({Key? key, required this.levelDesigner}) : super(key: key);
  final LevelDesigner levelDesigner;
  @override
  Widget build(BuildContext context) {
    final offsetMargin = MediaQuery.of(context).size.topRight(const Offset(-140, 10));
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: state.darkMode ? Colors.black54 : Colors.white54,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(left: offsetMargin.dx, top: offsetMargin.dy),
          height: 50,
          child: Material(
            textStyle: const TextStyle(color: Colors.black),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SaveDialog(darkMode: state.darkMode, levelDesigner: levelDesigner);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    color: state.darkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomAccentButton(
                    tapUpFunction: () {
                      showDialog(context: context, builder: (BuildContext context) => const ExportDialog());
                    },
                    backgroundColor: state.darkMode ? Colors.black : Colors.white,
                    shadow: false,
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          color: state.darkMode ? Colors.white : Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
