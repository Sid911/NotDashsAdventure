import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Not dash's Adventure",
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
                    ],
                  )), // Logo , settings button etc.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: const Text("Play Story"),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.blueGrey,
                    elevation: 10,
                    child: const Text(
                      "Level Designer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ), // Menu
            ],
          ),
        ),
      ),
    );
  }
}
