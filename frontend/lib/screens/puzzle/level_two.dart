import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

import '../../utils/function.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:magicmind_puzzle/constants/constant.dart';
import 'package:magicmind_puzzle/screens/puzzle/puzzle_levels_screen.dart';
import 'package:magicmind_puzzle/services/mongodb.dart';


class LevelTwo_SelectImageOption extends StatefulWidget {
  final int factor;
  final int difficulty;
  const LevelTwo_SelectImageOption({
    super.key,
    required this.factor,
    required this.difficulty,
  });

  @override
  State<LevelTwo_SelectImageOption> createState() => _LevelTwo_SelectImageOptionState();
}

class _LevelTwo_SelectImageOptionState extends State<LevelTwo_SelectImageOption> {

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

                int factor = int.parse(await loadString("l2_gen_factor", "1"));
                String level = (await loadString("l2_gen_level", "Low"));
                int difficulty = int.parse(await loadString("l2_gen_difficulty", "1"));

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

                int factor = int.parse(await loadString("l2_gen_factor", "1"));
                String level = (await loadString("l2_gen_level", "Low"));
                int difficulty = int.parse(await loadString("l2_gen_difficulty", "1"));

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


class JisawHomeCamaraImage extends StatefulWidget {
  final int factor;
  final int difficulty;
  const JisawHomeCamaraImage(
      {super.key, required this.factor, required this.difficulty});

  @override
  State<JisawHomeCamaraImage> createState() => _JisawHomeCamaraImageState();
}

class _JisawHomeCamaraImageState extends State<JisawHomeCamaraImage>
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

  String dificulityLevel = 'Low';

  int _timeElapsed = 0;
  int _movesMade = 0;
  int _totalMoves = 0;
  int _score = 0;

  Timer? _timer;

  int hintUsed = 0;

  @override
  void initState() {
    _animController = AnimationController(vsync: this);
    pickImageCamara();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  XFile? pickedFile;

  Future<void> pickImageCamara() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    _prepareGame(pickedImage);
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

  Future<void> _adjestDifficulity(int correctM, int wrongM) async {
    final response = await http.post(
      Uri.parse('$ML_API/adjust-difficulty'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "correct_moves": correctM,
        "wrong_moves": wrongM,
        "current_split_count": correctM,
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      String difficulty = responseData['difficulty'];
      setState(() {
        dificulityLevel = difficulty;
        isLoading = false;
      });

      int factor = responseData['new_split_count'];
      await saveString("l2_cam_factor", factor.toString());
      await saveString("l2_cam_level", difficulty.toString());
      await saveString("l2_cam_difficulty", "1");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JisawHomeCamaraImage(
            factor: factor,
            difficulty: 1,
          ),
        ),
      );
    }

  }

  void _prepareGame(XFile? pickedFile) async {
    pieceOnPool.clear();
    pieceOnBoard.clear();

    setState(() {
      _loaded = false;
    });

    final screenPixelScale = MediaQuery.of(context).devicePixelRatio;
    final imageSize = (300 * screenPixelScale).toInt();

    try {
      if (pickedFile != null) {
        // Get the image bytes
        final imageData = await pickedFile.readAsBytes();

        // Do something with imageData (for example, resize, save, or display it)
        print("Image picked and resized to: $imageSize pixels");

        final image = MemoryImage(imageData, scale: screenPixelScale);
        ui.Image img = await _getImage(image);

        int start = DateTime.now().millisecondsSinceEpoch;
        // var cropped = await cropUiImage(img, imageSize, imageSize);
        // canvasImage = await resizeUiImage(cropped, imageSize, imageSize);
        // int now1 = DateTime.now().millisecondsSinceEpoch;
        // int t1 = now1 - start;

        canvasImage = await cropResizeUiImage(img, imageSize, imageSize);
        int now2 = DateTime.now().millisecondsSinceEpoch;
        // int t2 = now2 - now1;

        // print("T1: $t1 | T2: $t2 | ${(t1-t2)/t1}");


        pieceOnPool = _createJigsawPiece();
        pieceOnPool.shuffle();

        setState(() {
          _loaded = true;
          print('Loading done');
        });

        _startTimer();
      }
    } on PlatformException catch (e) {
      print('Image Pick Exception: $e');
    }
  }

  Future<ui.Image> cropUiImage(ui.Image image, int newWidth, int newHeight) async {
    // Calculate the crop rect
    final double aspectRatio = newWidth / newHeight;
    final double imageAspectRatio = image.width / image.height;

    double cropLeft = 0;
    double cropTop = 0;
    double cropWidth = image.width * 1.0;
    double cropHeight = image.height * 1.0;

    if (imageAspectRatio > aspectRatio) {
      // Image is wider than the new aspect ratio, crop from left and right
      cropWidth = image.height * aspectRatio;
      cropLeft = (image.width - cropWidth) / 2;
    }
    else {
      // Image is taller than the new aspect ratio, crop from top and bottom
      cropHeight = image.width / aspectRatio;
      cropTop = (image.height - cropHeight) / 2;
    }

    // Convert the ui.Image to a ByteData object
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List uint8list = byteData!.buffer.asUint8List();

    final img.Image decodedImage = img.decodeImage(uint8list)!;

    final img.Image croppedImage = img.copyCrop(
      decodedImage,
      x: (cropLeft).round(),
      y: (cropTop).round(),
      width: (cropWidth).round(),
      height: (cropHeight).round(),
    );

    final Uint8List croppedBytes = img.encodePng(croppedImage);

    final ui.Codec codec = await ui.instantiateImageCodec(croppedBytes);

    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image> cropResizeUiImage(ui.Image image, int newWidth, int newHeight) async {
    // Calculate the crop rect
    final double aspectRatio = newWidth / newHeight;
    final double imageAspectRatio = image.width / image.height;

    double cropLeft = 0;
    double cropTop = 0;
    double cropWidth = image.width * 1.0;
    double cropHeight = image.height * 1.0;

    if (imageAspectRatio > aspectRatio) {
      cropWidth = image.height * aspectRatio;
      cropLeft = (image.width - cropWidth) / 2;
    }
    else {

      cropHeight = image.width / aspectRatio;
      cropTop = (image.height - cropHeight) / 2;
    }

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List uint8list = byteData!.buffer.asUint8List();
    img.Image decodedImage = img.decodeImage(uint8list)!;

    img.Image croppedImage = img.copyCrop(
      decodedImage,
      x: (cropLeft).round(),
      y: (cropTop).round(),
      width: (cropWidth).round(),
      height: (cropHeight).round(),
    );

    croppedImage = img.copyResize(decodedImage, height: newHeight, width: newWidth);
    final Uint8List croppedBytes = img.encodePng(croppedImage);

    final ui.Codec codec = await ui.instantiateImageCodec(croppedBytes);

    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
  Future<ui.Image> cropResizeCompressUiImage(ui.Image image, int newWidth, int newHeight) async {
    // Calculate the crop rect
    final double aspectRatio = newWidth / newHeight;
    final double imageAspectRatio = image.width / image.height;

    double cropLeft = 0;
    double cropTop = 0;
    double cropWidth = image.width * 1.0;
    double cropHeight = image.height * 1.0;

    if (imageAspectRatio > aspectRatio) {
      cropWidth = image.height * aspectRatio;
      cropLeft = (image.width - cropWidth) / 2;
    }
    else {

      cropHeight = image.width / aspectRatio;
      cropTop = (image.height - cropHeight) / 2;
    }

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8list = byteData!.buffer.asUint8List();

    final img.Image decodedImage = img.decodeImage(uint8list)!;

    img.Image croppedImage = img.copyCrop(
      decodedImage,
      x: (cropLeft).round(),
      y: (cropTop).round(),
      width: (cropWidth).round(),
      height: (cropHeight).round(),
    );

    croppedImage = img.copyResize(decodedImage, height: newHeight, width: newWidth);
    final Uint8List croppedBytes = img.encodePng(croppedImage);

    final ui.Codec codec = await ui.instantiateImageCodec(croppedBytes);

    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image> resizeUiImage(ui.Image image, int height, int width) async {
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List uint8list = byteData!.buffer.asUint8List();
    final img.Image decodedImage = img.decodeImage(uint8list)!;
    final img.Image resizedImage = img.copyResize(decodedImage, height: height, width: width);
    final Uint8List resizedBytes = img.encodePng(resizedImage);
    final ui.Codec codec = await ui.instantiateImageCodec(resizedBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade700,
          appBar: AppBar(
            title: Text('Puzzle Screen'),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  //_prepareGame();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PuzzleLevelsScreen(demo: true,)),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
          body: _loaded
              ? Column(
            children: [
              Container(
                height: 400,
                alignment: Alignment.center,
                child: _buildBoard(),
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
            ],
          )
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (canvasImage != null) {
                _showFullImageDialog(context);
                setState(() {
                  hintUsed++;
                });
              }
            },
            child: Icon(Icons.image),
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

  Widget _buildBoard() {
    return Container(
      key: _boardWidgetKey,
      width: 300,
      height: 300,
      color: Colors.grey.shade800,
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
    );
  }

  int random_length(){
    return Random().nextInt(5) > 2 ? 2 : 1;
  }



  List<JigsawPiece> _createJigsawPiece() {
/*    int factor = widget.factor + 1;

    List<JigsawPiece> pieces = [];

    List<List<int>> used = [];

    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {

        bool found = false;
        for (List<int> use in used){
          if ( x==use[0] && y == use[1]) found = true;
        }

        if(found) continue;

        int lx = 1;
        int ly = 1;

        if (y < (factor - 1)){
          ly = random_length();
        }
        if (x < (factor - 1)) {
          lx = random_length();
        }
        if (lx > 1){
          used.add([x + 1, y]);
          if (ly > 1){
            used.add([x + 1, y + 1]);
            used.add([x, y + 1]);
          }
        }else if (ly > 1){
          used.add([x, y + 1]);
        }


        pieces.add(JigsawPiece(
          key: UniqueKey(),
          image: canvasImage,
          imageSize: Size(300, 300),
          points: [
            Offset((x / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, ((y + ly) / factor) * 300),
            Offset((x / factor) * 300, ((y + ly) / factor) * 300),
          ],
        ));

        // if (ly > 1) y++;
      }
    }

    return pieces;*/

    int factor = widget.factor + 1;

    List<Piece> pieces_ = [];
    List<Piece> all = [];
    List<JigsawPiece> pieces = [];
    List<List<int>> used = [];

    /*    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {

        bool found = false;
        for (List<int> use in used){
          if ( x==use[0] && y == use[1]) found = true;
        }

        if(found) continue;

        int lx = 1;
        int ly = 1;

        if (y < (factor - 1)){
          ly = random_length();
        }
        if (x < (factor - 1)) {
          lx = random_length();
        }

        if (lx == 2){
          used.add([x + 1, y]);
          if (ly == 2){
            used.add([x + 1, y + 1]);
            used.add([x, y + 1]);
          }
        }else if (ly == 2){
          used.add([x, y + 1]);
        }


        pieces.add(JigsawPiece(
          key: UniqueKey(),
          image: canvasImage,
          imageSize: Size(300, 300),
          points: [
            Offset((x / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, ((y + ly) / factor) * 300),
            Offset((x / factor) * 300, ((y + ly) / factor) * 300),
          ],
        ));

      }
    }*/

    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {

        int x2 = x + ((x < (factor -1)) ? random_length() : 1);
        int y2 = y + ((y < (factor -1)) ? random_length() : 1);

        var p = Piece(x, x2, y, y2);

        bool issue = false;
        for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        if(issue){
          issue = false;
          x2 = x + 1;
          p = Piece(x, x2, y, y2);
          for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        }

        if(issue){
          issue = false;
          y2 = y + 1;
          p = Piece(x, x2, y, y2);
          for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        }

        if(issue) continue;

        pieces_.add(p);
        all.addAll(p.sub_pieces());
      }
    }

    print("Pieces: ${pieces_.length}");
    int area = 0;
    for (var piece in pieces_){
      area += piece.area();

      pieces.add(JigsawPiece(
        key: UniqueKey(),
        image: canvasImage,
        imageSize: Size(300, 300),
        points: [
          Offset((piece.x1 / factor) * 300, (piece.y1 / factor) * 300),
          Offset((piece.x2 / factor) * 300, (piece.y1 / factor) * 300),
          Offset((piece.x2 / factor) * 300, (piece.y2 / factor) * 300),
          Offset((piece.x1 / factor) * 300, (piece.y2 / factor) * 300),
        ],
      ));
    }
    print("Area: $area");
    return pieces;
  }


  void _onPiecePlaced(JigsawPiece piece, Offset pieceDropPosition) {
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
        _movesMade++; // Increment correct moves
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
            _calculateScore(); // Calculate score when the puzzle is complete
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

  void _showCompletionDialog(BuildContext context) {
    final incorrectMoves = _totalMoves - _movesMade;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title:
            Text('Congratulations!', style: TextStyle(color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You have completed the puzzle!',
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),
                Text('Time Taken: $_timeElapsed seconds',
                    style: TextStyle(color: Colors.black)),
                Text('Correct Moves: $_movesMade',
                    style: TextStyle(color: Colors.black)),
                Text('Wrong Moves: $incorrectMoves',
                    style: TextStyle(color: Colors.black)),
                Text('Score: $_score/100',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await MongoDatabase.insertData(
                    difficultyLevel: dificulityLevel,
                    timeElapsed: _timeElapsed,
                    movesMade: _movesMade,
                    incorrectMoves: incorrectMoves,
                    hintUsed: hintUsed,
                    score: _score,
                  );
                  await _adjestDifficulity(_movesMade, incorrectMoves);
                },
                child: Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showFullImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Complete Image',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canvasImage != null)
                SizedBox(
                  height: 300,
                  child: RawImage(
                    image: canvasImage,
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 16),
              Text('Time Taken: $_timeElapsed seconds',
                  style: TextStyle(color: Colors.black)),
              Text('Moves Made: $_movesMade',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
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


class JigsawHomePage extends StatefulWidget {
  final int factor;
  final int difficulty;

  // Constructor to initialize the parameters
  JigsawHomePage({
    required this.factor,
    required this.difficulty,
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

  Timer? _timer;

  int hintUsed = 0;

  @override
  void initState() {
    _animController = AnimationController(vsync: this);
    super.initState();
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

  Future<void> _adjestDifficulity(int correctM, int wrongM) async {

    final response = await http.post(
      Uri.parse('$ML_API/adjust-difficulty'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "correct_moves": correctM,
        "wrong_moves": wrongM,
        "current_split_count": correctM,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      String difficulty = responseData['difficulty'];
      setState(() {
        dificulityLevel = difficulty;
        isLoading = false;
      });

      int factor = responseData['new_split_count'];


      await saveString("l2_gen_factor", factor.toString());
      await saveString("l2_gen_level", difficulty.toString());
      await saveString("l2_gen_difficulty", "1");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JigsawHomePage(
            factor: responseData['new_split_count'],
            difficulty: 1,
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

    final screenPixelScale = MediaQuery.of(context).devicePixelRatio;
    final imageSize = (300 * screenPixelScale).toInt();
    final response = await http.post(
      Uri.parse('https://api.dezgo.com/text2image/'),
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'X-Dezgo-Key': 'DEZGO-9F9A8CB100D69E6884C9A7F907306607D71183DD121B7A083AF9E003CBD4AB5F8DCEA4A1', // Replace with your actual API key
      },
      body: {
        'prompt': ' Lively cartoon-style outdoor playground scene with children aged 10 to 13 playing together. Vibrant, colorful slides, swings, and climbing structures surrounded by lush green trees. Children smiling and enjoying different activities like swinging, sliding, and playing games. Bright, cheerful colors and a playful art style to kids.', // Replace with the text you want to convert to an image
        'height': imageSize.toString(), // Replace with the desired height of the image
        'width': imageSize.toString(), // Replace with the desired width of the image
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade700,
          appBar: AppBar(
            title: Text('Puzzle Screen'),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  //_prepareGame();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PuzzleLevelsScreen(demo: true)),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
          body: _loaded
              ? Column(
            children: [
              Container(
                height: 400,
                alignment: Alignment.center,
                child: _buildBoard(),
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
            ],
          )
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (canvasImage != null) {
                _showFullImageDialog(context);
                setState(() {
                  hintUsed++;
                });
              }
            },
            child: Icon(Icons.image),
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

  int random_length(){
    return Random().nextInt(5) > 2 ? 2 : 1;
  }

  Widget _buildBoard() {
    return Container(
      key: _boardWidgetKey,
      width: 300,
      height: 300,
      color: Colors.grey.shade800,
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
    );
  }

  List<JigsawPiece> _createJigsawPiece() {
    int factor = widget.factor + 1;

    List<Piece> pieces_ = [];
    List<Piece> all = [];
    List<JigsawPiece> pieces = [];
    List<List<int>> used = [];

    /*    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {

        bool found = false;
        for (List<int> use in used){
          if ( x==use[0] && y == use[1]) found = true;
        }

        if(found) continue;

        int lx = 1;
        int ly = 1;

        if (y < (factor - 1)){
          ly = random_length();
        }
        if (x < (factor - 1)) {
          lx = random_length();
        }

        if (lx == 2){
          used.add([x + 1, y]);
          if (ly == 2){
            used.add([x + 1, y + 1]);
            used.add([x, y + 1]);
          }
        }else if (ly == 2){
          used.add([x, y + 1]);
        }


        pieces.add(JigsawPiece(
          key: UniqueKey(),
          image: canvasImage,
          imageSize: Size(300, 300),
          points: [
            Offset((x / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, (y / factor) * 300),
            Offset(((x + lx) / factor) * 300, ((y + ly) / factor) * 300),
            Offset((x / factor) * 300, ((y + ly) / factor) * 300),
          ],
        ));

      }
    }*/

    for (int x = 0; x < factor; x++) {
      for (int y = 0; y < factor; y++) {

        int x2 = x + ((x < (factor -1)) ? random_length() : 1);
        int y2 = y + ((y < (factor -1)) ? random_length() : 1);

        var p = Piece(x, x2, y, y2);

        bool issue = false;
        for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        if(issue){
          issue = false;
          x2 = x + 1;
          p = Piece(x, x2, y, y2);
          for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        }

        if(issue){
          issue = false;
          y2 = y + 1;
          p = Piece(x, x2, y, y2);
          for(var b in p.sub_pieces()){if (all.contains(b)) issue = true;}
        }

        if(issue) continue;

        pieces_.add(p);
        all.addAll(p.sub_pieces());
      }
    }

    print("Pieces: ${pieces_.length}");
    int area = 0;
    for (var piece in pieces_){
      area += piece.area();

      pieces.add(JigsawPiece(
        key: UniqueKey(),
        image: canvasImage,
        imageSize: Size(300, 300),
        points: [
          Offset((piece.x1 / factor) * 300, (piece.y1 / factor) * 300),
          Offset((piece.x2 / factor) * 300, (piece.y1 / factor) * 300),
          Offset((piece.x2 / factor) * 300, (piece.y2 / factor) * 300),
          Offset((piece.x1 / factor) * 300, (piece.y2 / factor) * 300),
        ],
      ));
    }
    print("Area: $area");
    return pieces;
  }

  void _onPiecePlaced(JigsawPiece piece, Offset pieceDropPosition) {
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
        _movesMade++; // Increment correct moves
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
            _calculateScore(); // Calculate score when the puzzle is complete
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

  void _showCompletionDialog(BuildContext context) {
    final incorrectMoves = _totalMoves - _movesMade;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title:
            Text('Congratulations!', style: TextStyle(color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You have completed the puzzle!',
                    style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),
                Text('Time Taken: $_timeElapsed seconds',
                    style: TextStyle(color: Colors.black)),
                Text('Correct Moves: $_movesMade',
                    style: TextStyle(color: Colors.black)),
                Text('Wrong Moves: $incorrectMoves',
                    style: TextStyle(color: Colors.black)),
                Text('Score: $_score/100',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await MongoDatabase.insertData(
                    difficultyLevel: dificulityLevel,
                    timeElapsed: _timeElapsed,
                    movesMade: _movesMade,
                    incorrectMoves: incorrectMoves,
                    hintUsed: hintUsed,
                    score: _score,
                  );
                  await _adjestDifficulity(_movesMade, incorrectMoves);
                },
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showFullImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Complete Image',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canvasImage != null)
                SizedBox(
                  height: 300,
                  child: RawImage(image: canvasImage),
                ),
              SizedBox(height: 16),
              Text('Time Taken: $_timeElapsed seconds',
                  style: TextStyle(color: Colors.black)),
              Text('Moves Made: $_movesMade',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class Piece{
  final int x1, x2, y1, y2;
  Piece(this.x1, this.x2, this.y1, this.y2);

  int area(){
    return (x2 - x1) * (y2 - y1);
  }

  List<Piece> sub_pieces(){
    List<Piece> a = [];
    for(int x = x1; x < x2; x++){
      for(int y = y1; y < y2; y++){
        a.add(Piece(x, x + 1, y, y + 1));
      }
    }

    return a;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece &&
          runtimeType == other.runtimeType &&
          x1 == other.x1 &&
          x2 == other.x2 &&
          y1 == other.y1 &&
          y2 == other.y2;

  @override
  int get hashCode => x1.hashCode ^ x2.hashCode ^ y1.hashCode ^ y2.hashCode;
}


