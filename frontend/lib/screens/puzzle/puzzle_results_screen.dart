import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/screens/home/home_screen.dart';
import 'package:magicmind_puzzle/utils/app_styles.dart';

class PuzzleResultsScreen extends StatefulWidget {
  final int moves;
  final int score;
  final int timeTaken;
  final int difficulty;

  const PuzzleResultsScreen({
    required this.moves,
    required this.score,
    required this.timeTaken,
    required this.difficulty,
    Key? key,
  }) : super(key: key);

  @override
  _PuzzleResultsScreenState createState() => _PuzzleResultsScreenState();
}

class _PuzzleResultsScreenState extends State<PuzzleResultsScreen> {
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Results'),
      ),
      backgroundColor: Styles.secondaryColor,
      // ignore: unnecessary_null_comparison
      body: widget.difficulty == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top card with motivational message
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Great Job!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "You’re improving! Keep solving puzzles to master your skills.",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Implement any action for motivational button, if needed
                          },
                          icon: const Icon(Icons.stars),
                          label: const Text("View Tips to Improve"),
                        ),
                      ],
                    ),
                  ),
                ),

                // Spacer between cards and details
                const SizedBox(height: 16.0),

                // Details section (Score, Time Taken, Moves)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Score: ${widget.score}',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Time Taken: ${formatTime(widget.timeTaken)}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Steps Taken: ${widget.moves}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Feedback card at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.blue.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Share Your Feedback',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => FeedbackScreen(
                              //       user: "sampleUser",
                              //       category: "",
                              //       score: widget.score,
                              //       moves: widget.moves,
                              //       timeTaken: widget.timeTaken,
                              //       difficulty: widget.difficulty,
                              //       madeBy: "",
                              //     ),
                              //   ),
                              // );
                            },
                            child: const Text('Give Feedback'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
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
