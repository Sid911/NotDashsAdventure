import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/ResourceType.dart';

class ResourceSelector extends StatelessWidget {
  const ResourceSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = MediaQuery.of(context).size.topLeft(const Offset(0, 70));
    return Container(
      height: 50,
      width: 200,
      margin: EdgeInsets.only(left: offset.dx, top: offset.dy),
      child: BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
        builder: (context, state) {
          return state is LevelGenUILoaded
              ? Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: state.darkMode ? Colors.black54 : Colors.white54,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(5),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        IconButton(
                            onPressed: () {},
                            splashRadius: 20,
                            tooltip: "Tile Pieces",
                            icon: Icon(
                              state.resourceType == ResourceType.tile ? Icons.square_outlined : Icons.square_rounded,
                              size: 20,
                              color: state.darkMode ? Colors.white : Colors.black,
                            )),
                        IconButton(
                            onPressed: () {},
                            splashRadius: 20,
                            tooltip: "Puzzle Pieces",
                            icon: Icon(
                              state.resourceType == ResourceType.puzzle
                                  ? Icons.dashboard_customize_outlined
                                  : Icons.dashboard_customize_rounded,
                              size: 20,
                              color: state.darkMode ? Colors.white : Colors.black,
                            )),
                      ],
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
