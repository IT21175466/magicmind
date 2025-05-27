// import 'dart:io';
// import 'dart:math';
// import 'package:chat_app/constants/env.dart';
// import 'package:chat_app/constants/styles.dart';
// import 'package:chat_app/models/session_provider.dart';
// import 'package:chat_app/navigations/home_screen.dart';
// import 'package:chat_app/navigations/image_test_screen.dart';
// import 'package:chat_app/navigations/previous_vocabulary_records_screen.dart';
// import 'package:chat_app/navigations/vocabulary_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class VocabularyLevelsScreen extends StatefulWidget {
//   @override
//   _VocabularyLevelsScreenState createState() => _VocabularyLevelsScreenState();
// }

// class _VocabularyLevelsScreenState extends State<VocabularyLevelsScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int _diff = 1;
//   int levelsToShow = 1;
//   final FlutterTts flutterTts = FlutterTts();

//   // Sample data for vocabulary levels from the PDF content
//   final List<Map<String, dynamic>> levels = ENVConfig.levels;

//   void _playInstructions() async {
//     String instruction =
//         "In this vocabulary activity, players will progress through multiple levels, each offering a range of difficulties, including Basic, Normal, Hard, Very Hard, and Challenging. Participants can engage with various question formats, including voice-based responses and signature pad input for written answers. Additionally, image-based activities require players to identify the correct name of an object from a selection of images. As the difficulty increases, words become more complex, testing both recognition and recall skills. Complete each challenge accurately to advance to the next level and improve your vocabulary proficiency!";
//     try {
//       print("Audio Init");
//       await flutterTts.setLanguage("en-US");
//       await flutterTts.setPitch(1.0); // Set pitch
//       await flutterTts.setSpeechRate(0.5); // Set a moderate speech rate
//       await flutterTts
//           .awaitSpeakCompletion(true); // Ensure it waits for completion
//       await flutterTts.speak(instruction); // Speak the provided text
//     } catch (e) {
//       print("Error during TTS operation: $e");
//     }
//   }

//   Future<void> _loadDifficulty() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? d = prefs.getInt('vocabulary_difficulty');

//     setState(() {
//       _diff = d ?? 1;
//       levelsToShow = d ?? 1;
//       // if (levelsToShow > levels.length) {
//       //   // If not enough levels for the selected difficulty, show available levels + dummy level
//       //   levelsToShow = levels.length;
//       // }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadDifficulty();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _navigateToVocabularyScreen(Map<String, dynamic> levelData) {
//     // Shuffle questions and limit to 10 if more are available
//     final questions = List<Map<String, dynamic>>.from(levelData['questions']);
//     questions.shuffle(Random());
//     final limitedQuestions = questions.take(10).toList();

//     // Pass updated levelData with limited/shuffled questions
//     final updatedLevelData = {
//       ...levelData,
//       'questions': limitedQuestions,
//     };

//     if (levelData["type"] == "image") {
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => ImageTestScreen(levelData: updatedLevelData),
//       //   ),
//       // );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => VocabularyScreen(levelData: updatedLevelData),
//         ),
//       );
//     }
//   }

//   Future<File> _loadPDFfromAssets(String assetPath) async {
//     final byteData = await rootBundle.load(assetPath);
//     final tempDir = await getTemporaryDirectory();
//     final tempFile = File("${tempDir.path}/document.pdf");
//     await tempFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
//     return tempFile;
//   }

//   String _getGrade(int difficulty) {
//     switch (difficulty) {
//       case 0:
//         return "Initial";
//       case 1:
//         return "Initial";
//       case 2:
//         return "Bronze";
//       case 3:
//         return "Silver";
//       case 4:
//         return "Gold";
//       case 5:
//         return "Platinum";
//       default:
//         return "Unknown";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                       'assets/backgrounds/1737431584894.png_image.png'), // Replace with your background image
//                   fit:
//                       BoxFit.cover, // Ensure the image covers the entire screen
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 5, left: 10, right: 10),
//                     child: AppBar(
//                       backgroundColor:
//                           Colors.transparent, // Transparent background
//                       elevation: 0, // Remove shadow
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'vocabulary game',
//                             style: TextStyle(
//                               fontSize: 20, // Main title font size
//                               color: Colors.black, // Text color
//                             ),
//                           ),
//                           SizedBox(
//                               height: 4), // Space between title and subtitle
//                           Text(
//                             'Grade ${_getGrade(_diff)}',
//                             style: TextStyle(
//                               fontSize: 14, // Subtitle font size
//                               fontWeight: FontWeight.normal,
//                               color: Colors.black, // Text color
//                             ),
//                           ),
//                         ],
//                       ),
//                       titleSpacing: 0,
//                       leading: Container(
//                         margin: EdgeInsets.only(left: 10),
//                         decoration: BoxDecoration(
//                           color: Color(
//                               0xff80ca84), // Background color for the circle
//                           shape: BoxShape.circle, // Circular shape
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.orangeAccent
//                                   .withOpacity(0.6), // Glow effect
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.arrow_back,
//                               color: Colors.white), // Back icon
//                           onPressed: () {
//                             Navigator.pop(context); // Navigate back
//                           },
//                         ),
//                       ),
//                       actions: [
//                         Container(
//                           margin: EdgeInsets.only(right: 10),
//                           decoration: BoxDecoration(
//                             color: Color(
//                                 0xff80ca84), // Background color for the circle
//                             shape: BoxShape.circle, // Circular shape
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.orangeAccent
//                                     .withOpacity(0.6), // Glow effect
//                                 blurRadius: 10,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                           child: IconButton(
//                             icon: Icon(Icons.logout,
//                                 color: Colors.white), // Logout icon
//                             onPressed: () async {
//                               Provider.of<SessionProvider>(context,
//                                       listen: false)
//                                   .clearSession();
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               await prefs.remove('accessToken');
//                               await prefs.remove('refreshToken');
//                               await prefs.remove('accessTokenExpireDate');
//                               await prefs.remove('refreshTokenExpireDate');
//                               await prefs.remove('userRole');
//                               await prefs.remove('authEmployeeID');
//                               await prefs.remove("vocabulary_difficulty");
//                               await prefs.remove("difference_difficulty");
//                               Navigator.pushReplacementNamed(
//                                   context, '/landing');
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Container(
//                       height: 200,
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Color(0xff27a5c6),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Welcome to Vocabulary",
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8.0),
//                           const Text(
//                             "Choose a level to test and improve your vocabulary skills.",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white70,
//                             ),
//                           ),
//                           const Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .spaceEvenly, // Space out buttons evenly
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: () async {
//                                   File pdfFile = await _loadPDFfromAssets(
//                                       "assets/instructions/vocabulary booklet.pdf");
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PDFView(
//                                         filePath: pdfFile.path,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.voice_chat),
//                                 label: const Text("Instructions"),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             PreviousVocabularyRecordsScreen()),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.history),
//                                 label: const Text("Previous Records"),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // List view of vocabulary levels
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: levels.length,
//                       itemBuilder: (context, index) {
//                         final level = levels[index];
//                         final isLocked = level["difficulty"] > levelsToShow;
//                         return Stack(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (isLocked) {
//                                     // Show a loader message when attempting to access a locked level
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => Dialog(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(12)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(16.0),
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               const CircularProgressIndicator(),
//                                               const SizedBox(height: 16),
//                                               Text(
//                                                 "Level locked! Unlock by increasing difficulty.",
//                                                 style: const TextStyle(
//                                                     fontSize: 16),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                               const SizedBox(height: 16),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: const Text("Close"),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     _navigateToVocabularyScreen(level);
//                                   }
//                                 },
//                                 child: Card(
//                                   color: level["color"],
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(12.0),
//                                     child: Row(
//                                       children: [
//                                         // Image.asset(
//                                         //   level["background"],
//                                         //   width: 60.0,
//                                         //   height: 60.0,
//                                         //   fit: BoxFit.cover,
//                                         // ),
//                                         const SizedBox(width: 16.0),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 level["title"],
//                                                 style: const TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 4.0),
//                                               Text(
//                                                 level["description"],
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   color: Colors.white70,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         if (isLocked)
//                                           const Icon(
//                                             Icons.lock,
//                                             color: Colors.red,
//                                             size: 24.0,
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Lock overlay for locked levels
//                             if (isLocked)
//                               Positioned.fill(
//                                 child: Container(
//                                   color: Colors.black.withOpacity(0.5),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(
//                                         Icons.lock,
//                                         color: Colors.white,
//                                         size: 40,
//                                       ),
//                                       const SizedBox(
//                                           height:
//                                               8), // Space between icon and text
//                                       Text(
//                                         "Level Locked",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                           height:
//                                               4), // Optional space for a second line of text
//                                       Text(
//                                         "Complete Difficulty level ${index + 1} to unlock.",
//                                         style: TextStyle(
//                                           color: Colors.white70,
//                                           fontSize: 14,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ))
//           // Top card with title, description, and play button
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xff80ca84),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//         },
//         child: const Icon(Icons.home),
//       ),
//     );
//   }
// }
