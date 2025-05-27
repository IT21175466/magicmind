import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/material.dart';
 
import 'package:merged_app/constants/env.dart';
import 'package:merged_app/models/session_provider.dart';
import 'package:merged_app/navigations/difference_identification_preformance_screen.dart';
import 'package:merged_app/navigations/vocabuloary_performance_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userRole = '';
  String authEmployeeID = '';
  String email = '';
  String fullName = '';
  int changeIdentificationDifficulty = 0;
  int vocabularyDifficulty = 0;
  bool isLoading = true;
  List<dynamic> records = [];
  Map<String, dynamic> comparison = {
    'score_change': 'N/A',
    'score_difference': 0,
    'time_change': 'N/A',
    'time_difference': 0,
    'difficulty_change': 'N/A',
  };


  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _fetchVocabularyRecords();
  }

  Future<void> _loadProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole') ?? '';
      authEmployeeID = prefs.getString('authEmployeeID') ?? '';
      email = prefs.getString('email') ?? '';
      fullName = prefs.getString('full_name') ?? '';
      changeIdentificationDifficulty = prefs.getInt('difference_difficulty') ?? 0;
      vocabularyDifficulty = prefs.getInt('vocabulary_difficulty') ?? 0;
      isLoading = false;
    });
  }

  Widget _buildStars(int score) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        score,
            (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
      ),
    );
  }

  Future<void> _fetchVocabularyRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('authEmployeeID') ?? "sampleUser";

    final response = await http.get(
      Uri.parse(ENVConfig.serverUrl+'/vocabulary-records/user/$username'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        records = data['records']; // Extract the records
        comparison = data['comparison']; // Extract the comparison details
        isLoading = false;
      });
      print(records);

      // if (records.length >= 2) {
      //   var latest = records[records.length - 1];
      //   var previous = records[records.length - 2];
      //
      //   setState(() {
      //     comparison = {
      //       'score_change': latest['score'] > previous['score'] ? "Improved" : "Lacked",
      //       'score_difference': (latest['score'] - previous['score']).abs(),
      //       'time_change': latest['time_taken'] < previous['time_taken'] ? "Faster" : "Slower",
      //       'time_difference': (latest['time_taken'] - previous['time_taken']).abs(),
      //       'difficulty_change': latest['difficulty'] > previous['difficulty'] ? "Increased" : "Decreased",
      //     };
      //   });
      // }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vocabulary records')),
      );
    }
  }

  Future<void> _generateAndShowVocabPDF() async {
    final pdf = pw.Document();

    // Line chart data
    List<FlSpot> scorePoints = [];
    List<FlSpot> difficultyPoints = [];
    for (int i = 0; i < records.length; i++) {
      scorePoints.add(FlSpot(i.toDouble(), records[i]['score'].toDouble()));
      difficultyPoints.add(FlSpot(i.toDouble(), records[i]['difficulty'].toDouble()));
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Profile Details", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text("Full Name: $fullName"),
            pw.Text("Email: $email"),
            pw.Text("Role: $userRole"),
            pw.Text("Change Identification Difficulty: $changeIdentificationDifficulty"),
            pw.Text("Vocabulary Difficulty: $vocabularyDifficulty"),
            pw.SizedBox(height: 16),
            pw.Text("Comparison:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text("Score Change: ${comparison['score_change']} by ${comparison['score_difference']}"),
            pw.Text("Time Taken Change: ${comparison['time_change']} by ${comparison['time_difference']} sec"),
            pw.Text("Difficulty Change: ${comparison['difficulty_change']}"),
            pw.SizedBox(height: 16),
            pw.Text("Previous Records:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            if (records.isNotEmpty) ...[
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Score', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Time Taken', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Difficulty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ]),
                  for (var record in records)
                    pw.TableRow(children: [
                      pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(record['recorded_date'].toString())),
                      pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('${record['score']}%')),
                      pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(record['time_taken'].toString())),
                      pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(record['difficulty'].toString())),
                    ]),
                ],
              ),
            ] else pw.Text("No previous records found."),
          ],
        ),
      ),
    );

    final pdfInMemory = await pdf.save();
    final pdfFile = await _createFileFromBytes(pdfInMemory);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(filePath: pdfFile.path),
      ),
    );
  }

  Future<void> _generateAndShowPDF() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) =>
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Profile Details",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Text("Full Name: $fullName"),
                pw.Text("Email: $email"),
                pw.Text("Role: $userRole"),
                pw.Text(
                    "Change Identification Difficulty: $changeIdentificationDifficulty"),
                pw.Text("Vocabulary Difficulty: $vocabularyDifficulty"),
              ],
            ),
      ),
    );
    final pdfInMemory = await pdf.save();

    // Open the PDF directly from memory
    final result = await _openPDFFromMemory(pdfInMemory);
  }

  Future<void> _openPDFFromMemory(Uint8List pdfInMemory) async {
    final pdfFile = await _createFileFromBytes(pdfInMemory);
    // Use a PDF viewer package like 'flutter_pdfview' to display the PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: pdfFile.path,
        ),
      ),
    );
  }

  Future<File> _createFileFromBytes(Uint8List bytes) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/full_summary_report.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/fb3f8dc3b3e13aebe66e9ae3df8362e9.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: AppBar(
                  backgroundColor: Colors.transparent, // Transparent background
                  elevation: 0, // Remove shadow
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 20, // Main title font size
                          color: Colors.black, // Text color
                        ),
                      ),
                      SizedBox(height: 4), // Space between title and subtitle
                      Text(
                        'Profile details',
                        style: TextStyle(
                          fontSize: 14, // Subtitle font size
                          fontWeight: FontWeight.normal,
                          color: Colors.black, // Text color
                        ),
                      ),
                    ],
                  ),
                  titleSpacing: 0,
                  leading: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Color(0xff80ca84), // Background color for the circle
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.6), // Glow effect
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon
                      onPressed: () {
                        Navigator.pop(context); // Navigate back
                      },
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff80ca84), // Background color for the circle
                        shape: BoxShape.circle, // Circular shape
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orangeAccent.withOpacity(0.6), // Glow effect
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.logout, color: Colors.white), // Logout icon
                        onPressed: () async {
                          Provider.of<SessionProvider>(context, listen: false).clearSession();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('accessToken');
                          await prefs.remove('refreshToken');
                          await prefs.remove('accessTokenExpireDate');
                          await prefs.remove('refreshTokenExpireDate');
                          await prefs.remove('userRole');
                          await prefs.remove('authEmployeeID');
                          await prefs.remove("vocabulary_difficulty");
                          await prefs.remove("difference_difficulty");
                          Navigator.pushReplacementNamed(context, '/landing');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 70,
                backgroundColor: const Color(0xff27a5c6),
                backgroundImage: const AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(height: 10),
              Card(
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 8,
                child: Container(
                  width: double.infinity, // Make the card take the full available width
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align text to the start
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8), // Add some spacing
                      Text(
                        email,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 4), // Add spacing between text items
                      Text(
                        'Role: $userRole',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10,),
                     
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space cards
                  children: [
                     
                    const SizedBox(width: 10), // Space between the cards
                    Expanded(
                      child: Card(
                        color: const Color(0xff27a5c6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Level',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                vocabularyDifficulty.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              _buildStars(vocabularyDifficulty),
                              const SizedBox(height: 16),
                              const Text(
                                'Vocabulary Activity',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              ElevatedButton.icon(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => VocabularyPerformanceScreen()),
                                  );
                                },
                                icon: const Icon(Icons.area_chart),
                                label: const Text("Performance"),
                              ),
                              const SizedBox(height: 8),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
