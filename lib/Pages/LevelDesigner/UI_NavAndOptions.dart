import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';

class NavAndOptions extends StatelessWidget {
  const NavAndOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            height: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: state.darkMode ? Colors.black54 : Colors.white54,
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
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      size: 20,
                      color: state.darkMode ? Colors.white : Colors.black,
                    )),
                getShowUIButton(state.showUI, context, state.darkMode),
                if (state.showUI) getSettingsButton(context, state.darkMode),
                if (state.showUI) getDeleteButton(context, state.darkMode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getShowUIButton(bool showUI, BuildContext context, bool darkMode) {
    if (showUI) {
      return IconButton(
          onPressed: () {
            final levelGenCubit = BlocProvider.of<LevelGenUiCubit>(context);
            levelGenCubit.hideUI();
          },
          icon: Icon(
            Icons.view_sidebar,
            size: 20,
            color: darkMode ? Colors.white : Colors.black,
          ));
    } else {
      return IconButton(
          onPressed: () {
            final levelGenCubit = BlocProvider.of<LevelGenUiCubit>(context);
            levelGenCubit.loadUI();
          },
          icon: Icon(
            Icons.view_sidebar_outlined,
            size: 20,
            color: darkMode ? Colors.white : Colors.black,
          ));
    }
  }
}

Widget getDeleteButton(BuildContext context, bool darkMode) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<LevelGenUiCubit>(context).toggleTile(-1);
      },
      icon: Icon(
        Icons.delete,
        size: 20,
        color: darkMode ? Colors.white : Colors.black,
      ));
}

Widget getSettingsButton(BuildContext context, bool darkMode) {
  return IconButton(
      onPressed: () {
        final levelGenCubit = BlocProvider.of<LevelGenUiCubit>(context);
        levelGenCubit.showSettings();
      },
      icon: Icon(
        Icons.settings,
        size: 20,
        color: darkMode ? Colors.white : Colors.black,
      ));
}
