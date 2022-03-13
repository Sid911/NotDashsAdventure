import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

import '../../Bloc/LevelGen/level_gen_ui_cubit.dart';

class PuzzlesList extends StatelessWidget {
  const PuzzlesList({Key? key, required this.repository}) : super(key: key);
  final TilesheetRepository repository;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder(
          future: repository.getPuzzleSprites(),
          builder: (context, AsyncSnapshot<List<Sprite>> snapshot) {
            final cubit = BlocProvider.of<LevelGenUiCubit>(context);
            if (snapshot.hasData) {
              final List<Sprite> data = snapshot.data!;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // scrollDirection: Axis.horizontal,
                // shrinkWrap: true,
                children: [
                  getPuzzleItem(() {
                    cubit.toggleTile(-2);
                  }, data[0]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-3);
                  }, data[1]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-4);
                  }, data[2]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-5);
                  }, data[3]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-6);
                  }, data[4]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-7);
                  }, data[5]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-8);
                  }, data[6]),
                  getPuzzleItem(() {
                    cubit.toggleTile(-9);
                  }, data[7]),
                ],
              );
            } else if (snapshot.hasError) {
              repository.logger.log(
                  Level.INFO, "Ui_Puzzle : not showing the data because of error or snapshot empty", snapshot.error);
              return Container();
            } else {
              return Container();
            }
          }),
    );
  }

  Widget getPuzzleItem(Function onTap, Sprite sprite) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        width: repository.currentTilesheetLog!.puzzlePieceSize[0] / 3,
        height: repository.currentTilesheetLog!.puzzlePieceSize[1] / 3,
        child: SpriteWidget(
          sprite: sprite,
        ),
      ),
    );
  }
}
