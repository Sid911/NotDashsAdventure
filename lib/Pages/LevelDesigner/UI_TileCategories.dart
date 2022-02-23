import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';

class TileCategories extends StatefulWidget {
  const TileCategories({Key? key}) : super(key: key);

  @override
  _TileCategoriesState createState() => _TileCategoriesState();
}

class _TileCategoriesState extends State<TileCategories> {
  final TilesheetRepository _repository = TilesheetRepository();

  Future<List<Widget>> buildCategories(BuildContext context) async {
    if (_repository.currentTilesheetLog == null) {
      return List<Widget>.empty();
    }
    final Map<String, List<int>> map = _repository.currentTilesheetLog!.tileCategoryMap;
    final SpriteSheet? spriteSheet = await _repository.getTileSheet(tilesheetName: _repository.currentTilesheetKey);
    final List<Widget> widgets = List<Widget>.empty(growable: true);
    print(_repository.currentTilesheetLog!.srcSize);
    for (String key in map.keys) {
      widgets.add(Text(
        key,
        style: const TextStyle(color: Colors.white),
      ));
      final sprites = List<CustomAccentButton>.empty(growable: true);
      for (int index in map[key]!) {
        sprites.add(CustomAccentButton(
          tapUpFunction: () {
            BlocProvider.of<LevelGenUiCubit>(context).toggleTile(index);
          },
          child: Container(
              padding: const EdgeInsets.all(2),
              width: _repository.currentTilesheetLog!.srcSize[0].toDouble() / 3,
              height: _repository.currentTilesheetLog!.srcSize[1].toDouble() / 3,
              child: SpriteWidget(
                sprite: spriteSheet!.getSpriteById(index),
              )),
          backgroundColor: Colors.white24,
          accentColor: Colors.white54,
          shadow: false,
          padding: const EdgeInsets.all(5),
        ));
      }
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(
          children: sprites,
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
        ),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: buildCategories(context),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> data) {
        if (data.hasData) {
          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: data.data!,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          );
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }
}
