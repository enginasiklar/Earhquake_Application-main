import 'package:earthquakes/price_points.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final List<PricePoint> points;
  const BarChartWidget(this.points, {super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.width;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    double requiredWidth = height - padding.left - padding.right;
    return AspectRatio(
      aspectRatio: 0.85,
      child: BarChart(
        BarChartData(
            borderData: FlBorderData(
              border: const Border(
                top: BorderSide(width: 1),
                right: BorderSide(width: 1),
                left: BorderSide(width: 1),
                bottom: BorderSide(width: 1),
              ),
            ),
            groupsSpace: 10,
            barGroups: points
                .map(
                  (e) => BarChartGroupData(x: e.x.toInt(), barRods: [
                    BarChartRodData(
                        toY: e.y,
                        fromY: 0,
                        width: requiredWidth / 70,
                        color: Colors.blueGrey)
                  ]),
                )
                .toList()),
      ),
    );
  }
}
