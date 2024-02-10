import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:earthquakes/constants.dart';

List<Map<String, dynamic>> exampleEarthquakeData = [
  {"title": "Maraş", "mag": 7.5, "date": "2023-02-06"},
  {"title": "Istanbul", "mag": 7.5, "date": "1999-04-30"},
  {"title": "Van", "mag": 7, "date": "2011-04-29"},
  // Add more example data here if desired...
];

class EarthquakeListPage extends StatefulWidget {
  const EarthquakeListPage({super.key});

  @override
  _EarthquakeListPageState createState() => _EarthquakeListPageState();
}

class _EarthquakeListPageState extends State<EarthquakeListPage> {
  Future<List> _fetchEarthquakes() async {
    final response = await http.get(Uri.parse(ApiConstants.kandilli));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Map<String, dynamic> data = jsonDecode(response.body);
      List result =
          data['result']; // 'result' is the key that contains the list.

      // Sort the list by magnitude in descending order.
      result.sort((a, b) => b['mag'].compareTo(a['mag']));

      return result;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load earthquake data');
    }
  }

  Color _magnitudeColor(double magnitude) {
    if (magnitude < 3.0) {
      return Colors.green;
    } else if (magnitude < 5.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Earthquakes'),
      ),
      body: FutureBuilder<List>(
        future: _fetchEarthquakes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // If there is an error, show example data.
            return ListView.separated(
              itemCount: exampleEarthquakeData.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) {
                String date = exampleEarthquakeData[index]['date'];
                return ListTile(
                  title: Text(
                    exampleEarthquakeData[index]['title'],
                    style: TextStyle(
                      color: _magnitudeColor(
                        exampleEarthquakeData[index]['mag'].toDouble(),
                      ),
                    ),
                  ),
                  subtitle: Text("Date: $date"),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _magnitudeColor(
                        exampleEarthquakeData[index]['mag'].toDouble(),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      exampleEarthquakeData[index]['mag'].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          } else {
            List data = snapshot.data!;
            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) {
                String date = data[index]['date'];
                return ListTile(
                  title: Text(
                    data[index]['title'],
                    style: TextStyle(
                      color: _magnitudeColor(data[index]['mag'].toDouble()),
                    ),
                  ),
                  subtitle: Text("Date: $date"),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _magnitudeColor(data[index]['mag'].toDouble()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data[index]['mag'].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
