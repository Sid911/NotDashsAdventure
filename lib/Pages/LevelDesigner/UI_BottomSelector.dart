import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BlocksList.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_TileCategories.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../Bloc/LevelGen/level_gen_ui_cubit.dart';

class BottomSelector extends StatefulWidget {
  const BottomSelector({Key? key}) : super(key: key);

  @override
  _BottomSelectorState createState() => _BottomSelectorState();
}

class _BottomSelectorState extends State<BottomSelector> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
        builder: (context, state) {
          return Visibility(
            visible: state.showUI,
            child: SlidingUpPanel(
              backdropEnabled: false,
              color: state.darkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              minHeight: 60,
              panel: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    BlocksList(logger: Logger("BlockList")),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TileCategories(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
