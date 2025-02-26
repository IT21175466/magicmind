import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';
import 'package:magicmind_puzzle/screens/puzzle/level_demo.dart';
import 'package:magicmind_puzzle/screens/puzzle/level_two.dart';
import 'package:magicmind_puzzle/screens/puzzle/select_image_option_screen.dart';

class PuzzleLevelsScreen extends StatefulWidget {
  final bool demo;

  const PuzzleLevelsScreen({super.key, required this.demo});

  @override
  _PuzzleLevelsScreenState createState() => _PuzzleLevelsScreenState();
}

class _PuzzleLevelsScreenState extends State<PuzzleLevelsScreen> {
  final List<Map<String, String>> levels = [
    {
      "title": "Demo",
      "clue": "Demonstration of the game!",
      "image": "assets/images/puzzle_icon.png",
    },
    {
      "title": "Level 1",
      "clue": "Let’s try similar sized pieces",
      "image": "assets/images/puzzle_icon.png",
    },
    {
      "title": "Level 2",
      "clue": "Then try different sized pieces",
      "image": "assets/images/puzzle_icon.png",
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
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LevelTwo_SelectImageOption(
            factor: 1,
            difficulty: 1,
          ),
        ),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PuzzleDemo(),
        ),
      );
    } else {
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

  final List<Color> colors = [
    Color.fromARGB(255, 203, 127, 173),
    Color.fromARGB(255, 142, 190, 132),
    Color.fromARGB(255, 236, 173, 44)
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.9,
            image: AssetImage('assets/images/mainBG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height / 5 * 4,
            ),
            Text(
              "Puzzles",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Andika',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 210,
              width: screenWidth,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Container(
                        width: screenWidth,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hi there!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Andika',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Welcome to puzzle world! Let’s see how it’s going...",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontFamily: 'ABeeZee',
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Play Instructions",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'ABeeZee',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 38, 165, 201),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/images/sun.png'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  return GestureDetector(
                    onTap: () async {
                      if (widget.demo || index == 0) {
                        _navigateToPuzzleScreen(level, index);
                      }
                    },
                    child: Container(
                      height: 120,
                      width: screenWidth,
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    level["title"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Andika',
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    level["clue"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'ABeeZee',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.4,
                                    child: Image.asset(
                                      level["image"]!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 118, 100, 98),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Image.asset('assets/images/home_icon.png'),
      ),
    );
  }
}
