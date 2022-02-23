import 'package:flutter/material.dart';

class SaveAndTest extends StatelessWidget {
  const SaveAndTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetMargin = MediaQuery.of(context).size.topRight(const Offset(-170, 0));
    return Container(
      padding: const EdgeInsets.all(0),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: Colors.white54,
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
              icon: const Icon(Icons.save_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text(
                      "Test",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
