import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AccuracyChart extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const AccuracyChart({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "${value.toInt()}%",
                    style: TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < activities.length) {
                    String dateStr = activities[value.toInt()]['recorded_date'];
                    DateTime date = DateTime.parse(dateStr);
                    return Text(
                      DateFormat("MMM dd").format(date),
                      style: TextStyle(fontSize: 10),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: activities.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value['accuracy'].toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.blue, // Match the color from PerformanceScreen
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
          minY: 0,
          maxY: 100,
        ),
      ),
    );
  }
}