import 'package:earthquakes/price_points.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;
  const LineChartWidget(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points.map((e) => FlSpot(e.x, e.y)).toList(),
              dotData: FlDotData(show: true),
              isCurved: true,
            ),
          ],
        ),
      ),
    );
  }
}
