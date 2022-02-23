/*
 * Copyright (c) 2021. Siddharth Sinha
 */

import 'package:flutter/material.dart';

/// outlined button
final ButtonStyle roundedOutlinedBlueButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) return Colors.lightBlueAccent;
      return null; // Use the component's default.
    },
  ),
);

/// Custom Button With custom animated shadow
class CustomAccentButton extends StatefulWidget {
  /// Constructor *I don't want to document it*
  const CustomAccentButton({
    Key? key,
    required this.tapUpFunction,
    required this.child,
    required this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.accentColor = Colors.lightBlueAccent,
    this.disabled = false,
    this.shadow = true,
  }) : super(key: key);

  /// pointer to the [ThemeData]

  /// pointer to a function run after tapping
  final Function tapUpFunction;

  /// Button Shadow accentColor
  final Color accentColor;

  /// Button Body background Color
  final Color backgroundColor;

  /// Padding
  final EdgeInsets padding;

  /// Margin
  final EdgeInsets margin;

  /// child of type [Widget]
  final Widget child;

  /// weather the button is disabled
  final bool disabled;

  /// weather the shadow is disabled
  final bool shadow;

  @override
  _CustomAccentButtonState createState() => _CustomAccentButtonState();
}

class _CustomAccentButtonState extends State<CustomAccentButton> {
  double buttonShadowOffset = 10.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () {
        if (!widget.disabled) {
          setState(() {
            buttonShadowOffset = 10.0;
          });
        }
      },
      onTapDown: (TapDownDetails tapDownDetails) {
        if (!widget.disabled) {
          setState(() {
            buttonShadowOffset = 15.0;
          });
        }
      },
      onTapUp: (TapUpDetails details) {
        if (!widget.disabled) {
          setState(() {
            buttonShadowOffset = 10.0;
          });
        }
        widget.tapUpFunction();
      },
      child: AnimatedContainer(
        margin: widget.margin,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceIn,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            if (widget.shadow)
              BoxShadow(
                color: widget.accentColor,
                blurRadius: 15,
                offset: Offset(0, buttonShadowOffset),
                spreadRadius: -15,
              )
          ],
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
