import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicmind_puzzle/models/preposition.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';
import 'package:magicmind_puzzle/navigations/vocabulary_list_screen.dart';
import 'package:magicmind_puzzle/preposition_feature/preposition_main.dart';
import 'package:magicmind_puzzle/screens/auth/login_page.dart';
import 'package:magicmind_puzzle/screens/puzzle/puzzle_levels_screen.dart';
import 'package:magicmind_puzzle/services/auth_service.dart';
import 'package:magicmind_puzzle/services/mongodb.dart';
import 'package:magicmind_puzzle/services/shared_prefs_service.dart';
import 'package:magicmind_puzzle/utils/function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> logout(BuildContext context) async {
    await SharedPrefs.clear();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginPage()), (predicate) => false);
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Andika',
          ),
        ),
      ),
    );
  }

  Future<void> loadUserName() async {
    final userId = await SharedPrefs.getUserId();
    if (userId != null) {
      final name = await MongoService.getUserName(userId);
      setState(() {
        userName = name ?? 'Friend';
        isLoadingName = false;
      });
    }
  }

  String? userName;

  bool isLoadingPDF = false;
  bool isLoadingName = true;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoadingName
          ? Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/reg_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading....",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/reg_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Home Banner
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "👋 Hello, ${userName ?? 'Friend'}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Ready to play and learn?",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                logout(context);
                              },
                              icon: Icon(Icons.exit_to_app,
                                  size: 30, color: Colors.white),
                              tooltip: "Logout",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Spacer(),
                  buildButton("🧩   Puzzle Game", Colors.purple, () async {
                    bool demo = await loadString("demo", "no") != "no";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => PuzzleLevelsScreen(
                          demo: demo,
                        ),
                      ),
                    );
                  }),
                  buildButton("🎤   Preposition Game", Colors.brown, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => PrepositionHome(),
                      ),
                    );
                  }),
                  buildButton("📝  Vocabulary", Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => VocabularyLevelsScreen(),
                      ),
                    );
                    //
                  }),
                  //buildButton("🌍   Explore World", Colors.teal, () {}),
                  Spacer(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            isLoadingPDF = true;
          });
          await getPrepositionData();
          await fetchPuzzleResults();
          await generatePdfReport();
        },
        label: isLoadingPDF
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Icon(Icons.document_scanner),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Overall Report",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> getPrepositionData() async {
    List<PrepositionData> preResults = await MongoDatabase.getPrepositionData();

    prepositionActivities.clear();
    prepositionActivities.addAll(preResults.take(5));
  }

  Map<String, dynamic> analyzePerformance(List<PuzzleResult> activities) {
    if (activities.length < 2) {
      return {"status": "Not enough data", "message": "Play more sessions"};
    }

    List<PuzzleResult> lastFiveActivities = activities.take(5).toList();
    int scoreImprovement =
        lastFiveActivities.last.score - lastFiveActivities.first.score;
    int incorrectMovesChange = lastFiveActivities.last.incorrectMoves -
        lastFiveActivities.first.incorrectMoves;
    int hintUsageChange =
        lastFiveActivities.last.hintsUsed - lastFiveActivities.first.hintsUsed;

    if (scoreImprovement > 5 &&
        incorrectMovesChange < 0 &&
        hintUsageChange <= 0) {
      return {
        "status": "Improving",
        "message": "The student is learning well."
      };
    } else if (scoreImprovement < -5 ||
        incorrectMovesChange > 2 ||
        hintUsageChange > 1) {
      return {
        "status": "Struggling",
        "message": "The student may be facing difficulties."
      };
    }

    return {"status": "Neutral", "message": "No major changes in performance."};
  }

  List<PuzzleResult> activities = [];
  List<PrepositionData> prepositionActivities = [];

  Future<void> fetchPuzzleResults() async {
    final uid = await SharedPrefs.getUserId();
    List<PuzzleResult> results = await MongoDatabase.getData(uid.toString());

    activities.clear();
    activities.addAll(results.take(5));
  }

  Future<void> generatePdfReport() async {
    final pdf = pw.Document();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        pdf.addPage(
          pw.MultiPage(
            build: (pw.Context context) => [
              pw.Center(
                child: pw.Text('MagicMind Puzzle - Student Performance Report',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Puzzle Results Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Last 5 Session Records:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              for (var activity in activities)
                pw.Text(
                    'Session ${activities.indexOf(activity) + 1}: Score - ${activity.score}, Incorrect Moves: ${activity.incorrectMoves}, Hints Used: ${activity.hintsUsed}'),
              pw.SizedBox(height: 10),
              //
              pw.Divider(),
              pw.Text('Preposition Results Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Last 5 Session Records:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              for (var activity in prepositionActivities)
                pw.Text(
                    'Score - ${activity.score}, Status: ${activity.status}, Level: ${activity.level}, Time Spent: ${activity.timeSpent}'),
              pw.SizedBox(height: 10),
              pw.Text('Performance Analysis:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Powered by MagicMind',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey,
                  ),
                ),
              ),
              // pw.Text('Performance Analysis:',
              //     style: pw.TextStyle(
              //         fontSize: 18, fontWeight: pw.FontWeight.bold)),
              // pw.Text(analyzePerformance(activities)["message"]),
              // pw.SizedBox(height: 20),
              // pw.Text('Performance Charts:',
              //     style: pw.TextStyle(
              //         fontSize: 18, fontWeight: pw.FontWeight.bold)),
              // pw.SizedBox(height: 10),
              // pw.Text('Score Progression',
              //     style: pw.TextStyle(
              //         fontSize: 16, fontWeight: pw.FontWeight.bold)),
              // pw.Text(
              //     'This chart tracks the student’s score improvement over multiple sessions. A rising trend indicates progress.'),
              // pw.SizedBox(height: 5),
              // pw.Image(pw.MemoryImage(scoreChartImage)),
              // pw.SizedBox(height: 10),
              // pw.Text('Mistakes & Hint Usage',
              //     style: pw.TextStyle(
              //         fontSize: 16, fontWeight: pw.FontWeight.bold)),
              // pw.Text(
              //     'This chart displays the number of incorrect moves and hints used per session. Fewer mistakes and hints indicate better problem-solving skills.'),
              // pw.SizedBox(height: 5),
              // pw.Image(pw.MemoryImage(mistakesChartImage)),
              // pw.SizedBox(height: 10),
              // pw.Text('Difficulty Level Distribution',
              //     style: pw.TextStyle(
              //         fontSize: 16, fontWeight: pw.FontWeight.bold)),
              // pw.Text(
              //     'This chart shows how much time was spent in Low, Medium, and Hard difficulty levels. More time in higher difficulty suggests improvement.'),
              // pw.SizedBox(height: 5),
              // pw.Image(pw.MemoryImage(difficultyChartImage)),
              // pw.SizedBox(height: 20),
              pw.Divider(),
            ],
          ),
        );

        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/performance_report.pdf");
        await file.writeAsBytes(await pdf.save());

        // Open the PDF after saving
        await Printing.sharePdf(
            bytes: await pdf.save(), filename: 'performance_report.pdf');
      } catch (e) {
        print("Error capturing charts: $e");
      }
    });

    setState(() {
      isLoadingPDF = false;
    });
  }
}
