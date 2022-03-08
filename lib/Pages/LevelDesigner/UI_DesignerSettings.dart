import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/Components/CustomButton.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesigner.dart';

class DesignerSettings extends StatefulWidget {
  const DesignerSettings({Key? key, required this.designer}) : super(key: key);
  final LevelDesigner designer;
  @override
  State<DesignerSettings> createState() => _DesignerSettingsState();
}

class _DesignerSettingsState extends State<DesignerSettings> {
  // create some values
  Color pickerStartColor = const Color(0xffffffff);
  Color pickerEndColor = const Color(0xffffffff);
  Color currentStartColor = const Color(0xffffffff);
  Color currentEndColor = const Color(0xffffffff);

// ValueChanged<Color> callback
  void changeStartColor(Color color) {
    setState(() => pickerStartColor = color);
  }

  void changeEndColor(Color color) {
    setState(() => pickerEndColor = color);
  }

// raise the [showDialog] widget

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final offset = MediaQuery.of(context).size.center(Offset(-1 * (size.width - 100) / 2, -1 * (size.height - 40) / 2));
    return BlocBuilder<LevelGenUiCubit, LevelGenUiState>(
      builder: (context, state) {
        // pickerStartColor = currentStartColor = state.backgroundBeginColor;
        // pickerEndColor = currentEndColor = state.backgroundEndColor;
        return state.showSettings
            ? Container(
                width: size.width - 100,
                height: size.height - 40,
                margin: EdgeInsets.only(left: offset.dx, top: offset.dy),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: state.darkMode ? Colors.black87 : Colors.white70,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<LevelGenUiCubit>(context).hideSettings();
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              color: state.darkMode ? Colors.white : Colors.black,
                              size: 20,
                            ),
                            splashRadius: 20,
                          ),
                          SizedBox(
                            width: size.width - 150,
                            child: SwitchListTile.adaptive(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                              title: Text(
                                "UI Dark Mode",
                                style: TextStyle(color: state.darkMode ? Colors.white : Colors.black, fontSize: 13),
                              ),
                              value: state.darkMode,
                              onChanged: (value) {
                                BlocProvider.of<LevelGenUiCubit>(context).setDarkMode(value);
                                widget.designer.reRenderBackground = true;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "Background Settings",
                              style: TextStyle(fontSize: 13, color: state.darkMode ? Colors.white : Colors.black),
                            ),
                          ),
                          CustomAccentButton(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            backgroundColor: state.darkMode ? Colors.black : Colors.white,
                            tapUpFunction: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerStartColor,
                                          onColorChanged: changeStartColor,
                                          enableAlpha: false,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('Got it'),
                                          onPressed: () {
                                            setState(() => currentStartColor = pickerStartColor);
                                            BlocProvider.of<LevelGenUiCubit>(context)
                                                .setBackgroundGradientBeginColor(currentStartColor);
                                            widget.designer.reRenderBackground = true;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.square,
                                  color: currentStartColor,
                                  size: 30,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Beginning Color",
                                      style:
                                          TextStyle(color: state.darkMode ? Colors.white : Colors.black, fontSize: 11)),
                                )
                              ],
                            ),
                          ),
                          CustomAccentButton(
                              tapUpFunction: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            pickerColor: pickerEndColor,
                                            onColorChanged: changeEndColor,
                                            enableAlpha: false,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text('Got it'),
                                            onPressed: () {
                                              setState(() => currentEndColor = pickerEndColor);
                                              BlocProvider.of<LevelGenUiCubit>(context)
                                                  .setBackgroundGradientEndColor(currentEndColor);
                                              widget.designer.reRenderBackground = true;
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: currentEndColor,
                                    size: 30,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text("Ending Color",
                                        style: TextStyle(
                                            color: state.darkMode ? Colors.white : Colors.black, fontSize: 11)),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              backgroundColor: state.darkMode ? Colors.black : Colors.white),
                        ],
                      ),
                      Row(
                        children: [],
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
