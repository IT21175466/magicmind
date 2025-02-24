import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/puzzle/jigsaw_home_screen.dart';
import 'package:magicmind_puzzle/screens/puzzle/jisaw_home_camara_image.dart';

import '../../utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        title: const Text('Select Option'),
      ),
      backgroundColor: Styles.secondaryColor,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Choose a Option to select image.",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Spacer(),

            // To Camara
            GestureDetector(
              onTap: () async{

                int factor = int.parse(await loadString("l1_cam_factor", "1"));
                String level = (await loadString("l1_cam_level", "Low"));
                int difficulty = int.parse(await loadString("l1_cam_difficulty", "1"));

                if (factor == 1){
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
                        title:
                        Text('You have played this game before!', style: TextStyle(color: Colors.black)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Do you want to continue where you left, or start a new game?',
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JisawHomeCamaraImage(
                                    difficulty: difficulty,
                                    factor: factor,
                                  ),
                                ),
                              );
                            },
                            child:Text('Continue'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JisawHomeCamaraImage(
                                    difficulty: 1,
                                    factor: 1,
                                  ),
                                ),
                              );
                            },
                            child:Text('New game'),
                          ),
                        ],
                      );
                    });
                  },
                );



              },
              child: Padding(
                padding:
                    const EdgeInsets.all(16.0), // Padding around the container
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Styles.bgColor,
                  ),
                  padding: const EdgeInsets.all(
                      16.0), // Inner padding for the container's content

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Pick from Camara",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {

                int factor = int.parse(await loadString("l1_gen_factor", "1"));
                String level = (await loadString("l1_gen_level", "Low"));
                int difficulty = int.parse(await loadString("l1_gen_difficulty", "1"));

                if (factor == 1){
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
                        title:
                        Text('You have played this game before!', style: TextStyle(color: Colors.black)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Do you want to continue where you left, or start a new game?',
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
                            child:Text('Continue'),
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
                            child:Text('New game'),
                          ),
                        ],
                      );
                    });
                  },
                );

              },
              child: Padding(
                padding:
                    const EdgeInsets.all(16.0), // Padding around the container
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Styles.bgColor,
                  ),
                  padding: const EdgeInsets.all(
                      16.0), // Inner padding for the container's content

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 50,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Generate using AI",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
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
