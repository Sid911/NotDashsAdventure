import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';

class LevelAndVisibility extends StatelessWidget {
  const LevelAndVisibility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final position = MediaQuery.of(context).size.topLeft(const Offset(0, 70));
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        return state.showUI && state is LevelGenUILoaded
            ? Container(
                margin: EdgeInsets.only(left: position.dx, top: position.dy),
                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(10)),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomNumberPicker(
                        onValue: (dynamic value) {
                          BlocProvider.of<LevelGenUiCubit>(context).setLayerIndex(value);
                        },
                        enable: true,
                        initialValue: state.currentLayer,
                        maxValue: 10,
                        minValue: 0,
                        step: 1,
                        shape: const Border(),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.visibility,
                          size: 20,
                          color: Colors.black,
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
