import 'package:flutter/material.dart';

class SaveAndTest extends StatelessWidget {
  const SaveAndTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetMargin = MediaQuery.of(context).size.bottomRight(const Offset(-170, -60));
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: offsetMargin.dx, top: offsetMargin.dy),
      height: 60,
      child: Material(
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
              child: MaterialButton(
                onPressed: () {},
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                color: Colors.white54,
                child: Row(
                  children: const [
                    Text("Test"),
                    Icon(Icons.play_arrow_outlined),
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
