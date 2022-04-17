import 'package:flutter/material.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesignerWrapper.dart';
import 'package:not_dashs_adventure/Pages/UserLevels/UserLevels.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final levelDesignButton = Builder(builder: (BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => getDesigner(null),
          ),
        );
      },
      color: Colors.black54,
      elevation: 10,
      child: const Text(
        "Level Designer",
        style: TextStyle(color: Colors.white),
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/MainMenu.png"),
                fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Iso worlds",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "Pixel",
                        fontSize: 30),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.settings)),
                ],
              ),
            ),
            // Logo , settings button etc.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: const Text("Play Campaign"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ViewUserLevels()));
                  },
                  child: const Text("User Levels"),
                ),
                levelDesignButton,
              ],
            ), // Menu
          ],
        ),
      ),
    );
  }
}
