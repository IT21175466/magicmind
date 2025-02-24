import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';
import 'package:magicmind_puzzle/screens/puzzle/level_demo.dart';
import 'package:magicmind_puzzle/screens/puzzle/level_two.dart';
import 'package:magicmind_puzzle/screens/puzzle/select_image_option_screen.dart';
import 'package:magicmind_puzzle/utils/app_styles.dart';
import 'package:magicmind_puzzle/utils/function.dart';

class PuzzleLevelsScreen extends StatefulWidget {
  final bool demo;

  const PuzzleLevelsScreen({super.key, required this.demo});

  @override
  _PuzzleLevelsScreenState createState() => _PuzzleLevelsScreenState();
}

class _PuzzleLevelsScreenState extends State<PuzzleLevelsScreen> {
  int _diff = 0;

  // Sample data for levels
  final List<Map<String, String>> levels = [
    {
      "title": "Demonstration",
      "clue": "Demonstration of the game!",
      "image": "assets/images/puzzle.png",
    },
    {
      "title": "Level 1",
      "clue": "Find the hidden key!",
      "image": "assets/images/puzzle.png",
    },
    {
      "title": "Level 2",
      "clue": "Solve the puzzle to unlock the door.",
      "image": "assets/images/puzzle.png",
    },
  ];

  // void _playInstructions() async {
  //   await _audioPlayer.play(AssetSource("assets/audios/puzzle.mp3"));
  // }

  @override
  void dispose() {
    // _audioPlayer.dispose();
    super.dispose();
  }

  void _navigateToPuzzleScreen(Map<String, String> levelData, int index) {



    if (index == 2){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LevelTwo_SelectImageOption(
            factor: 1,
            difficulty: 1,
          ),
        ),
      );
    }
    else if (index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PuzzleDemo(),
        ),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelectImageOption(
            factor: 1,
            difficulty: 1,
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Levels'),
      ),
      backgroundColor: Styles.secondaryColor,
      body: Column(
        children: [
          // Top card with title, description, and play button
          Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the container
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(
                  16.0), // Inner padding for the container's content
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Puzzle World! Level $_diff",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Choose a level to start solving puzzles and follow the instructions carefully.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play Instructions"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16.0),
          // List view of level cards
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return GestureDetector(
                  onTap: () async {
                    if (widget.demo || index == 0){
                      _navigateToPuzzleScreen(level, index);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: widget.demo || index == 0 ? Styles.secondaryAccent : Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.asset(
                              level["image"]!,
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level["title"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    level["clue"]!,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
