import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/utils/app_styles.dart';
import 'package:magicmind_puzzle/widgets/custom_game_card.dart';

import '../../utils/function.dart';
import '../puzzle/puzzle_levels_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Magic Mind',
              style: TextStyle(color: Colors.white), // Make screen name white
            ),
            Text(
              'Kids mental helth provider.', // Add your subtitle text here
              style: TextStyle(color: Colors.white70, fontSize: 12), // Adjust font size and color as needed
            ),
          ],
        ),
        backgroundColor: Styles.secondaryAccent, // Make background transparent
        iconTheme: const IconThemeData(color: Colors.white), // Make icons white
        
      ),
      body: SafeArea(
        child: Container(
          color: Styles.secondaryColor, // Set the background color to gray
          child: ListView(
            padding: const EdgeInsets.all(20),
            children:  [
              // Home Banner
              SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  bool demo = await loadString("demo", "no") != "no";
                  Navigator.push(context, MaterialPageRoute(builder: (contex) => PuzzleLevelsScreen(demo: demo,)));
                },
                child: CustomGameCard(
                  title: "Puzzle Game",
                  icon: Icons.dashboard,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}