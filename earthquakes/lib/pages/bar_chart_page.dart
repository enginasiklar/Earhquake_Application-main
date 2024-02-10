import 'package:flutter/material.dart';
import 'package:earthquakes/price_points.dart';
import 'package:earthquakes/charts/bar_chart.dart';

class BarChartPage extends StatelessWidget {
  const BarChartPage({super.key});
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
                        child: BarChartWidget(snapshot.data))
                  ]);
                })),
      ),
    );
  }
}
