import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:magicmind_puzzle/models/puzzle_result_model.dart';

class MistakesChart extends StatelessWidget {
  final List<PuzzleResult> activities;

  MistakesChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
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
            barGroups: activities.asMap().entries.map((entry) {
              int index = entry.key;
              PuzzleResult act = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: act.incorrectMoves.toDouble(),
                    color: Colors.red,
                    width: 12,
                  ),
                  BarChartRodData(
                    toY: act.hintsUsed.toDouble(),
                    color: Colors.orange,
                    width: 12,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
