import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:merged_app/constants/constant.dart';
import 'package:merged_app/screens/puzzle/puzzle_levels_screen.dart';
import 'package:merged_app/services/mongodb.dart';
import 'package:merged_app/services/shared_prefs_service.dart';


import '../../utils/function.dart';

class JigsawHomePage extends StatefulWidget {
  final int factor;
  final int difficulty;
  final String prompt;

  JigsawHomePage({
    required this.factor,
    required this.difficulty,
    required this.prompt,
  });

  @override
  _JigsawHomePageState createState() => _JigsawHomePageState();
}

class _JigsawHomePageState extends State<JigsawHomePage>
    with SingleTickerProviderStateMixin {
  ui.Image? canvasImage;
  bool _loaded = false;
  bool isLoading = false;
  List<JigsawPiece> pieceOnBoard = [];
  List<JigsawPiece> pieceOnPool = [];
  JigsawPiece? _currentPiece;
  Animation<Offset>? _offsetAnimation;
  final _boardWidgetKey = GlobalKey();
  late AnimationController _animController;

  int _timeElapsed = 0;
  int _movesMade = 0;
  int _totalMoves = 0;
  int _score = 0;

  String dificulityLevel = 'Low';
  String imagePrompt = '';

  Timer? _timer;

  int hintUsed = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _animController = AnimationController(vsync: this);

    super.initState();
  }

  void checkUserStruggle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Need some help?"),
        content: Text("It seems you're struggling. Would you like a hint?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _consecutiveWrongMoves = 0;
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              fillPuzzleHints();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void fillPuzzleHints() {
    if (pieceOnPool.length <= 4) {
      setState(() {
        int piecesToFill = min(1, pieceOnPool.length);
        for (int i = 0; i < piecesToFill; i++) {
          var piece = pieceOnPool.removeAt(0);
          pieceOnBoard.add(piece);
        }
        hintUsed = hintUsed + 2;
      });
    } else if (pieceOnPool.length > 4 && pieceOnPool.length <= 8) {
      setState(() {
        int piecesToFill = min(2, pieceOnPool.length);
        for (int i = 0; i < piecesToFill; i++) {
          var piece = pieceOnPool.removeAt(0);
          pieceOnBoard.add(piece);
        }
        hintUsed = hintUsed + 4;
      });
    } else if (pieceOnPool.length > 8 && pieceOnPool.length <= 12) {
      setState(() {
        int piecesToFill = min(3, pieceOnPool.length);
        for (int i = 0; i < piecesToFill; i++) {
          var piece = pieceOnPool.removeAt(0);
          pieceOnBoard.add(piece);
        }
        hintUsed = hintUsed + 6;
      });
    } else if (pieceOnPool.length > 12 && pieceOnPool.length <= 20) {
      setState(() {
        int piecesToFill = min(5, pieceOnPool.length);
        for (int i = 0; i < piecesToFill; i++) {
          var piece = pieceOnPool.removeAt(0);
          pieceOnBoard.add(piece);
        }
        hintUsed = hintUsed + 8;
      });
    } else if (pieceOnPool.length > 20 && pieceOnPool.length <= 35) {
      setState(() {
        int piecesToFill = min(8, pieceOnPool.length);
        for (int i = 0; i < piecesToFill; i++) {
          var piece = pieceOnPool.removeAt(0);
          pieceOnBoard.add(piece);
        }
        hintUsed = hintUsed + 10;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _prepareGame();
  }

  void _startTimer() {
    _timeElapsed = 0;
    _movesMade = 0;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _adjestDifficulity(
      int correctM, int wrongM, int hintUsage) async {
    print('Inside _adjestDifficulity');

    final response = await http.post(
      Uri.parse('$ML_API/adjust-difficulty'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "correct_moves": correctM,
        "wrong_moves": wrongM,
        "hint_usage": hintUsage,
        "current_split_count": correctM
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      String difficulty = responseData['difficulty'];
      String prompt = responseData['image_prompt'];

      print(difficulty);

      setState(() {
        dificulityLevel = difficulty;
        imagePrompt = prompt;
        isLoading = false;
      });

      int factor = responseData['new_split_count'];

      await saveString("l1_gen_factor", factor.toString());
      await saveString("l1_gen_level", difficulty.toString());
      await saveString("l1_gen_difficulty", "1");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JigsawHomePage(
            factor: responseData['new_split_count'],
            difficulty: 1,
            prompt: prompt,
          ),
        ),
      );
    }
  }

  void _prepareGame() async {
    pieceOnPool.clear();
    pieceOnBoard.clear();

    setState(() {
      _loaded = false;
    });

    print('Prompt: ${widget.prompt}');

    final screenPixelScale = MediaQuery.of(context).devicePixelRatio;
    final imageSize = (300 * screenPixelScale).toInt();

    final response = await http.post(
      Uri.parse('https://api.dezgo.com/text2image/'),
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'X-Dezgo-Key':
            'DEZGO-9F9A8CB100D69E6884C9A7F907306607D71183DD121B7A083AF9E003CBD4AB5F8DCEA4A1',
      },
      body: {
        'prompt': widget.prompt != null
            ? widget.prompt
            : 'A simple, vibrant cartoon image of a friendly animal character, in a cheerful outdoor setting.',
        'height': imageSize.toString(),
        'width': imageSize.toString(),
      },
    );
    final imageData = response.bodyBytes;

    final image = MemoryImage(imageData, scale: screenPixelScale);

    canvasImage = await _getImage(image);
    pieceOnPool = _createJigsawPiece();
    pieceOnPool.shuffle();

    setState(() {
      _loaded = true;
      print('Loading done');
    });

    _startTimer();
  }

  Future<ui.Image> _getImage(ImageProvider image) async {
    final completer = Completer<ImageInfo>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete(info);
      }),
    );

    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          body: _loaded
              ? Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.9,
                      image: AssetImage('assets/images/activity_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppBar().preferredSize.height / 5 * 4,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                            ),
                            Spacer(),
                            Text(
                              "Let’s Play",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Andika',
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                bool demo = true;
                                //_prepareGame();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PuzzleLevelsScreen(
                                            demo: demo,
                                          )),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Image.asset(
                                      'assets/images/home_icon.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: _buildBoard(),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                              top: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.all(32),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: pieceOnPool.length,
                            itemBuilder: (context, index) {
                              final piece = pieceOnPool[index];
                              return Center(
                                child: Draggable(
                                  child: piece,
                                  feedback: piece,
                                  childWhenDragging: Opacity(
                                    opacity: 0.24,
                                    child: piece,
                                  ),
                                  onDragEnd: (details) {
                                    _onPiecePlaced(piece, details.offset);
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 32),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/loading_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth / 2,
                        child: Center(
                          child: Lottie.asset(
                              'assets/animations/image_processing.json'),
                        ),
                      ),
                      Lottie.asset('assets/animations/loading_ani.json'),
                      Text(
                        "Get ready! Your picture is on its way!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontFamily: 'Andika',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          floatingActionButton: _loaded
              ? Container(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (canvasImage != null) {
                        _showFullImageDialog(context);
                        setState(() {
                          hintUsed++;
                        });
                      }
                    },
                    child: Image.asset(
                      'assets/images/hint_icon.png',
                      height: 62,
                    ),
                  ),
                )
              : SizedBox(),
        ),
        if (_currentPiece != null)
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final offset = _offsetAnimation?.value ?? Offset.zero;
              return Positioned(
                left: offset.dx,
                top: offset.dy,
                child: child!,
              );
            },
            child: _currentPiece,
          ),
      ],
    );
  }

  bool isCorrect = false;

  Widget _buildBoard() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 5,
              color: const Color.fromARGB(255, 236, 173, 44),
            ),
          ),
          key: _boardWidgetKey,
          width: 305,
          height: 305,
          child: Stack(
            children: [
              for (var piece in pieceOnBoard)
                Positioned(
                  left: piece.boundary.left,
                  top: piece.boundary.top,
                  child: piece,
                ),
            ],
          ),
        ),
        isCorrect
            ? SizedBox(
                width: 305,
                height: 305,
                child: Center(
                  child: Lottie.asset('assets/animations/correct.json'),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  List<JigsawPiece> _createJigsawPiece() {
    return [
      for (int i = 0; i < widget.factor; i++)
        for (int j = 0; j < widget.factor; j++)
          JigsawPiece(
            key: UniqueKey(),
            image: canvasImage,
            imageSize: Size(300, 300),
            points: [
              Offset((i / widget.factor) * 300, (j / widget.factor) * 300),
              Offset(
                  ((i + 1) / widget.factor) * 300, (j / widget.factor) * 300),
              Offset(((i + 1) / widget.factor) * 300,
                  ((j + 1) / widget.factor) * 300),
              Offset(
                  (i / widget.factor) * 300, ((j + 1) / widget.factor) * 300),
            ],
          ),
    ];
  }

  void _checkWrongMoveProgress() {
    if (pieceOnPool.length > 2 && pieceOnPool.length <= 4) {
      if (_consecutiveWrongMoves >= 2) {
        checkUserStruggle();
        _consecutiveWrongMoves = 0;
      }
    } else if (pieceOnPool.length > 4 && pieceOnPool.length <= 8) {
      if (_consecutiveWrongMoves >= 4) {
        checkUserStruggle();
        _consecutiveWrongMoves = 0;
      }
    } else if (pieceOnPool.length > 8 && pieceOnPool.length <= 12) {
      if (_consecutiveWrongMoves >= 6) {
        checkUserStruggle();
        _consecutiveWrongMoves = 0;
      }
    } else if (pieceOnPool.length > 12 && pieceOnPool.length <= 20) {
      if (_consecutiveWrongMoves >= 8) {
        checkUserStruggle();
        _consecutiveWrongMoves = 0;
      }
    } else if (pieceOnPool.length > 20 && pieceOnPool.length <= 35) {
      if (_consecutiveWrongMoves >= 10) {
        checkUserStruggle();
        _consecutiveWrongMoves = 0;
      }
    }
  }

  int _consecutiveWrongMoves = 0; // Tracks consecutive wrong moves

  void _onPiecePlaced(JigsawPiece piece, Offset pieceDropPosition) async {
    _totalMoves++; // Increment total moves
    final RenderBox box =
        _boardWidgetKey.currentContext?.findRenderObject() as RenderBox;
    final boardPosition = box.localToGlobal(Offset.zero);
    final targetPosition =
        boardPosition.translate(piece.boundary.left, piece.boundary.top);

    const threshold = 48.0;
    final distance = (pieceDropPosition - targetPosition).distance;

    if (distance < threshold) {
      setState(() {
        _currentPiece = piece;
        pieceOnPool.remove(piece);
        _movesMade++; // Correct move made
        _consecutiveWrongMoves = 0; // Reset wrong move counter
      });

      await _audioPlayer.play(AssetSource('audios/correct_move.wav'));

      _offsetAnimation = Tween<Offset>(
        begin: pieceDropPosition,
        end: targetPosition,
      ).animate(_animController);

      _animController.addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          setState(() {
            pieceOnBoard.add(piece);
            _currentPiece = null;
          });

          if (pieceOnPool.isEmpty) {
            _stopTimer();
            _calculateScore();
            setState(() {
              isCorrect = true;
            });

            await _audioPlayer.play(AssetSource('audios/completed.wav'));

            Future.delayed(Duration(seconds: 2), () async {
              setState(() {
                isCorrect = false;
              });
              _showCompletionDialog(context);
            });
          }
        }
      });

      const spring = SpringDescription(
        mass: 30,
        stiffness: 1,
        damping: 1,
      );

      final simulation = SpringSimulation(spring, 0, 1, -distance);
      _animController.animateWith(simulation);
    } else {
      // If move was incorrect, increment wrong move counter
      _consecutiveWrongMoves++;
      _checkWrongMoveProgress();
      await _audioPlayer.play(AssetSource('audios/wrong_move.wav'));
    }
  }

  void _calculateScore() {
    final incorrectMoves =
        _totalMoves - _movesMade; // Calculate incorrect moves

    // Base score calculation
    double baseScore = 100.0;

    // Deduct points based on time taken
    baseScore -= (_timeElapsed / 10).clamp(0, 50);

    // Deduct points for incorrect moves
    baseScore -= (incorrectMoves * 2).clamp(0, 40);

    // Add difficulty bonus
    baseScore += (widget.difficulty * 5).clamp(0, 20);

    // Ensure score is within bounds
    _score = baseScore.clamp(0, 100).round();
  }

  final confettiController = ConfettiController();

  bool isCongrating = false;

  void _showCompletionDialog(BuildContext context) async {
    await _audioPlayer.play(AssetSource('audios/congrats.wav'));
    final incorrectMoves = _totalMoves - _movesMade;
    confettiController.play();
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Congratulations!',
                style: TextStyle(
                  color: const Color.fromARGB(255, 236, 173, 44),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Andika',
                ),
              ),
            ),
            content: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/congrats_banner.png'),
                    SizedBox(height: 20),
                    Text(
                      'Time Taken: ${_formatTime(_timeElapsed)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    Text(
                      'Wrong Moves: $incorrectMoves',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    Text(
                      'Score: $_score/100',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    Text(
                      'Hint Usage: $hintUsed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: screenWidth / 2,
                  child: SizedBox(
                    width: 1,
                    height: 300,
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      shouldLoop: true,
                      blastDirectionality: BlastDirectionality.explosive,
                      numberOfParticles: 35,
                      emissionFrequency: 0.1,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.white.withOpacity(0.2),
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    final uid = await SharedPrefs.getUserId();

                    await MongoDatabase.insertData(
                      difficultyLevel: dificulityLevel,
                      timeElapsed: _timeElapsed,
                      movesMade: _movesMade,
                      incorrectMoves: incorrectMoves,
                      hintUsed: hintUsed,
                      score: _score,
                      level: 1,
                      user_id: uid.toString(),
                    );
                    print('Calling _adjestDifficulity...');

                    await _adjestDifficulity(
                        _movesMade, incorrectMoves, hintUsed);

                    print('_adjestDifficulity completed');
                  } catch (e) {
                    print('Error in onTap: $e');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  height: 56,
                  width: 123,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 142, 190, 132),
                  ),
                  child: Center(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Andika',
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  void _showFullImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Complete Image is Here...',
            style: TextStyle(
              color: const Color.fromARGB(255, 117, 100, 100),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Andika',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (canvasImage != null)
                SizedBox(
                  height: 300,
                  child: RawImage(image: canvasImage),
                ),
              SizedBox(height: 16),
              Text(
                'Time Taken: ${_formatTime(_timeElapsed)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'ABeeZee',
                ),
              ),
              Text(
                'Moves Made: $_movesMade',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'ABeeZee',
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: Colors.white.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 56,
                width: 123,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 236, 173, 44),
                ),
                child: Center(
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Andika',
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class JigsawPiece extends StatelessWidget {
  JigsawPiece({
    Key? key,
    required this.image,
    required this.points,
    required this.imageSize,
  })  : assert(points.isNotEmpty),
        boundary = _getBounds(points),
        super(key: key);

  final Rect boundary;
  final ui.Image? image;
  final List<Offset> points;
  final Size imageSize;

  Size get size => boundary.size;

  @override
  Widget build(BuildContext context) {
    final pixelScale = MediaQuery.of(context).devicePixelRatio;

    return CustomPaint(
      painter: JigsawPainter(
        image: image,
        boundary: boundary,
        points: points,
        pixelScale: pixelScale,
        elevation: 0,
      ),
      size: size,
    );
  }

  static Rect _getBounds(List<Offset> points) {
    final pointsX = points.map((e) => e.dx);
    final pointsY = points.map((e) => e.dy);
    return Rect.fromLTRB(
      pointsX.reduce(min),
      pointsY.reduce(min),
      pointsX.reduce(max),
      pointsY.reduce(max),
    );
  }
}

class JigsawPainter extends CustomPainter {
  final ui.Image? image;
  final List<Offset> points;
  final Rect boundary;
  final double pixelScale;
  final double elevation;

  const JigsawPainter({
    required this.image,
    required this.points,
    required this.boundary,
    required this.pixelScale,
    this.elevation = 0,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint();
    final path = getClip(size);
    if (elevation > 0) {
      canvas.drawShadow(path, Colors.black, elevation, false);
    }

    canvas.clipPath(path);
    if (image != null) {
      canvas.drawImageRect(
          image!,
          Rect.fromLTRB(boundary.left * pixelScale, boundary.top * pixelScale,
              boundary.right * pixelScale, boundary.bottom * pixelScale),
          Rect.fromLTWH(0, 0, boundary.width, boundary.height),
          paint);
    }
  }

  Path getClip(Size size) {
    final path = Path();
    for (var point in points) {
      if (points.indexOf(point) == 0) {
        path.moveTo(point.dx - boundary.left, point.dy - boundary.top);
      } else {
        path.lineTo(point.dx - boundary.left, point.dy - boundary.top);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant JigsawPainter oldDelegate) {
    return oldDelegate.image != image;
  }
}
