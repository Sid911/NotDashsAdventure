import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

class LevelAndVisibility extends StatelessWidget {
  const LevelAndVisibility({Key? key, required this.designer}) : super(key: key);
  final LevelDesigner designer;
  @override
  Widget build(BuildContext context) {
    final position = MediaQuery.of(context).size.topLeft(const Offset(0, 130));
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        return state.showUI && state is LevelGenUILoaded
            ? Container(
                margin: EdgeInsets.only(left: position.dx, top: position.dy),
                decoration: BoxDecoration(
                    color: state.darkMode ? Colors.black54 : Colors.white54, borderRadius: BorderRadius.circular(10)),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomNumberPicker(
                        onValue: (dynamic value) {
                          designer.moveGridForLayer(state.currentLayer < value ? true : false);
                          BlocProvider.of<LevelGenUiCubit>(context).setLayerIndex(value);
                        },
                        valueTextStyle: TextStyle(color: state.darkMode ? Colors.white : Colors.black, fontSize: 15),
                        customAddButton: Tooltip(
                          message: "Increase level",
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.add,
                              color: state.darkMode ? Colors.white : Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                        customMinusButton: Tooltip(
                          message: "Decrease Level",
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.remove,
                              color: state.darkMode ? Colors.white : Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                        enable: true,
                        initialValue: state.currentLayer,
                        maxValue: 5,
                        minValue: 0,
                        step: 1,
                        shape: const Border(),
                      ),
                      IconButton(
                        onPressed: () {},
                        tooltip: "See only current Level",
                        icon: Icon(
                          Icons.visibility,
                          size: 20,
                          color: state.darkMode ? Colors.white : Colors.black,
                        ),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
