import 'package:flutter/material.dart';

class BlocksList extends StatelessWidget {
  const BlocksList({Key? key}) : super(key: key);

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
      child: const Material(
        color: Colors.transparent,
        child: Text("The Blocks list", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
