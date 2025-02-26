import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:magicmind_puzzle/screens/puzzle/puzzle_levels_screen.dart';

import '../../utils/function.dart';
import '../home/home_screen.dart';

const TextStyle demoStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'ABeeZee');

class PuzzleDemo extends StatelessWidget {
  const PuzzleDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Demo',
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ShowCaseWidget(
          onStart: (index, key) {
            // log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            // log('onComplete: $index, $key');
            if (index == 4) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.light.copyWith(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white,
                ),
              );
            }
          },
          blurValue: 1,
          autoPlayDelay: const Duration(seconds: 3),
          builder: (context) => const DemoImageOption(
            factor: 1,
            difficulty: 1,
          ),
        ),
      ),
    );
  }
}

class DemoImageOption extends StatefulWidget {
  final int factor;
  final int difficulty;

  const DemoImageOption(
      {Key? key, required this.factor, required this.difficulty})
      : super(key: key);

  @override
  State<DemoImageOption> createState() => _DemoImageOptionState();
}

class _DemoImageOptionState extends State<DemoImageOption> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_one, _two]),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.9,
            image: AssetImage('assets/images/select_option_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  Showcase(
                    key: _one,
                    descTextStyle: demoStyle,
                    description: 'Tap to take an image using your camera.',
                    child: GestureDetector(
                      onTap: () {
                        startPuzzle();
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Showcase(
                    key: _two,
                    description: 'Tap to generate an image using AI.',
                    descTextStyle: demoStyle,
                    child: GestureDetector(
                      onTap: () {
                        startPuzzle();
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

  void startPuzzle() async {
    final screenPixelScale = MediaQuery.of(context).devicePixelRatio;
    final imageSize = (300 * screenPixelScale).toInt();

    ByteData data = await rootBundle.load("assets/images/demo.png");

    final image =
        MemoryImage(data.buffer.asUint8List(), scale: screenPixelScale);

    final completer = Completer<ImageInfo>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete(info);
      }),
    );

    ImageInfo imageInfo = await completer.future;

    ui.Image img_ = await imageInfo.image;

    final ByteData? byteData =
        await img_.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List uint8list = byteData!.buffer.asUint8List();
    final img.Image decodedImage = img.decodeImage(uint8list)!;
    final img.Image resizedImage =
        img.copyResize(decodedImage, height: imageSize, width: imageSize);
    final Uint8List resizedBytes = img.encodePng(resizedImage);
    final ui.Codec codec = await ui.instantiateImageCodec(resizedBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();

    ui.Image canvasImage = frame.image;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DemoGame(canvasImage: canvasImage),
      ),
    );
  }
}

class JigsawPiece extends StatelessWidget {
  JigsawPiece({
    Key? key,
    required this.image,
    required this.points,
    required this.imageSize,
    required this.position,
  })  : assert(points.isNotEmpty),
        boundary = _getBounds(points),
        super(key: key);

  final Rect boundary;
  final ui.Image? image;
  final List<Offset> points;
  final Size imageSize;
  final String position;

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

class DemoGame extends StatelessWidget {
  final ui.Image canvasImage;

  const DemoGame({Key? key, required this.canvasImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Demo',
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ShowCaseWidget(
          onStart: (index, key) {
            // log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            // log('onComplete: $index, $key');
            if (index == 4) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.light.copyWith(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white,
                ),
              );
            }
          },
          blurValue: 1,
          autoPlayDelay: const Duration(seconds: 3),
          builder: (context) => DemoPuzzle(canvasImage),
        ),
      ),
    );
  }
}

class DemoPuzzle extends StatefulWidget {
  final int factor = 2;
  final int difficulty = 1;
  final ui.Image canvasImage;

  DemoPuzzle(this.canvasImage);

  @override
  _DemoPuzzleState createState() => _DemoPuzzleState();
}

class _DemoPuzzleState extends State<DemoPuzzle>
    with SingleTickerProviderStateMixin {
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

  int currentIndex = 0;

  Timer? _timer;

  int hintUsed = 0;

  final List<GlobalKey> keys = [GlobalKey(), GlobalKey(), GlobalKey()];

  @override
  void initState() {
    _animController = AnimationController(vsync: this);

    pieceOnPool = _createJigsawPiece();
    pieceOnPool.shuffle();
    _startTimer();

    super.initState();

    for (int i = 0; i < pieceOnPool.length; i++) {
      keys.add(GlobalKey());
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          ShowCaseWidget.of(context).startShowCase([keys[0], keys[1], keys[2]]),
    );
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: screenWidth,
            height: screenHeight,
            padding: EdgeInsets.symmetric(horizontal: 30),
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
                Row(
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
                        bool demo = await loadString("demo", "no") != "no";
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
                          child: Image.asset('assets/images/home_icon.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: Showcase(
                    key: keys[0],
                    description:
                        'This is where you will solve the puzzle. Drag and drop all puzzle pieces in the correct order.',
                    descTextStyle: demoStyle,
                    child: Container(
                      key: _boardWidgetKey,
                      width: 305,
                      height: 305,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 5,
                          color: const Color.fromARGB(255, 236, 173, 44),
                        ),
                      ),
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
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(32),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: pieceOnPool.length,
                    itemBuilder: (context, index) {
                      final piece = pieceOnPool[index];
                      return Center(
                        child: Showcase(
                          key: keys[2 + index],
                          descTextStyle: demoStyle,
                          description:
                              'Place this puzzle piece in ${piece.position} corner to solve the puzzle.',
                          child: Draggable(
                            child: piece,
                            feedback: piece,
                            childWhenDragging: Opacity(
                              opacity: 0.24,
                              child: piece,
                            ),
                            onDragEnd: (details) {
                              _onPiecePlaced(piece, details.offset, index);
                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 32),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Showcase(
            key: keys[1],
            description:
                'Tap here to view the full image, if you think you are lost.',
            descTextStyle: demoStyle,
            child: Container(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _showFullImageDialog(context);
                  setState(() {
                    hintUsed++;
                  });
                },
                child: Image.asset(
                  'assets/images/hint_icon.png',
                  height: 62,
                ),
              ),
            ),
          ),
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

  int random_length() {
    return Random().nextInt(5) > 2 ? 2 : 1;
  }

  String get_position(int x, int y, int w, int h) {
    List<String> out = [];

    if (h == 1) {
      out.add(y == 0 ? "Top" : "Bottom");
    }
    if (w == 1) {
      out.add(x == 0 ? "Left" : "Right");
    }

    return out.join(" ");
  }

  List<JigsawPiece> _createJigsawPiece() {
    int factor = widget.factor;

    List<JigsawPiece> pieces = [];

    List<List<int>> used = [];

    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {
        bool found = false;
        for (List<int> use in used) {
          if (x == use[0] && y == use[1]) found = true;
        }

        if (found) continue;

        int lx = 1;
        int ly = 1;

        if (y < (factor - 1)) {
          ly = random_length();
        }
        if (x < (factor - 1)) {
          lx = random_length();
        }
        if (lx > 1) {
          used.add([x + 1, y]);
          if (ly > 1) {
            ly = 1;
          }
        } else if (ly > 1) {
          used.add([x, y + 1]);
        }

        pieces.add(JigsawPiece(
          key: UniqueKey(),
          position: get_position(x, y, lx, ly),
          image: widget.canvasImage,
          imageSize: Size(300, 300),
          points: [
            Offset((x / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, ((y + ly) / factor) * 300),
            Offset((x / factor) * 300, ((y + ly) / factor) * 300),
          ],
        ));

        if (ly > 1) y++;
      }
    }

    return pieces;
  }

  void _onPiecePlaced(JigsawPiece piece, Offset pieceDropPosition, int index) {
    _totalMoves++; // Increment total moves
    final RenderBox box =
        _boardWidgetKey.currentContext?.findRenderObject() as RenderBox;
    final boardPosition = box.localToGlobal(Offset.zero);
    final targetPosition =
        boardPosition.translate(piece.boundary.left, piece.boundary.top);

    const threshold = 48.0;

    final distance = (pieceDropPosition - targetPosition).distance;
    if (distance < threshold && index == 0) {
      setState(() {
        _currentPiece = piece;
        pieceOnPool.remove(piece);
        _movesMade++;
        keys.removeAt(2);
      });

      _offsetAnimation = Tween<Offset>(
        begin: pieceDropPosition,
        end: targetPosition,
      ).animate(_animController);

      _animController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            pieceOnBoard.add(piece);
            _currentPiece = null;
          });

          if (pieceOnPool.isEmpty) {
            _stopTimer();
            _calculateScore();
            _showCompletionDialog(context);
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
    }

    ShowCaseWidget.of(context).startShowCase([keys[2]]);
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

  void _showCompletionDialog(BuildContext context) {
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
                  await saveString("demo", "yes");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Container(
                  height: 56,
                  width: 123,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 142, 190, 132),
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
        return Container(
          child: AlertDialog(
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
                SizedBox(
                  height: 300,
                  child: RawImage(image: widget.canvasImage),
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
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    confettiController.dispose();
    super.dispose();
  }
}
