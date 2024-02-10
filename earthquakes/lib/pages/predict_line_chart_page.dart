
import 'package:earthquakes/model/stock_model.dart';
import 'package:earthquakes/notifications/followed_earthquake_item.dart';
import 'package:earthquakes/notifications/followed_earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../charts/predict_line_chart.dart';
import '../charts/mag_predict_line_chart_page.dart';
import '../services/api_service.dart';

class PredictLineDataPage extends StatefulWidget {
  const PredictLineDataPage(
      {required Key? key, required this.stationCode, required this.stationName})
      : super(key: key);
  final String stationCode;
  final String stationName;
  // final String stockName;
  @override
  _PredictLineDataPageState createState() => _PredictLineDataPageState();
}

class _PredictLineDataPageState extends State<PredictLineDataPage> {
  // String stockCode = "YLD";
  String _startDate = "2022-05-02";
  String _endDate = "2022-10-03";
  late Future<List<DataPoint>?> _chartData;
  late Future<List<PredictionData>?> predictedPrice;

  DateTime lastMonth =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime yesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  @override
  void initState() {
    super.initState();
    _chartData = ApiService().fetchAllPredictions(widget.stationCode);
    predictedPrice = ApiService().fetchStatitonkDataToday(widget.stationCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.stationName),
          actions: [
            IconButton(
                onPressed: () {
                  // TODO: the value added is random, to be changed to the real one
                  Provider.of<FollowedEarthquakeModel>(context, listen: false)
                      .alterExistance(FollowedEarthquakeItem(
                          widget.stationCode, widget.stationName, null));
                  setState(() {});
                },
                tooltip: "Follow",
                icon: FollowedEarthquakeModel().doesExist(widget.stationCode)
                    ? const Icon(Icons.star_rounded)
                    : const Icon(Icons.star_border_rounded)),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            decoration: const InputDecoration(
                                labelText: 'Start date (yyyy-mm-dd)'),
                            onChanged: (value) {
                              setState(() {
                                _startDate = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            decoration: const InputDecoration(
                                labelText: 'End date (yyyy-mm-dd)'),
                            onChanged: (value) {
                              setState(() {
                                _endDate = value;
                              });
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          setState(() {
                            _chartData = ApiService()
                                .fetchAllPredictions(widget.stationCode);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<DataPoint>?>(
                  future: _chartData,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      var points = snapshot.data;
                      if (points != null) {
                        points.removeWhere(
                            (DataPoint data) => data.realValue == 0);
                      }
                    }
                    return Column(
                      children: [
                        Text(
                            "${widget.stationCode} station average weekly seismic energy(MJ)"),
                        PredictLineDataWidget(
                          points: snapshot.data,
                          showCloseData: true,
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "${widget.stationCode} station average magnitude values"),
                        MagPredictLineDataWidget(
                          points: snapshot.data,
                          showCloseData: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
