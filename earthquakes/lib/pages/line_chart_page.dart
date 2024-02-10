import 'package:flutter/material.dart';
import 'package:earthquakes/charts/line_chart.dart';
import 'package:earthquakes/price_points.dart';

class LineChartPage extends StatelessWidget {
  const LineChartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<List<PricePoint>>(
                future: getPricePoints(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()]);
                  }
                  return Column(children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: LineChartWidget(snapshot.data))
                  ]);
                })),
      ),
    );
  }
}
