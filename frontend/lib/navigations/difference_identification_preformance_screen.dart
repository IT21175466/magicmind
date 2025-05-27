import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:merged_app/constants/env.dart';
import 'package:merged_app/navigations/accuracy_chart.dart';
import 'package:merged_app/navigations/difference_difficulty_chart.dart';
import 'package:merged_app/navigations/difference_mistakes_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class DifferenceIdentificationReportPage extends StatefulWidget {
  const DifferenceIdentificationReportPage();

  @override
  State<DifferenceIdentificationReportPage> createState() =>
      _DifferenceIdentificationReportPageState();
}

class _DifferenceIdentificationReportPageState
    extends State<DifferenceIdentificationReportPage> {
  List<Map<String, dynamic>> activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDifferenceIdentificationResults();
  }

  Future<void> fetchDifferenceIdentificationResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('authEmployeeID') ?? "sampleUser";

    final response = await http.get(
      Uri.parse(ENVConfig.serverUrl +
          '/difference-identifications/user/$username'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      List<Map<String, dynamic>> mappedData = data.map<Map<String, dynamic>>((record) {
        int difficulty = record['difficulty'];
        String difficultyLevel;
        if (difficulty == 1) {
          difficultyLevel = "Low";
        } else if (difficulty >= 2 && difficulty <= 3) {
          difficultyLevel = "Medium";
        } else {
          difficultyLevel = "Hard";
        }

        double accuracy = record['accuracy'].toDouble();
        double mistakes = (100 - accuracy) / 10;

        DateTime recordedDate = DateTime.parse(record['recorded_date'].toString());

        return {
          'recorded_date': recordedDate.toIso8601String(),
          'accuracy': accuracy,
          'mistakes': mistakes,
          'difficultyLevel': difficultyLevel,
        };
      }).toList();

      setState(() {
        activities = mappedData.take(5).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load performance records')),
      );
    }
  }

  Map<String, dynamic> analyzePerformance(List<Map<String, dynamic>> activities) {
    if (activities.length < 2) {
      return {"status": "Not enough data", "message": "Play more sessions to see your progress!"};
    }

    List<Map<String, dynamic>> lastFiveActivities = activities.take(5).toList();
    double accuracyImprovement = lastFiveActivities.last['accuracy'] -
        lastFiveActivities.first['accuracy'];
    double mistakesChange = lastFiveActivities.last['mistakes'] -
        lastFiveActivities.first['mistakes'];

    if (accuracyImprovement > 5 && mistakesChange <= 0) {
      return {
        "status": "Improving",
        "message": "Great job! You're performing well and making fewer mistakes. Keep it up!"
      };
    } else if (accuracyImprovement < -5 || mistakesChange > 2) {
      return {
        "status": "Struggling",
        "message": "It looks like you might need some extra practice. Try focusing on medium difficulty levels to improve."
      };
    }

    return {
      "status": "Neutral",
      "message": "Your performance is stable. Try challenging yourself with a higher difficulty to see more progress!"
    };
  }

  Future<Uint8List> _captureChart(GlobalKey key) async {
    await Future.delayed(Duration(milliseconds: 500));

    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception("Chart is not available yet!");
    }

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  final GlobalKey accuracyChartKey = GlobalKey();
  final GlobalKey mistakesChartKey = GlobalKey();
  final GlobalKey difficultyChartKey = GlobalKey();

  Future<void> generatePdfReport() async {
    final pdf = pw.Document();

    // Pre-capture charts
    Uint8List? accuracyChartImage;
    Uint8List? mistakesChartImage;
    Uint8List? difficultyChartImage;

    try {
      accuracyChartImage = await _captureChart(accuracyChartKey);
      mistakesChartImage = await _captureChart(mistakesChartKey);
      difficultyChartImage = await _captureChart(difficultyChartKey);
    } catch (e) {
      print("Error capturing charts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture charts: $e')),
      );
      return;
    }

    // Cover page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'MagicMind',
                style: pw.TextStyle(
                  fontSize: 40,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Difference Identification Performance Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on May 26, 2025, 05:15 AM +0530',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Main report content
    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: pw.EdgeInsets.only(bottom: 10),
          child: pw.Text(
            'MagicMind Difference Identification Report',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount} | Powered by MagicMind',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey,
            ),
          ),
        ),
        build: (pw.Context context) => [
          pw.Text(
            'Performance Summary',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Last ${activities.length} Session Records:',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          for (var activity in activities)
            pw.Bullet(
              text:
                  'Session ${activities.indexOf(activity) + 1}: Accuracy - ${activity['accuracy'].toStringAsFixed(1)}%, '
                  'Mistakes: ${activity['mistakes'].toStringAsFixed(1)}, '
                  'Difficulty: ${activity['difficultyLevel']}, '
                  'Date: ${DateFormat('MMM dd, yyyy HH:mm:ss').format(DateTime.parse(activity['recorded_date']))}',
            ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Performance Analysis:',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(analyzePerformance(activities)["message"]),
          pw.SizedBox(height: 20),
          pw.Text(
            'Performance Charts',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Accuracy Progression',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'This chart tracks your accuracy improvement over multiple sessions. A rising trend indicates progress.',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          if (accuracyChartImage != null)
            pw.Image(pw.MemoryImage(accuracyChartImage)),
          pw.SizedBox(height: 10),
          pw.Text(
            'Mistakes Per Session',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'This chart displays the number of mistakes per session. Fewer mistakes indicate better performance.',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          if (mistakesChartImage != null)
            pw.Image(pw.MemoryImage(mistakesChartImage)),
          pw.SizedBox(height: 10),
          pw.Text(
            'Difficulty Level Distribution',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'This chart shows how much time was spent in Low, Medium, and Hard difficulty levels.',
            style: pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          if (difficultyChartImage != null)
            pw.Image(pw.MemoryImage(difficultyChartImage)),
          pw.SizedBox(height: 20),
          pw.Text(
            'Next Steps',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(getNextSteps()),
          pw.SizedBox(height: 20),
          pw.Text(
            'Keep up the great work! "Success is the sum of small efforts, repeated day in and day out." - Robert Collier',
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/difference_identification_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'difference_identification_report.pdf',
    );
  }

  String getNextSteps() {
    var performance = analyzePerformance(activities);
    switch (performance["status"]) {
      case "Improving":
        return "You're on a roll! Try increasing the difficulty to challenge yourself further.";
      case "Struggling":
        return "Consider practicing with medium difficulty levels to build confidence and reduce mistakes.";
      case "Neutral":
        return "Your performance is steady. Experiment with higher difficulty levels to push your skills.";
      default:
        return "Complete more sessions to get personalized recommendations.";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Generating Your Report...",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 0, right: 0),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Difference Identification Report',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Detailed Analysis',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        titleSpacing: 0,
                        leading: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Color(0xff80ca84),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orangeAccent.withOpacity(0.6),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.black),
                            onPressed: fetchDifferenceIdentificationResults,
                            tooltip: 'Refresh Report',
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.black),
                            onPressed: generatePdfReport,
                            tooltip: 'Download Report',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              analyzePerformance(activities)['status'] == "Improving"
                                  ? Icons.star
                                  : analyzePerformance(activities)['status'] == "Neutral"
                                      ? Icons.trending_flat
                                      : Icons.warning,
                              color: analyzePerformance(activities)['status'] == "Improving"
                                  ? Colors.green
                                  : analyzePerformance(activities)['status'] == "Neutral"
                                      ? Colors.orange
                                      : Colors.red,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Overall Performance: ${analyzePerformance(activities)['status']}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    analyzePerformance(activities)['message'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Summary of Last ${activities.length} Sessions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: activities.length,
                              itemBuilder: (context, index) {
                                final activity = activities[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue[100],
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  title: Text(
                                    "Accuracy: ${activity['accuracy'].toStringAsFixed(1)}%",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    "Mistakes: ${activity['mistakes'].toStringAsFixed(1)} | Difficulty: ${activity['difficultyLevel']} | Date: ${DateFormat('MMM dd, yyyy HH:mm:ss').format(DateTime.parse(activity['recorded_date']))}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _chartSection(
                      context,
                      "Accuracy Over Time",
                      "Tracks your accuracy improvement over the last ${activities.length} sessions. A rising trend indicates progress.",
                      RepaintBoundary(
                        key: accuracyChartKey,
                        child: AccuracyChart(activities: activities),
                      ),
                    ),
                    _chartSection(
                      context,
                      "Mistakes Over Time",
                      "Shows the number of mistakes per session. Fewer mistakes indicate better performance.",
                      RepaintBoundary(
                        key: mistakesChartKey,
                        child: DifferenceMistakesChart(activities: activities),
                      ),
                    ),
                    _chartSection(
                      context,
                      "Difficulty Distribution",
                      "Displays how much time was spent in Low, Medium, and Hard difficulty over the last ${activities.length} sessions.",
                      RepaintBoundary(
                        key: difficultyChartKey,
                        child: DifferenceDifficultyChart(activities: activities),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Next Steps",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              getNextSteps(),
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _chartSection(BuildContext context, String title, String description,
      Widget chartWidget) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insert_chart, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tooltip(
                  message: description,
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            chartWidget,
          ],
        ),
      ),
    );
  }
}