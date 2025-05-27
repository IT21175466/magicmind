import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DifferenceDifficultyChart extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const DifferenceDifficultyChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    Map<String, int> difficultyCounts = {
      'Low': 0,
      'Medium': 0,
      'Hard': 0,
    };

    for (var activity in activities) {
      String difficulty = activity['difficultyLevel'];
      difficultyCounts[difficulty] = (difficultyCounts[difficulty] ?? 0) + 1;
    }

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
              value: difficultyCounts['Low']!.toDouble(),
              title: 'Low',
              radius: 50,
              titleStyle: TextStyle(fontSize: 14, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.orange,
              value: difficultyCounts['Medium']!.toDouble(),
              title: 'Medium',
              radius: 50,
              titleStyle: TextStyle(fontSize: 14, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: difficultyCounts['Hard']!.toDouble(),
              title: 'Hard',
              radius: 50,
              titleStyle: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}