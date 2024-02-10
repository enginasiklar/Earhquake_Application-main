import 'package:intl/intl.dart';

class DataPoint {
  final DateTime date;
  final double realValue;
  final double predictedValue;

  DataPoint({
    required this.date,
    required this.realValue,
    required this.predictedValue,
  });
}

class PredictionData {
  final DateTime date;
  late double estimation;

  PredictionData({
    required this.date,
    required this.estimation,
  });

  factory PredictionData.fromJson(List json) {
    var dateFormat = DateFormat("yyyy-MM-dd");
    var date = dateFormat.parse(json[0]);
    var estimation1 = json[1];

    return PredictionData(
      date: DateTime(date.year, date.month, date.day),
      estimation: estimation1,
    );
  }

  List<PredictionData> getWeekly(List<PredictionData> daily) {
    //TODO: better algorithm
    List<PredictionData> myList = [];
    int loops = daily.length ~/ 7;
    for (int i = 0; i < loops; i++) {
      double estimationData = 0;

      for (var j = 0; j < 7; j++) {
        estimationData += daily[i * 7 + j].estimation;
      }
      estimationData /= 7;

      myList.add(
          PredictionData(date: daily[i * 7].date, estimation: estimationData));
    }
    if (daily.length % 7 != 0) {
      double estimationData = 0;
      double open = 0;
      double low = 0;
      double high = 0;
      for (int i = loops * 7; i < daily.length; i++) {
        estimationData += daily[i].estimation;
      }
      estimationData /= daily.length - loops * 7;

      myList.add(PredictionData(
        date: daily[loops * 7].date,
        estimation: estimationData,
      ));
    }
    return myList;
  }

  List<PredictionData> getMonthly(List<PredictionData> weekly) {
    //TODO: better algorithm
    List<PredictionData> myList = [];
    int loops = weekly.length ~/ 4;
    for (int i = 0; i < loops; i++) {
      double estimationData = 0;

      for (var j = 0; j < 4; j++) {
        estimationData += weekly[i * 4 + j].estimation;
      }
      estimationData /= 4;

      myList.add(PredictionData(
        date: weekly[i * 4].date,
        estimation: estimationData,
      ));
    }
    if (weekly.length % 4 != 0) {
      double estimationData = 0;

      for (int i = loops * 4; i < weekly.length; i++) {
        estimationData += weekly[i].estimation;
      }
      estimationData /= weekly.length - loops * 4;

      myList.add(PredictionData(
        date: weekly[loops * 4].date,
        estimation: estimationData,
      ));
    }
    return myList;
  }
}

List<PredictionData> getChartData() {
  return <PredictionData>[
    PredictionData(date: DateTime(2016, 01, 11), estimation: 97.13),
    PredictionData(date: DateTime(2016, 01, 18), estimation: 101.42),
    PredictionData(date: DateTime(2016, 01, 25), estimation: 97.34),
  ];
}

// Stations
class Stations {
  final String ticker;
  final String name;
  final double latestPrediction;

  Stations(
      {required this.ticker,
      required this.name,
      required this.latestPrediction});

  factory Stations.fromJson(Map<String, dynamic> json, String ticker) {
    return Stations(
      ticker: ticker,
      name: json['name'],
      latestPrediction: json['latestPrediction'],
    );
  }
}

// List<Stations> stations = [
//   Stations('AYV', "AYV Station"),
//   Stations('YLD', 'YLD Station'),
//   Stations('AVC', 'AVC Station'),
//   Stations('SLV', 'SLV Station'),
//   Stations('TZL', 'TZL Station'),
//   Stations('GZL', 'GZL Station'),
//   Stations('MME', 'MME Station'),
//   Stations('CNR', 'CNR Station'),
//   // add more stocks as needed
// ];


