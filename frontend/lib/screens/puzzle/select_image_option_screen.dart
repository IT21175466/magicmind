import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/puzzle/jigsaw_home_screen.dart';
import 'package:magicmind_puzzle/screens/puzzle/jisaw_home_camara_image.dart';

import '../../utils/function.dart';

class SelectImageOption extends StatefulWidget {
  final int factor;
  final int difficulty;
  const SelectImageOption({
    super.key,
    required this.factor,
    required this.difficulty,
  });

  @override
  State<SelectImageOption> createState() => _SelectImageOptionState();
}

class _SelectImageOptionState extends State<SelectImageOption> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.9,
            image: AssetImage('assets/images/select_option_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 53,
                      width: 53,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Image.asset('assets/images/back_arrow.png'),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Select a Option",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Andika',
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 53,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Spacer(),
            Container(
              height: 545,
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  const Text(
                    "Let’s Choose a Option to Continue....",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: 'ABeeZee',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      int factor =
                          int.parse(await loadString("l1_cam_factor", "1"));
                      String level = (await loadString("l1_cam_level", "Low"));
                      int difficulty =
                          int.parse(await loadString("l1_cam_difficulty", "1"));

                      if (factor == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JisawHomeCamaraImage(
                              difficulty: 1,
                              factor: 1,
                            ),
                          ),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text('You have played this game before!',
                                  style: TextStyle(color: Colors.black)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Do you want to continue where you left, or start a new game?',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            JisawHomeCamaraImage(
                                          difficulty: difficulty,
                                          factor: factor,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Continue'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            JisawHomeCamaraImage(
                                          difficulty: 1,
                                          factor: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('New game'),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                    child: Container(
                      width: screenWidth,
                      height: 170,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 236, 173, 44),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(6, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Pick\nfrom\nCamera",
                            style: TextStyle(
                              fontSize: 28,
                              color: const Color.fromARGB(255, 236, 173, 44),
                              fontFamily: 'Andika',
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 130,
                            child: Image.asset(
                              'assets/images/pick_from_camara.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      int factor =
                          int.parse(await loadString("l1_gen_factor", "1"));
                      String level = (await loadString("l1_gen_level", "Low"));
                      int difficulty =
                          int.parse(await loadString("l1_gen_difficulty", "1"));

                      if (factor == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JigsawHomePage(
                              difficulty: 1,
                              factor: 1,
                            ),
                          ),
                        );

                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text('You have played this game before!',
                                  style: TextStyle(color: Colors.black)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'Do you want to continue where you left, or start a new game?',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JigsawHomePage(
                                          difficulty: difficulty,
                                          factor: factor,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Continue'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JigsawHomePage(
                                          difficulty: 1,
                                          factor: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('New game'),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                    child: Container(
                      width: screenWidth,
                      height: 170,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 38, 165, 198),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(6, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Generate\nusing\nAI",
                            style: TextStyle(
                              fontSize: 28,
                              color: const Color.fromARGB(255, 38, 165, 198),
                              fontFamily: 'Andika',
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 130,
                            child: Image.asset(
                              'assets/images/generate_from_ai.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
