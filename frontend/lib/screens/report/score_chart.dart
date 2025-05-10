import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';

class ScoreChart extends StatelessWidget {
  final List<PuzzleResult> activities;

  ScoreChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    return index < activities.length
                        ? Text('S${index + 1}', style: TextStyle(fontSize: 12))
                        : Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: activities.asMap().entries.map((entry) {
                  int index = entry.key;
                  PuzzleResult act = entry.value;
                  return FlSpot(index.toDouble(), act.score.toDouble());
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
