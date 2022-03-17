import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

class BlocksList extends StatelessWidget {
  const BlocksList({Key? key, required Logger logger})
      : _logger = logger,
        super(key: key);
  final Logger _logger;

  Future<List<Widget>> buildSprites(SpriteSheet tileset, int totalTiles, LevelGenUiCubit cubit) async {
    final TilesheetRepository _repository = TilesheetRepository();
    List<Widget> sprites = List.empty(growable: true);
    if (_repository.currentTilesheetLog != null) {
      for (int i in _repository.currentTilesheetLog!.recommendedTilesList) {
        final sprite = tileset.getSpriteById(i);
        sprites.add(InkWell(
          onTap: () {
            cubit.toggleTile(i);
          },
          child: Container(
              padding: const EdgeInsets.all(2),
              width: _repository.currentTilesheetLog!.srcSize[0] / 3.5,
              height: _repository.currentTilesheetLog!.srcSize[0] / 3.5,
              child: SpriteWidget(
                sprite: sprite,
              )),
        ));
      }
    }
    return sprites;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        // _logger.log(Level.INFO, "Blocks UI : Level UI state $state");
        if (state is LevelGenUILoaded) {
          return buildBlocks(
            state.showUI,
            (int buttonIndex) {
              BlocProvider.of<LevelGenUiCubit>(context).toggleTile(buttonIndex);
            },
            state,
            context,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildBlocks(
    bool showUI,
    Null Function(int buttonIndex) onPressedToggle,
    LevelGenUiState state,
    BuildContext context,
  ) {
    final cubit = BlocProvider.of<LevelGenUiCubit>(context);
    if (showUI) {
      return Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: Colors.black26,
          // border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: FutureBuilder(
              future: buildSprites(state.tileset!, state.totalTiles!, cubit),
              builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: snapshot.data!,
                  );
                } else if (snapshot.hasError) {
                  _logger.log(Level.SEVERE, "UI_BlocksList: Error", snapshot.error);
                  return const SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        color: Colors.red,
                        backgroundColor: Colors.transparent,
                      ));
                } else {
                  return const SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        color: Colors.red,
                        backgroundColor: Colors.transparent,
                      ));
                }
              }),
        ),
      );
    }
    return Container();
  }
}
