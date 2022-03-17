import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import '../../Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'LevelDesigner.dart';
import 'UI_BottomSelector.dart';
import 'UI_DesignerSettings.dart';
import 'UI_LevelAndVisibility.dart';
import 'UI_NavAndOptions.dart';
import 'UI_ResourceSelector.dart';
import 'UI_SaveAndTest.dart';

Widget getDesigner(LevelModel? levelModel) {
  return BlocProvider(
    create: (context) => LevelGenUiCubit(),
    child: GameWidget(
      game: LevelDesigner(iModel: levelModel),
      loadingBuilder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const LinearProgressIndicator(),
        );
      },
      overlayBuilderMap: {
        'options': (context, _) {
          return const NavAndOptions();
        },
        "saveAndTest": (context, LevelDesigner designer) {
          return SaveAndTest(levelDesigner: designer);
        },
        "levelAndVisibility": (context, LevelDesigner designer) {
          return LevelAndVisibility(designer: designer);
        },
        "bottomSelector": (context, _) {
          return const BottomSelector();
        },
        'settings': (context, LevelDesigner designer) {
          final state = BlocProvider.of<LevelGenUiCubit>(context).state;
          return DesignerSettings(
            designer: designer,
            startColor: state.backgroundBeginColor,
            endColor: state.backgroundEndColor,
          );
        },
        'resourceSelector': (BuildContext context, LevelDesigner designer) {
          return const ResourceSelector();
        }
      },
      initialActiveOverlays: const [
        "options",
        "saveAndTest",
        "levelAndVisibility",
        'resourceSelector',
        "bottomSelector",
        "settings",
      ],
    ),
  );
}
