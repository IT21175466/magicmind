import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';

class DifficultyChart extends StatelessWidget {
  final List<PuzzleResult> activities;

  DifficultyChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    Map<String, int> difficultyCounts = {
      "Low": 0,
      "Medium": 0,
      "Hard": 0,
    };

    for (var activity in activities) {
      difficultyCounts[activity.difficultyLevel] =
          (difficultyCounts[activity.difficultyLevel] ?? 0) + 1;
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: PieChart(
          PieChartData(
            sections: difficultyCounts.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value.toDouble(),
                title: entry.key,
                color: entry.key == "Low"
                    ? Colors.green
                    : entry.key == "Medium"
                        ? Colors.blue
                        : Colors.red,
                radius: 50,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
