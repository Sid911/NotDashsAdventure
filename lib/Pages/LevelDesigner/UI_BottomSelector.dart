import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/res.dart';
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

  Widget getCollapsedView({required LevelGenUiState state}) {
    if (state is LevelGenUILoaded) {
      if (state.resourceType == ResourceType.tile) {
        return BlocksList(logger: Logger("BlockList"));
      } else if (state.resourceType == ResourceType.puzzle) {
        return PuzzlesList(repository: repository);
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
        builder: (context, state) {
          return Visibility(
            visible: state.showUI,
            child: SlidingUpPanel(
              onPanelOpened: () {},
              backdropEnabled: false,
              color: state.darkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(10),
              minHeight: 60,
              collapsed: getCollapsedView(state: state),
              panelBuilder: (ScrollController controller) {
                if (state is LevelGenUILoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Material(
                        color: Colors.transparent,
                        child: TileCategories(
                          controller: controller,
                        )),
                  );
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
