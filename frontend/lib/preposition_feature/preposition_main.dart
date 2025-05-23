import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicmind_puzzle/preposition_feature/a.dart';
import 'package:magicmind_puzzle/preposition_feature/function.dart';
import 'package:magicmind_puzzle/preposition_feature/question.dart';
import 'package:magicmind_puzzle/preposition_feature/score.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';

class PrepositionHome extends StatelessWidget {
  const PrepositionHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/home-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Preposition",
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(0.3), // Semi-transparent whitish color
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 64, width: 1),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                      child: Card(
                        color: Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Hi there!",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    "Let’s start an exciting journey to discover the magic of prepositions!",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                      onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PlayVideo(
                                                        video:
                                                            'assets/file/instruction.mp4',
                                                      )),
                                            )
                                          },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF26a5c9),
                                          textStyle:
                                              TextStyle(color: Colors.white)),
                                      child: GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PlayVideo(
                                                      video:
                                                          'assets/file/instruction.mp4',
                                                    )),
                                          )
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 21,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text("Play instructions",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Image(
                        height: 76,
                        width: 76,
                        image: AssetImage(
                            "assets/img/home-sun.png"), // Path to your image
                        fit: BoxFit
                            .cover, // Adjust the fit of the image to cover the entire screen
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 120, width: 1),
                ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCA7FAC),
                        textStyle: TextStyle(color: Colors.white)),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlayVideo(
                                    video: 'assets/file/intro.mp4',
                                  )),
                        )
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 21,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("Start Learning",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseSource()),
                    )
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF26A5C9),
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  child: Text("Let's start",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'home-btn',
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (predicate) => false);
          },
          shape: CircleBorder(),
          backgroundColor: Color(0xFF766462),
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChooseSource extends StatelessWidget {
  const ChooseSource({super.key});

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/choose-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Select an Option",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(0.3), // Semi-transparent whitish color
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.fromLTRB(24, 86, 24, 64),
          child: Card(
            color: Color(0xCCFFFFFF),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 32,
                children: [
                  Text(
                    "Let’s Choose a Option to Continue....",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                      child: Card(
                          color: Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Color(0xFFECAD2C))),
                          child: GestureDetector(
                            onTap: () async {
                              LevelGame.addLevel(-1);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseImage(level: -1)));
                            },
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Upload\nThe\nImage",
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFECAD2C)),
                                      ),
                                      Image(
                                        image: AssetImage(
                                            "assets/img/choose-camera.png"),
                                        fit: BoxFit.cover,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                )),
                          ))),
                  Expanded(
                      child: Card(
                          color: Color(0xFFF8F8F8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Color(0xFF26A5C6))),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChooseLevel()),
                              )
                            },
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Generate\nan\nImage",
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF26A5C6)),
                                      ),
                                      Image(
                                        image: AssetImage(
                                            "assets/img/choose-generate.png"),
                                        fit: BoxFit.cover,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                )),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseImage extends StatelessWidget {
  final int level;
  const ChooseImage({super.key, required this.level});

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void chooseImage(BuildContext context, bool gallery) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
      source: gallery ? ImageSource.gallery : ImageSource.camera,
    );

    if (result != null) {
      GeneratedQuestion? question =
          await GeneratedQuestion.createUsingImage(result);

      if (question == null) {
        hideLoadingDialog(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  "Unable to identify any objects! Try again with a different image."),
            );
          },
        );

        return;
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Question(level: level, question: question)));
    } else {
      hideLoadingDialog(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Please select an image."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage("assets/img/choose-alt-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Snap,Upload,and Learn\nobject Preposition!",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(0.3), // Semi-transparent whitish color
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 86, 24, 86),
            child: Card(
              color: Color(0xCCFFFFFF),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  children: [
                    Card(
                        color: Color(0xFFF8F8F8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Color(0xFFECAD2C))),
                        child: GestureDetector(
                          onTap: () {
                            chooseImage(context, true);
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 40),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          "assets/img/choose-alt-gallery.png"),
                                      fit: BoxFit.cover,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Text(
                                      "Choose from camera roll",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF000000)),
                                    ),
                                  ],
                                ),
                              )),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Text(
                        "See Objects in action!\nPlease upload your photo clearly",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Card(
                        color: Color(0xFFF8F8F8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Color(0xFF26A5C6))),
                        child: GestureDetector(
                          onTap: () {
                            chooseImage(context, false);
                          },
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Take Photo",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF000000)),
                                    ),
                                    Image(
                                      image: AssetImage(
                                          "assets/img/choose-alt-camera.png"),
                                      fit: BoxFit.cover,
                                      height: 35,
                                    ),
                                  ],
                                ),
                              )),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'home-btn',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrepositionHome()),
          ),
          shape: CircleBorder(),
          backgroundColor: Color(0xFF766462),
          child: Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChooseLevel extends StatelessWidget {
  const ChooseLevel({super.key});

  Widget Level(BuildContext context, int left, int top, int level) {
    bool unlocked = LevelGame.isUnlocked(level);

    Size size = MediaQuery.of(context).size;

    int offset_left = 24;
    int offset_top = 105;
    List<double> adjusts_top = [0, 0, 15, 45, 90, 130, 150, 190, 290, 600];

    double l = (left *
            (size.width -
                (offset_left +
                    (adjusts_top.elementAtOrNull(level - 1) ?? 0) *
                        (12 / 105)))) /
        390.0;
    double t = (top *
            (size.height -
                (offset_top + (adjusts_top.elementAtOrNull(level - 1) ?? 0)))) /
        844;

    return Positioned(
      height: 79,
      top: t,
      left: l,
      child: GestureDetector(
        onTap: () async {
          if (unlocked) {
            LevelGame.addLevel(level);
            GeneratedQuestion question = await GeneratedQuestion.create(level);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Question(level: level, question: question)));
          }
        },
        child: Stack(
          children: [
            Image(
              image: AssetImage("assets/img/level-badge-$level.png"),
              fit: BoxFit.cover,
              height: 79,
            ),
            unlocked
                ? Container()
                : Image(
                    image: AssetImage("assets/img/level-badge-locked.png"),
                    fit: BoxFit.cover,
                    height: 79,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> levels = [];

    for (int i = 1; i <= 10; i++) {
      levels.add(Level(context, 0, 0, i));
    }

    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/level-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Levels",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                      .withOpacity(0.3), // Semi-transparent whitish color
                ),
                child: IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrepositionHome()),
                  ),
                ),
              ),
            )
          ],
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(0.3), // Semi-transparent whitish color
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Level(context, 207, 730, 1),
                Level(context, 62, 673, 2),
                Level(context, 168, 577, 3),
                Level(context, 266, 492, 4),
                Level(context, 129, 446, 5),
                Level(context, 44, 343, 6),
                Level(context, 169, 315, 7),
                Level(context, 275, 244, 8),
                Level(context, 155, 184, 9),
                Level(context, 44, 105, 10),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'home-btn',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrepositionHome()),
                ),
                shape: CircleBorder(),
                backgroundColor: Color(0xFF766462),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Score()),
                  );
                },
                backgroundColor: Colors.transparent,
                child: Image(
                  image: AssetImage("assets/img/level-score-btn.png"),
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question extends StatefulWidget {
  final int level;
  final int number;
  final GeneratedQuestion question;

  const Question(
      {super.key,
      required this.level,
      required this.question,
      this.number = 1});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  void _showDropdown(BuildContext context, Sentence sentence) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RawImage(
                image: widget.question.image,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                    child: Text(
                  "${sentence.pre} _____ ${sentence.post}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )),
              ),
              ...sentence.answers.map((option) => ListTile(
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        sentence.userAnswer = option;
                      });
                      Navigator.pop(context);
                    },
                  ))
            ].toList(),
          ),
        );
      },
    );
  }

  bool finished = false;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> paragraph = [];
    for (Sentence sentence in widget.question.sentences) {
      sentence.userAnswer = sentence.userAnswer ?? "";

      paragraph.add(TextSpan(text: sentence.pre));
      if (finished) {
        final bool correct = sentence.answer == sentence.userAnswer;

        paragraph.add(WidgetSpan(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: correct ? Colors.green[300] : Colors.red[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              sentence.userAnswer! + (correct ? "" : " (${sentence.answer})"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white),
            ),
          ),
        ));
      } else {
        paragraph.add(WidgetSpan(
          child: GestureDetector(
            onTap: () {
              _showDropdown(context, sentence);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: Color(0x66D9D9D9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                sentence.userAnswer!.length > 0 ? sentence.userAnswer! : '____',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA1FFA4),
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ),
        ));
      }
      paragraph.add(TextSpan(text: "${sentence.post}. "));
    }

    widget.level > 0
        ? "Level ${widget.level}: Question ${widget.number} / ${Config.NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL}"
        : "Question ${-1 * widget.level} / ${Config.NUM_OF_QUESTIONS_FOR_IMAGE_UPLOAD_SESSION}";

    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/question-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: widget.level > 0
              ? Row(
                  children: [
                    Text(
                      "Level ${widget.level.toString().padLeft(2, "0")}",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    Text(
                      ": Question ${widget.number} / ${Config.NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )
                  ],
                )
              : Text(
                  "Question ${-1 * widget.level} / ${Config.NUM_OF_QUESTIONS_FOR_IMAGE_UPLOAD_SESSION}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withOpacity(0.3), // Semi-transparent whitish color
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 4,
              children: [
                Container(
                  child: RawImage(
                    image: widget.question.image,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        children: paragraph,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'home-btn',
                onPressed: () {},

                // onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),),
                shape: CircleBorder(),
                backgroundColor: Color(0x4DFFFFFF),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                heroTag: 'check-btn',
                onPressed: () async {
                  print(widget.level);

                  if (finished) {
                    bool correct = true;

                    for (Sentence sentence in widget.question.sentences) {
                      if (sentence.answer != sentence.userAnswer)
                        correct = false;
                    }

                    int level_number = widget.level >= 0 ? widget.level : -1;

                    if (!LevelGame.score.containsKey(level_number)) {
                      LevelGame.addLevel(level_number);
                    }

                    Level level = LevelGame.score[level_number]!;
                    level.questions[widget.number] = correct;

                    if (widget.level > 0) {
                      if (widget.number <
                          Config.NUM_OF_QUESTIONS_FOR_SINGLE_LEVEL) {
                        GeneratedQuestion question =
                            await GeneratedQuestion.create(widget.level);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Question(
                                      level: widget.level,
                                      question: question,
                                      number: widget.number + 1,
                                    )));
                      } else {
                        level.end = DateTime.now();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Won(
                                    level: level_number,
                                  )),
                        );
                      }
                    } else if (widget.level <=
                        -1 * Config.NUM_OF_QUESTIONS_FOR_IMAGE_UPLOAD_SESSION)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Won(
                                  level: level_number,
                                )),
                      );
                    else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChooseImage(level: widget.level - 1)));
                    }
                  } else {
                    setState(() {
                      finished = true;
                    });
                  }
                },
                shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 2)),
                backgroundColor: Color(0x8DFFFFFF),
                child: Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Won extends StatelessWidget {
  final int level;

  const Won({super.key, required this.level});

  Widget starBar(int percentage) {
    DrawIcon(percentage, start) {
      int left = percentage - start;
      if (left >= 33)
        return Icon(
          Icons.star,
          color: Colors.yellowAccent,
          size: 43,
        );
      if (left >= 16)
        return Icon(
          Icons.star_half,
          color: Colors.yellowAccent,
          size: 43,
        );
      return Icon(
        Icons.star,
        color: Colors.grey,
        size: 43,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DrawIcon(percentage, 0),
        DrawIcon(percentage, 33),
        DrawIcon(percentage, 67),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Level level_ = LevelGame.score[level]!;
    int score = LevelGame.getScore(level);
    // percentage = LevelGame.getScorePercentage(level);
    String y = LevelGame.getScoreText(level);

    bool last = level == Config.NUM_OF_LEVELS;

    int overall_score = 0;
    int overall_time = 0;

    for (Level x in LevelGame.score.values) {
      try {
        overall_time += x.seconds();
      } catch (e) {}
    }

    try {
      for (int i = 0; i < 10; i++) {
        int level = i + 1;
        int score = LevelGame.getScore(level);
        overall_score += score;
      }
    } catch (e) {}

    int minutes = (overall_time / 60).toInt();
    overall_time -= minutes * 60;

    String _time = "$minutes min $overall_time seconds";

    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/question-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0x3C000000),
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ),)
        body: Stack(
          children: [
            SizedBox(
              height: 1,
              width: 1,
              child: Visibility(
                  visible: true,
                  child: PlayVideo(
                    video: 'assets/file/won.mp4',
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 64, 32, 64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: last ? 30 : 120,
                    ),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    level_.completed()
                                        ? "Congratulations!"
                                        : " You lost",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: level_.completed()
                                            ? Color(0xFFECAD2C)
                                            : Color(0xFFEC2CAD)),
                                  ),
                                ),
                                last
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 0),
                                        child: Text(
                                          y,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: level_.completed()
                                                  ? Color(0xFFECAD2C)
                                                  : Color(0xFFEC2CAD)),
                                        ),
                                      )
                                    : Container(),
                                // starBar(percentage),
                                Image(
                                  image: AssetImage(level_.completed()
                                      ? "assets/img/congrats-img.png"
                                      : "assets/img/lost-img.png"), // Path to your image
                                  fit: BoxFit.cover,
                                  height: 280,
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0),
                                    child: Text(
                                      "Score: $score",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                level > 0
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 0),
                                          child: Text(
                                            "Time spent: ${level_.time()}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                last
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 0),
                                          child: Text(
                                            "Total score: $overall_score",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF8EBE83),
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                last
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 0),
                                          child: Text(
                                            "Total Time: $_time",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF8EBE83)),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: last ? 30 : 50,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => level > 0
                                    ? const ChooseLevel()
                                    : ChooseImage(level: -1)),
                          )
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8EBE83),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: Text("Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Score extends StatelessWidget {
  const Score({super.key});

  Widget starBar(int percentage) {
    DrawIcon(percentage, start) {
      int left = percentage - start;
      if (left >= 33)
        return Icon(
          Icons.star,
          color: Colors.yellowAccent,
          size: 43,
        );
      if (left >= 16)
        return Icon(
          Icons.star_half,
          color: Colors.yellowAccent,
          size: 43,
        );
      return Icon(
        Icons.star,
        color: Colors.grey,
        size: 43,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DrawIcon(percentage, 0),
        DrawIcon(percentage, 33),
        DrawIcon(percentage, 67),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int overall = 0;
    for (int i = 0; i < 10; i++) {
      int level = i + 1;
      int score = LevelGame.getScore(level);
      overall += score;
      // int percentage = LevelGame.getScorePercentage(level);
      // String time = level_.time();
    }

    return Container(
      constraints:
          BoxConstraints.expand(), // Make the Container fill the entire screen
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/question-bg.png"), // Path to your image
          fit: BoxFit
              .cover, // Adjust the fit of the image to cover the entire screen
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0x3C000000),
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const ),)
        body: Stack(
          children: [
            SizedBox(
              height: 1,
              width: 1,
              child: Visibility(
                  visible: true,
                  child: PlayVideo(
                    video: 'assets/file/won.mp4',
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 64, 32, 64),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: Text(
                                    "Congratulations!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFECAD2C),
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 0,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/img/congrats-img.png"), // Path to your image
                                    fit: BoxFit.cover,
                                    height: 280,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0),
                                    child: Text(
                                      "Overall Score: $overall",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          LevelGame.score = HashMap();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PrepositionHome()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8EBE83),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        child: Text("Reset score",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
