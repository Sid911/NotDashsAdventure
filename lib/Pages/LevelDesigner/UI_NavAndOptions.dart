import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';

class NavAndOptions extends StatelessWidget {
  const NavAndOptions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          semanticChildCount: 2,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                )),
            BlocBuilder<LevelGenUiCubit, LevelGenUiState>(builder: (context, state) {
              return getShowUIButton(state.showUI, context);
            }),
            BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
              builder: (context, state) {
                return getDeleteButton(state.showUI, context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget getShowUIButton(bool showUI, BuildContext context) {
    if (showUI) {
      return IconButton(
          onPressed: () {
            final levelGenCubit = BlocProvider.of<LevelGenUiCubit>(context);
            levelGenCubit.hideUI();
          },
          icon: const Icon(
            Icons.view_sidebar,
            size: 20,
          ));
    } else {
      return IconButton(
          onPressed: () {
            final levelGenCubit = BlocProvider.of<LevelGenUiCubit>(context);
            levelGenCubit.loadUI();
          },
          icon: const Icon(
            Icons.view_sidebar_outlined,
            size: 20,
          ));
    }
  }
}

Widget getDeleteButton(bool showUI, BuildContext context) {
  return showUI
      ? IconButton(
          onPressed: () {
            BlocProvider.of<LevelGenUiCubit>(context).toggleTile(-1);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
            color: Colors.black,
          ))
      : Container();
}
