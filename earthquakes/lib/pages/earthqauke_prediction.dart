import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/stock_model.dart';
import '../services/api_service.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<PredictionData> _data = [];

  @override
  void initState() {
    super.initState();
    ApiService()
        .fetchPredictionData("AYV", "2021-08-02", "2022-09-03")
        .then((value) {
      setState(() {
        _data = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var lineBarsData = LineChartBarData(
      spots: _data
          .map((e) =>
              FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.estimation))
          .toList(),
      isCurved: false,
      barWidth: 4,
      dotData: FlDotData(
        show: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Graph"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [lineBarsData],
            ),
          ),
        ),
      ),
    );
  }
}
