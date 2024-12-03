import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/puzzle/jigsaw_home_screen.dart';
import 'package:magicmind_puzzle/screens/puzzle/jisaw_home_camara_image.dart';

import '../../utils/app_styles.dart';

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
  // File? file;

  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.camera);
  //     if (pickedFile != null) {
  //       final imageData = await pickedFile.readAsBytes();

  //       print(imageData);
  //       // setState(() {
  //       //   canvasImage = await _getImage(MemoryImage(imageData));
  //       //   pieceOnPool = _createJigsawPiece();
  //       //   pieceOnPool.shuffle();
  //       // });
  //     }
  //   } on PlatformException catch (e) {
  //     print('Image Pick Exception: $e');
  //   }
  // }

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
              onTap: () {
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
              onTap: () {
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
