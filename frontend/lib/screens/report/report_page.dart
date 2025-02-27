import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';

class ReportPage extends StatelessWidget {
  final List<PuzzleResult> activities;

  ReportPage({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Report'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Last ${activities.length} Activities:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Level: ${activity.level}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Score: ${activity.score}'),
                        Text('Incorrect Moves: ${activity.incorrectMoves}'),
                        Text('Hints Used: ${activity.hintsUsed}'),
                        Text('Time Taken: ${activity.timeTaken}'),
                        Text('Difficulty: ${activity.difficultyLevel}'),
                        Text(
                          'Date: ${DateFormat.yMMMd().format(activity.date)}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Here you can trigger actions to download or show more detailed analysis
              },
              child: Text('Download PDF Report'),
            ),
          ),
        ],
      ),
    );
  }
}
