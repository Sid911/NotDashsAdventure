import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_BlocksList.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_PuzzleList.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/UI_TileCategories.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'ResourceType.dart';

class BottomSelector extends StatefulWidget {
  const BottomSelector({Key? key}) : super(key: key);

  @override
  _BottomSelectorState createState() => _BottomSelectorState();
}

class _BottomSelectorState extends State<BottomSelector> {
  TilesheetRepository repository = TilesheetRepository();
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
              panelBuilder: (ScrollController controller) {
                if (state is LevelGenUILoaded) {
                  switch (state.resourceType) {
                    case ResourceType.sprite:
                      // TODO: Handle this case.
                      break;
                    case ResourceType.animatedSprite:
                      // TODO: Handle this case.
                      break;
                    case ResourceType.tile:
                      return SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          children: [
                            BlocksList(logger: Logger("BlockList")),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: TileCategories(),
                            ),
                          ],
                        ),
                      );
                    case ResourceType.puzzle:
                      return PuzzlesList(repository: repository);
                  }
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
