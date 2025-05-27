// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:chat_app/constants/env.dart';
// import 'package:chat_app/constants/styles.dart';
// import 'package:chat_app/models/session_provider.dart';
// import 'package:chat_app/navigations/home_screen.dart';
// import 'package:chat_app/navigations/vocablury_results_screen.dart';
// import 'package:chat_app/navigations/vocabulary_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'dart:ui' as ui;
// import 'package:http/http.dart' as http;
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// class VocabularyScreen extends StatefulWidget {
//   final Map<String, dynamic> levelData;

//   VocabularyScreen({required this.levelData});

//   @override
//   _VocabularyScreenState createState() => _VocabularyScreenState();
// }

// class _VocabularyScreenState extends State<VocabularyScreen> {
//   int currentQuestionIndex = 0;
//   int correctAnswers = 0;
//   String spokenAnswer = "";
//   String statusMessage = "";
//   late stt.SpeechToText _speechToText;
//   bool _isListening = false;
//   late int randomValue;

//   String option = "none";
//   Timer? _timer;
//   int timeTakenInSeconds = 0;
//   // GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     _speechToText = stt.SpeechToText();

//     if (widget.levelData["difficulty"] >= 1) {
//       randomValue = Random().nextBool() ? 1 : 2;
//     } else {
//       randomValue = 0;
//     }

//     // Start timer
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         timeTakenInSeconds++;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _speechToText.stop();
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _startListening() async {
//     bool available = await _speechToText.initialize(
//       onStatus: (status) => print('Speech Status: $status'),
//       onError: (error) => print('Speech Error: $error'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speechToText.listen(onResult: (result) {
//         setState(() {
//           spokenAnswer = result.recognizedWords;
//           _checkAnswer();
//         });
//       });
//     }
//   }

//   void _stopListening() {
//     setState(() => _isListening = false);
//     _speechToText.stop();
//   }

//   Future<void> _uploadSignature() async {
//     print("Sign");
//     // try {
//     //   // Convert the signature to an image
//     //   final signaturePadState = _signaturePadKey.currentState;
//     //   if (signaturePadState == null) return;

//     //   final ui.Image image = await signaturePadState.toImage(pixelRatio: 3.0);
//     //   final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     //   final Uint8List imageBytes = byteData!.buffer.asUint8List();

//     //   // Send the image to the server
//     //   var request = http.MultipartRequest(
//     //     'POST',
//     //     Uri.parse(ENVConfig.serverUrl+'/api/recognize-word-ocr'),
//     //   );
//     //   request.files.add(
//     //     http.MultipartFile.fromBytes('file', imageBytes, filename: 'signature.png'),
//     //   );
//     //   print("Send");
//     //   var response = await request.send();
//     //   if (response.statusCode == 200) {
//     //     final responseBody = await response.stream.bytesToString();
//     //     final Map<String, dynamic> responseData = jsonDecode(responseBody);
//     //     print(responseData);

//     //     if (responseData.containsKey('recognized_text')) {
//     //       setState(() {
//     //         spokenAnswer = responseData['recognized_text'];
//     //         _checkAnswer();
//     //       });
//     //     } else {
//     //       setState(() {
//     //         statusMessage = "Error: Unable to recognize text from the signature.";
//     //       });
//     //     }
//     //   } else {
//     //     setState(() {
//     //       statusMessage = "Failed to upload signature: ${response.statusCode}";
//     //     });
//     //   }
//     // } catch (e) {
//     //   print('Error uploading signature: $e');
//     // }
//   }

//   void _checkAnswer() {
//     final currentQuestion = List<Map<String, dynamic>>.from(
//         widget.levelData["questions"])[currentQuestionIndex];
//     bool correct = false;
//     if (randomValue == 0) {
//       correct = spokenAnswer.toLowerCase().trim() ==
//           currentQuestion["answer"].toLowerCase().trim();
//     } else {
//       correct = spokenAnswer.trim() == currentQuestion["answer"].trim();
//     }

//     print(correct);

//     if (correct) {
//       setState(() {
//         statusMessage = "Correct!";
//         correctAnswers++;
//       });
//     } else {
//       setState(() {
//         statusMessage = "Incorrect. Try again!";
//       });
//     }
//   }

//   void _showCompletionPopup() {
//     int difficulty = widget.levelData["difficulty"] ?? 1;
//     _timer?.cancel();

//     // Determine the message and image based on the score range
//     String title;
//     String message;
//     String imagePath;

//     if (correctAnswers >= 7) {
//       title = "Congratulations!";
//       message = "Great job! You excelled in this activity.";
//       imagePath = 'assets/icons/win2.gif';
//     } else if (correctAnswers >= 3) {
//       title = "Good Effort!";
//       message = "You did well! Keep practicing to improve even more.";
//       imagePath = 'assets/icons/studymore.gif';
//     } else {
//       title = "Study More";
//       message = "Don't give up! Review the material and try again.";
//       imagePath = 'assets/icons/tryagain.gif';
//     }

//     showDialog(
//       context: context,
//       barrierDismissible:
//           false, // Prevent the dialog from being dismissed by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.zero, // Remove default padding
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15), // Rounded corners
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Display the image at the top
//               Container(
//                 width: double.infinity,
//                 height: 200.0,
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(height: 16.0), // Space between the image and text

//               // Title and message
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 22.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       message,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.white70,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16.0), // Space between text and button

//               // Next button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => VocabularyResultsScreen(
//                             rawScore: correctAnswers,
//                             timeTaken: timeTakenInSeconds,
//                             difficulty: difficulty,
//                             levelData: widget.levelData),
//                       ),
//                     );
//                   },
//                   child: Text('Next'),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final questions =
//         List<Map<String, dynamic>>.from(widget.levelData["questions"]);
//     final currentQuestion = questions[currentQuestionIndex];

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//         },
//         backgroundColor: Color(0xff80ca84), // Set the background color
//         child: const Icon(
//           Icons.home,
//           color: Colors.white, // Optional: Change the icon color
//         ),
//       ),
//       backgroundColor: Colors.grey[200],
//       body: SingleChildScrollView(
//         child: Container(
//             constraints: BoxConstraints(
//               minHeight: MediaQuery.of(context).size.height, // Minimum height
//             ),
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     'assets/backgrounds/a0f2968d033a232f9101305ce73f44a1.jpg'), // Replace with your background image
//                 fit: BoxFit.cover, // Ensure the image covers the entire screen
//               ),
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(top: 5, left: 10, right: 10),
//                   child: AppBar(
//                     backgroundColor:
//                         Colors.transparent, // Transparent background
//                     elevation: 0, // Remove shadow
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Vocabulary Activity',
//                           style: TextStyle(
//                             fontSize: 20, // Main title font size
//                             color: Colors.black, // Text color
//                           ),
//                         ),
//                         SizedBox(height: 4), // Space between title and subtitle
//                         Text(
//                           'Level: ${widget.levelData['type']}',
//                           style: TextStyle(
//                             fontSize: 14, // Subtitle font size
//                             fontWeight: FontWeight.normal,
//                             color: Colors.black, // Text color
//                           ),
//                         ),
//                       ],
//                     ),
//                     titleSpacing: 0,
//                     leading: Container(
//                       margin: EdgeInsets.only(left: 10),
//                       decoration: BoxDecoration(
//                         color: Color(
//                             0xff80ca84), // Background color for the circle
//                         shape: BoxShape.circle, // Circular shape
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.orangeAccent
//                                 .withOpacity(0.6), // Glow effect
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back,
//                             color: Colors.white), // Back icon
//                         onPressed: () {
//                           Navigator.pop(context); // Navigate back
//                         },
//                       ),
//                     ),
//                     actions: [
//                       Container(
//                         margin: EdgeInsets.only(right: 10),
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
//                           icon: Icon(Icons.logout,
//                               color: Colors.white), // Logout icon
//                           onPressed: () async {
//                             Provider.of<SessionProvider>(context, listen: false)
//                                 .clearSession();
//                             SharedPreferences prefs =
//                                 await SharedPreferences.getInstance();
//                             await prefs.remove('accessToken');
//                             await prefs.remove('refreshToken');
//                             await prefs.remove('accessTokenExpireDate');
//                             await prefs.remove('refreshTokenExpireDate');
//                             await prefs.remove('userRole');
//                             await prefs.remove('authEmployeeID');
//                             await prefs.remove("vocabulary_difficulty");
//                             await prefs.remove("difference_difficulty");
//                             Navigator.pushReplacementNamed(context, '/landing');
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   margin: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white, // Set background color to white
//                     borderRadius: BorderRadius.circular(12), // Rounded corners
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2), // Subtle shadow
//                         spreadRadius: 3, // Spread radius of the shadow
//                         blurRadius: 5, // Blur radius of the shadow
//                         offset: Offset(0, 3), // Position of the shadow
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         currentQuestion["question"]!,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       if (widget.levelData['type'] == 'images')
//                         Center(
//                           child: Image.network(
//                             currentQuestion["imagePath"],
//                             height: 100,
//                             fit: BoxFit.contain,
//                           ),
//                         ),

//                       const SizedBox(height: 5.0),
//                       const Text(
//                         "Use These Options:",
//                         style: TextStyle(fontSize: 12),
//                       ),

//                       // Options
//                       Wrap(
//                         spacing: 10.0,
//                         runSpacing: 10.0,
//                         children: (currentQuestion["options"] as List<String>)
//                             .map((option) {
//                           return ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 spokenAnswer = option;
//                                 _checkAnswer();
//                               });
//                             },
//                             child: Text(option),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 15),

//                       // Answering panel
//                       option != "voice" && randomValue != 1
//                           ? InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   option = "voice";
//                                 });
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 color: Colors.white70,
//                                 elevation: 4.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           // Microphone icon with status
//                                           Icon(
//                                             Icons.mic,
//                                             color: Colors.blue,
//                                             size: 30.0,
//                                           ),
//                                           // Spoken answer display
//                                           Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 16.0),
//                                               child: Text(
//                                                 "Speak your Answer",
//                                                 style: const TextStyle(
//                                                     fontSize: 16,
//                                                     color: Colors.black87),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : SizedBox(),
//                       option == "voice" && randomValue != 1
//                           ? Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               elevation: 4.0,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Microphone icon with status
//                                         GestureDetector(
//                                           onTap: () {
//                                             if (_isListening) {
//                                               _stopListening();
//                                             } else {
//                                               _startListening();
//                                             }
//                                           },
//                                           child: Icon(
//                                             Icons.mic,
//                                             color: _isListening
//                                                 ? Colors.red
//                                                 : Colors.blue,
//                                             size: 30.0,
//                                           ),
//                                         ),
//                                         // Spoken answer display
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 16.0),
//                                             child: Text(
//                                               spokenAnswer.isNotEmpty
//                                                   ? "Spoken: $spokenAnswer"
//                                                   : "Speak your answer",
//                                               style: const TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.white70),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : const SizedBox(),
//                       const SizedBox(height: 10.0),

//                       randomValue == 0
//                           ? Text("OR",
//                               style: TextStyle(
//                                 fontSize: 16,
//                               ))
//                           : const SizedBox(),
//                       const SizedBox(height: 10.0),
//                       option != "write" && randomValue != 2
//                           ? InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   option = "write";
//                                 });
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 color: Colors.white70,
//                                 elevation: 4.0,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           // Microphone icon with status
//                                           Icon(
//                                             Icons.edit,
//                                             color: Colors.blue,
//                                             size: 30.0,
//                                           ),

//                                           // Spoken answer display
//                                           Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 16.0),
//                                               child: Text(
//                                                 "Write your Answer",
//                                                 style: const TextStyle(
//                                                     fontSize: 16,
//                                                     color: Colors.black87),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : SizedBox(),
//                       option == "write" && randomValue != 2
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(
//                                   15.0), // Rounded corners
//                               child: SizedBox(
//                                 height: 200.0, // Set the desired height
//                                 // child: SfSignaturePad(
//                                 //   key: _signaturePadKey,
//                                 //   backgroundColor: Colors.black87,
//                                 // ),
//                               ),
//                             )
//                           : SizedBox(),
//                       const SizedBox(height: 20),
//                       option == "write"
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: _uploadSignature,
//                                   child: Text('Upload Handwriting'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Clear the signature pad
//                                     // _signaturePadKey.currentState?.clear();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors
//                                         .redAccent, // Optional: Customize button color
//                                   ),
//                                   child: Text('Clear Board'),
//                                 ),
//                               ],
//                             )
//                           : SizedBox(),
//                       const SizedBox(height: 20),

//                       // Status container
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           color: Colors.greenAccent,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: Text(
//                           "Your Answer is '$spokenAnswer'",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),

//                       // Next button
//                       ElevatedButton(
//                         onPressed: currentQuestionIndex < questions.length - 1
//                             ? () {
//                                 setState(() {
//                                   currentQuestionIndex++;
//                                   spokenAnswer = "";
//                                   statusMessage = "";
//                                   // _signaturePadKey.currentState?.clear();
//                                 });
//                               }
//                             : _showCompletionPopup,
//                         child: Text(currentQuestionIndex < questions.length - 1
//                             ? "Next"
//                             : "Finish"),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             )),
//       ),
//     );
//   }
// }
