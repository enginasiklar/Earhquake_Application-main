import 'dart:convert';
import 'package:earthquakes/model/gauge_model.dart';
import 'package:earthquakes/model/line_model.dart';
import 'package:http/http.dart' as http;
import 'package:earthquakes/constants.dart';
import 'package:earthquakes/model/user_model.dart';
import '../model/stock_model.dart';

class ApiService {
  Future<List<UserModel>> getUsers() async {
    final response = await http
        .get(Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint));
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Sentiment> getSentiment() async {
    final response = await http.get(Uri.parse(ApiConstants.gaugeUrl));
    if (response.statusCode == 200) {
      return Sentiment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<LineData>> getLineData() async {
    final response = await http.get(Uri.parse(ApiConstants.lineChartUrl));
    if (response.statusCode == 200) {
      return lineDataFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<PredictionData>?> fetchPredictionData(
      String stockCode, String startDate, String endDate) async {
    try {
      var response = await http.get(
        Uri.parse(
            "${ApiConstants.candleUrl}$stockCode/start=$startDate&end=$endDate"),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body
            .replaceAllMapped(RegExp(r"NaN"), (Match match) => "null"));
        var efdData = data["${stockCode}_efddata"];
        List<PredictionData> predictionDataList = [];
        for (var i in efdData) {
          if (i[1].runtimeType != Null) {
            predictionDataList.add(PredictionData.fromJson(i));
          }
        }
        return predictionDataList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<PredictionData>> fetchStatitonkDataToday(String stockCode) async {
    DateTime now = DateTime.now().subtract(const Duration(days: 60));
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 90));
    String end =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String start =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    try {
      var response = await http.get(
        Uri.parse("${ApiConstants.candleUrl}$stockCode/start=$start&end=$end"),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body
            .replaceAllMapped(RegExp(r"NaN"), (Match match) => "null"));
        var efdData = data["${stockCode}_efddata"];
        List<PredictionData> predictionDataList = [];
        for (var i in efdData) {
          if (i[1].runtimeType != Null) {
            predictionDataList.add(PredictionData.fromJson(i));
          }
        }
        return predictionDataList;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return [];
    }
  }

  // Future<List<DataPoint>?> fetchAllData(
  //     String stationName, String startDate, String endDate) async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse("${ApiConstants.candleUrl}predictions/$stationName"),
  //       headers: {
  //         'Authorization': 'Basic ${base64Encode(utf8.encode('uysm:pecnet'))}',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body
  //           .replaceAllMapped(RegExp(r"NaN"), (Match match) => "null"));
  //       var efdData = data["${stationName}_efddata"];
  //       List<DataPoint> predictionDataList = [];
  //       for (var i in efdData) {
  //         if (i[1].runtimeType != Null) {
  //           predictionDataList.add(DataPoint.fromJson(i));
  //         }
  //       }
  //       return predictionDataList;
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<List<DataPoint>?> fetchAllPredictions(String stationCode) async {
    final response = await http.get(
      Uri.parse(
          'https://2f80-160-75-160-231.ngrok-free.app/api/stations/$stationCode/allpredictions'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> values = jsonResponse['values'];

      List<DataPoint> predictions = [];

      values.forEach((date, data) {
        DateTime dateTime = DateTime.parse(date);
        double realValue = data['realValue'];
        double predictedValue = data['prediction'];
        predictions.add(DataPoint(
            date: dateTime,
            realValue: realValue,
            predictedValue: predictedValue));
      });

      return predictions;
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}

Future<List<Stations>> getStationNames() async {
  final response = await http.get(
      Uri.parse('https://2f80-160-75-160-231.ngrok-free.app/api/stations/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data.keys
        .map((e) => Stations(e, data[e]['name'],
            (data[e]['latestPrediction'] as num).toDouble()))
        .toList();
  } else {
    throw Exception('Failed to load station names');
  }
}

// Function to filter station list as per search query

class Stations {
  final String ticker;
  final String name;
  final double latestPrediction;

  Stations(this.ticker, this.name, this.latestPrediction);
}

class PredictionData1 {
  final String name;
  final double? latestPrediction;
  final double? latestValue;

  PredictionData1(
      {required this.name, this.latestPrediction, this.latestValue});

  factory PredictionData1.fromJson(Map<String, dynamic> json) {
    return PredictionData1(
      name: json['name'],
      latestPrediction: json['latestPrediction'],
      latestValue: json['latestValue'],
    );
  }
}
