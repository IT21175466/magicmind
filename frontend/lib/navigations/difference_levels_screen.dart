import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:merged_app/navigations/difference_find_screen.dart';
import 'package:merged_app/navigations/home_screen.dart';
import 'package:merged_app/navigations/previous_difference_records_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// ignore: depend_on_referenced_packages

class DifferenceRecognitionLevelsScreen extends StatefulWidget {
  @override
  _DifferenceRecognitionLevelsScreenState createState() =>
      _DifferenceRecognitionLevelsScreenState();
}

class _DifferenceRecognitionLevelsScreenState
    extends State<DifferenceRecognitionLevelsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _diff = 1;
  int levelsToShow = 1;

  // Sample data for levels
  final List<Map<String, dynamic>> levels = [
    {
      "title": "School Desk",
      "desc": "Spot the differences on the school desk.",
      "background": "assets/images/desk/wood-desk.jpg",
      "hint": "plain wooden surface filled in image",
      "color": Color(0xFF2ECC71),
      "objects": [
        "assets/images/desk/book1.png",
        "assets/images/desk/pen2.png",
        "assets/images/desk/pen1.png",
        "assets/images/desk/pencil1.png",
        "assets/images/desk/eraser1.png",
        "assets/images/desk/pen4.png",
        "assets/images/desk/stick.png",
        "assets/images/desk/stick2.png",
        "assets/images/desk/papers.png",
      ],
    },
    {
      "title": "Classroom Board",
      "desc": "Find the differences on the classroom board.",
      "background": "assets/images/desk/board.jpg",
      "hint": "Classroom board with messy items around.",
      "color": Color(0xff27a5c6),
      "objects": [
        "assets/images/desk/book1.png",
        "assets/images/desk/pen2.png",
        "assets/images/desk/pen1.png",
        "assets/images/desk/pencil1.png",
        "assets/images/desk/eraser1.png",
        "assets/images/desk/pen4.png",
        "assets/images/desk/stick.png",
        "assets/images/desk/stick2.png",
        "assets/images/desk/papers.png",
      ],
    },
    {
      "title": "Sport Ground",
      "desc": "Spot the differences on the sport ground.",
      "background": "assets/images/desk/desk.jpg",
      "hint": "Sport ground with more complex background complex.",
      "color": Color(0xFFF0932B),
      "objects": [
        "assets/images/sport/bat.png",
        "assets/images/sport/batmintan.png",
        "assets/images/sport/baym.png",
        "assets/images/sport/netball.png",
        "assets/images/sport/rugby.png",
        "assets/images/sport/volly.png",
      ],
    },
    {
      "title": "Kitchen Desk",
      "desc": "Spot the different objects on kitchen desk.",
      "background": "assets/images/desk/desk.jpg",
      "hint": "Cluttered kitchen with more objects.",
      "color": Color(0xFFEB4D4B),
      "objects": [
        "assets/images/desk/book1.png",
        "assets/images/desk/pen2.png",
        "assets/images/desk/pen1.png",
        "assets/images/desk/pencil1.png",
        "assets/images/desk/eraser1.png",
        "assets/images/desk/pen4.png",
        "assets/images/desk/stick.png",
        "assets/images/desk/stick2.png",
        "assets/images/desk/papers.png",
      ],
    },
    {
      "title": "Advanced Kitchen Desk",
      "desc": "Spot the differences on a complex kitchen desk.",
      "background": "assets/images/desk/desk.jpg",
      "hint": "A very complex kitchen scene with many items.",
      "color": Color(0xFF2ECC71),
      "objects": [
        "assets/images/kichen/blender.png",
        "assets/images/kichen/ketal.png",
        "assets/images/kichen/knife.png",
        "assets/images/kichen/machin.png",
        "assets/images/kichen/mug.png",
        "assets/images/kichen/noname.png",
        "assets/images/kichen/overn.png",
        "assets/images/kichen/plate.png",
        "assets/images/kichen/pork.png",
      ],
    },
    {
      "title": "my Kitchen Desk",
      "desc": "Spot the differences on a complex kitchen desk.",
      "background": "assets/images/desk/desk.jpg",
      "hint": "A very complex kitchen scene with many items.",
      "color": Color.fromARGB(255, 2, 22, 11),
      "objects": [
        "assets/images/kichen/blender.png",
        "assets/images/kichen/ketal.png",
        "assets/images/kichen/knife.png",
        "assets/images/kichen/machin.png",
        "assets/images/kichen/mug.png",
        "assets/images/kichen/noname.png",
        "assets/images/kichen/overn.png",
        "assets/images/kichen/plate.png",
        "assets/images/kichen/pork.png",
      ],
    },
  ];

  // void _playInstructionsAudio() async {
  //   await _audioPlayer
  //       .play(AssetSource("assets/audios/differences_instructions.mp3"));
  // }

  Future<void> _loadDifficulty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? d = prefs.getInt('difference_difficulty');

    setState(() {
      _diff = d ?? 1;
      levelsToShow = d ?? 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDifficulty();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _navigateToNextScreen(Map<String, dynamic> levelData) {
    // Adjust objects based on difficulty level
    List<String> objects = List<String>.from(levelData["objects"]);

    if (_diff == 1) {
      objects = objects.take(2).toList(); // Easy: Use only first 2 objects
    } else if (_diff == 2) {
      objects = objects.take(3).toList(); // Medium: Use first 3 objects
    } else if (_diff == 3) {
      objects = objects.take(4).toList(); // Hard: Use first 4 objects
    } else if (_diff == 4) {
      objects = objects.take(5).toList(); // Very Hard: Use first 5 objects
    }

    // Shuffle the objects
    objects.shuffle(Random());

    // Pass modified levelData with shuffled objects
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DifferenceFindScreen(
          levelData: {...levelData, "objects": objects},
          difficulty: _diff,
        ),
      ),
    );
  }

  void _showDemoVideo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: DemoVideoPlayer(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/backgrounds/1737431584894.png_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Identify Difference and Drop',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Difficulty Level ${_diff.toString()}',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    leading: Container(
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 2, 173, 10),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 2, 173, 10),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orangeAccent.withOpacity(0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        // child: IconButton(
                        //   icon: Icon(Icons.logout, color: Colors.white),
                        //   onPressed: () async {
                        //     Provider.of<SessionProvider>(context, listen: false)
                        //         .clearSession();
                        //     SharedPreferences prefs =
                        //         await SharedPreferences.getInstance();
                        //     await prefs.remove('accessToken');
                        //     await prefs.remove('refreshToken');
                        //     Navigator.pushReplacementNamed(context, '/landing');
                        //   },
                        // ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xff27a5c6),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white, // White border
                        width: 1.0, // Small border width
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to Identify Difference Game!",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFCE6F6),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Choose a level to start finding the differences in various scenes.",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFD4D4D4)),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showDemoVideo,
                              icon: const Icon(Icons.play_circle_filled),
                              label: const Text("How to play"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PreviousDifferenceRecordsScreen()),
                                );
                              },
                              icon: const Icon(Icons.history),
                              label: const Text("Records"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: levels.length,
                    itemBuilder: (context, index) {
                      final level = levels[index];
                      final isLocked = index >= levelsToShow;
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 3.0),
                            child: GestureDetector(
                              onTap: () {
                                if (isLocked) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 16),
                                            Text(
                                              "Level locked! Unlock by increasing difficulty.",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Close"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  _navigateToNextScreen(level);
                                }
                              },
                              child: Card(
                                color: level["color"],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                    color: Colors.white, // White border
                                    width: 1.0, // Small border width
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        level["background"],
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              level["title"],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              level["desc"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isLocked)
                                        const Icon(
                                          Icons.lock,
                                          color: Colors.red,
                                          size: 24.0,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isLocked)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock,
                                        color: Colors.white, size: 40),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Level Locked",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Complete Difficulty level ${index} to unlock.",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 2, 173, 10),
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

// class DemoVideoPlayer extends StatefulWidget {
//   @override
//   _DemoVideoPlayerState createState() => _DemoVideoPlayerState();
// }

// class _DemoVideoPlayerState extends State<DemoVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool isVideoInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset("assets/videos/demov.mp4")
//       ..initialize().then((_) {
//         setState(() {
//           isVideoInitialized = true;
//         });
//         _controller.setLooping(true);
//         _controller.play();
//       }).catchError((error) {
//         print("Error initializing video: $error");
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.9,
//       height: MediaQuery.of(context).size.height * 0.5,
//       child: Column(
//         children: [
//           Expanded(
//             child: isVideoInitialized
//                 ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                 : const Center(child: CircularProgressIndicator()),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DemoVideoPlayer extends StatefulWidget {
  @override
  _DemoVideoPlayerState createState() => _DemoVideoPlayerState();
}

class _DemoVideoPlayerState extends State<DemoVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/demov.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      aspectRatio: _controller.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Error: $errorMessage',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
      // Add controls and styling options
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        handleColor: Colors.orangeAccent,
        backgroundColor: Colors.black26,
      ),
    );
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Chewie(
                controller: _chewieController,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
