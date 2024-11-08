import 'package:flutter/material.dart';
import 'package:earthquakes/charts/gauge_range.dart';
import 'package:earthquakes/services/api_service.dart';
import 'package:earthquakes/model/gauge_model.dart';

class GaugeRangePage extends StatelessWidget {
  GaugeRangePage({super.key});
  Future<Sentiment> futureAlbum = ApiService().getSentiment();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Sentiment>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GaugeRangeWidget(snapshot.data!.data[0]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
