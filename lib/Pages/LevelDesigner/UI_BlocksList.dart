import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';

class BlocksList extends StatelessWidget {
  const BlocksList({Key? key, required Logger logger})
      : _logger = logger,
        super(key: key);
  final Logger _logger;

  Future<List<Widget>> getSprites(SpriteSheet tileset, int totalTiles) async {
    List<Widget> sprites = List.empty(growable: true);
    for (int i = 0; i < totalTiles; i++) {
      final sprite = tileset.getSpriteById(i);
      sprites.add(Container(
          padding: const EdgeInsets.all(2),
          width: 111 / 3,
          height: 128 / 3,
          child: SpriteWidget(
            sprite: sprite,
          )));
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
            state.toggleBlocksList!,
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
    List<bool> toggles,
    LevelGenUiState state,
    BuildContext context,
  ) {
    if (showUI) {
      return Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(left: 150),
        child: Material(
          color: Colors.transparent,
          child: FutureBuilder(
              future: getSprites(state.tileset!, state.totalTiles!),
              builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ToggleButtons(
                          fillColor: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                          renderBorder: false,
                          onPressed: onPressedToggle,
                          children: snapshot.data!,
                          isSelected: toggles,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return const Text("SpriteSheet Did not load");
              }),
        ),
      );
    }
    return Container();
  }
}
