import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class BlocksList extends StatefulWidget {
  const BlocksList({Key? key}) : super(key: key);

  @override
  State<BlocksList> createState() => _BlocksListState();
}

class _BlocksListState extends State<BlocksList> {
  late SpriteSheet tileset;
  int totalTiles = 84;
  int lastIndex = 0;
  late List<bool> toggles;
  @override
  void initState() {
    super.initState();
    toggles = List.filled(totalTiles, false);
    toggles[0] = true;
    // change this for custom tileset
  }

  Future<List<Widget>> getSprites(String filename) async {
    List<Widget> sprites = List.empty(growable: true);
    final image = await Flame.images.load(filename);
    tileset = SpriteSheet(image: image, srcSize: Vector2(111, 128));
    for (int i = 0; i < totalTiles; i++) {
      final sprite = tileset.getSpriteById(i);
      sprites.add(Container(
          padding: const EdgeInsets.all(2),
          width: 111 / 2.5,
          height: 128 / 2.5,
          child: SpriteWidget(
            sprite: sprite,
          )));
    }
    return sprites;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 150),
      child: Material(
        color: Colors.transparent,
        child: FutureBuilder(
            future: getSprites('tilesheet.png'),
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
                        onPressed: (int buttonIndex) {
                          toggles[lastIndex] = false;
                          setState(() {
                            toggles[buttonIndex] = true;
                            lastIndex = buttonIndex;
                          });
                        },
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
}
