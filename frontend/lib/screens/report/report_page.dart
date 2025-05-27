import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merged_app/models/puzzle_result_model.dart';
import 'package:merged_app/screens/report/dificulity_chart.dart';
import 'package:merged_app/screens/report/mistaks_chart.dart';
import 'package:merged_app/screens/report/score_chart.dart';
import 'package:merged_app/services/mongodb.dart';
import 'package:merged_app/services/shared_prefs_service.dart';
 
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;

class ReportPage extends StatefulWidget {
  const ReportPage();

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<PuzzleResult> activities = [];

  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    fetchPuzzleResults();
  }

  void fetchPuzzleResults() async {
    final uid = await SharedPrefs.getUserId();
    List<PuzzleResult> results = await MongoDatabase.getData(uid.toString());

    activities.clear();
    activities.addAll(results.take(5)); // Take only the last 5 records

    setState(() {
      isLoading = false;
    });
  }

  Future<Uint8List> _captureChart(GlobalKey key) async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Ensure rendering is done

    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception("Chart is not available yet!");
    }

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  final GlobalKey scoreChartKey = GlobalKey();
  final GlobalKey mistakesChartKey = GlobalKey();
  final GlobalKey difficultyChartKey = GlobalKey();

  Future<void> generatePdfReport() async {
    final pdf = pw.Document();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final Uint8List scoreChartImage = await _captureChart(scoreChartKey);
        final Uint8List mistakesChartImage =
            await _captureChart(mistakesChartKey);
        final Uint8List difficultyChartImage =
            await _captureChart(difficultyChartKey);

        pdf.addPage(
          pw.MultiPage(
            build: (pw.Context context) => [
              pw.Center(
                child: pw.Text('MagicMind Puzzle - Student Performance Report',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Last 5 Session Records:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              for (var activity in activities)
                pw.Text(
                    'Session ${activities.indexOf(activity) + 1}: Score - ${activity.score}, Incorrect Moves: ${activity.incorrectMoves}, Hints Used: ${activity.hintsUsed}'),
              pw.SizedBox(height: 10),
              pw.Text('Performance Analysis:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(analyzePerformance(activities)["message"]),
              pw.SizedBox(height: 20),
              pw.Text('Performance Charts:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Score Progression',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'This chart tracks the student’s score improvement over multiple sessions. A rising trend indicates progress.'),
              pw.SizedBox(height: 5),
              pw.Image(pw.MemoryImage(scoreChartImage)),
              pw.SizedBox(height: 10),
              pw.Text('Mistakes & Hint Usage',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'This chart displays the number of incorrect moves and hints used per session. Fewer mistakes and hints indicate better problem-solving skills.'),
              pw.SizedBox(height: 5),
              pw.Image(pw.MemoryImage(mistakesChartImage)),
              pw.SizedBox(height: 10),
              pw.Text('Difficulty Level Distribution',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'This chart shows how much time was spent in Low, Medium, and Hard difficulty levels. More time in higher difficulty suggests improvement.'),
              pw.SizedBox(height: 5),
              pw.Image(pw.MemoryImage(difficultyChartImage)),
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
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> performance = analyzePerformance(activities);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Student Performance Report',
          style: TextStyle(
            fontFamily: 'ABeeZee',
            fontSize: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Generating Report...",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: 'Andika',
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  _performanceInsights(performance),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Summary of Last 5 Records:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Andika',
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ListTile(
                        title: Text(
                          "Session ${index + 1}: Score - ${activity.score}",
                          style: TextStyle(
                            fontFamily: 'Andika',
                          ),
                        ),
                        subtitle: Text(
                          "Incorrect Moves: ${activity.incorrectMoves}, Hints Used: ${activity.hintsUsed}, Difficulty: ${activity.difficultyLevel}",
                          style: TextStyle(
                            fontFamily: 'Andika',
                          ),
                        ),
                      );
                    },
                  ),
                  _chartSection(
                    context,
                    "Score Progression",
                    "Tracks the student's score improvement over the last 5 sessions. A rising trend indicates progress.",
                    RepaintBoundary(
                        key: scoreChartKey,
                        child: ScoreChart(activities: activities)),
                  ),
                  _chartSection(
                    context,
                    "Mistakes & Hint Usage",
                    "Shows the number of incorrect moves and hints used per session. Fewer mistakes and hints indicate better problem-solving skills.",
                    RepaintBoundary(
                        key: mistakesChartKey,
                        child: MistakesChart(activities: activities)),
                  ),
                  _chartSection(
                    context,
                    "Difficulty Level Distribution",
                    "Displays how much time was spent in Low, Medium, and Hard difficulty over the last 5 sessions. More time in higher difficulty suggests improvement.",
                    RepaintBoundary(
                        key: difficultyChartKey,
                        child: DifficultyChart(activities: activities)),
                  ),
                  Container(
                    width: screenWidth / 3 * 2,
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        generatePdfReport();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Download Report',
                            style: TextStyle(
                              fontFamily: 'Andika',
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.download),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _chartSection(BuildContext context, String title, String description,
      Widget chartWidget) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Andika',
                  ),
                ),
              ),
              SizedBox(width: 5),
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _showInfoDialog(context, title, description);
                },
              ),
            ],
          ),
          chartWidget,
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Andika',
          ),
        ),
        content: Text(
          description,
          style: TextStyle(
            fontFamily: 'Andika',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Andika',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _performanceInsights(Map<String, dynamic> performance) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overall Performance: ${performance["status"]}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Andika',
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              performance["message"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Andika',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
