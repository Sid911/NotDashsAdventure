import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';

class SaveAndTest extends StatelessWidget {
  const SaveAndTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetMargin = MediaQuery.of(context).size.topRight(const Offset(-140, 10));
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: state.darkMode ? Colors.black54 : Colors.white54,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(left: offsetMargin.dx, top: offsetMargin.dy),
          height: 50,
          child: Material(
            textStyle: const TextStyle(color: Colors.black),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {},
                  icon: Icon(
                    Icons.save_outlined,
                    color: state.darkMode ? Colors.white : Colors.black,
                    size: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomAccentButton(
                    tapUpFunction: () {},
                    backgroundColor: state.darkMode ? Colors.black : Colors.white,
                    shadow: false,
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "Test",
                            style: TextStyle(color: state.darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                        Icon(
                          Icons.play_arrow_outlined,
                          color: state.darkMode ? Colors.white : Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
