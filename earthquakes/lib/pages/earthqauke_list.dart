import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Earthquake {
  final String title;
  final double magnitude;
  Earthquake({this.title = '', required this.magnitude});

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      title: json['properties']['title'] ?? '',
      magnitude: json['properties']['mag'],
    );
  }
}

class EarthquakeList extends StatefulWidget {
  const EarthquakeList({super.key});

  @override
  _EarthquakeListState createState() => _EarthquakeListState();
}

class _EarthquakeListState extends State<EarthquakeList> {
  List<Earthquake> earthquakes = [];
  bool _isLoading = false;
  List<Earthquake> localExampleData = [
    Earthquake(title: 'Example earthquake 1', magnitude: 3.5),
    Earthquake(title: 'Example earthquake 2', magnitude: 4.2),
    Earthquake(title: 'Example earthquake 3', magnitude: 2.8),
    Earthquake(title: 'Example earthquake 4', magnitude: 5.1),
    Earthquake(title: 'Example earthquake 5', magnitude: 3.9),
  ];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    try {
      var response = await http.get(Uri.parse(
          'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        earthquakes = (data['features'] as List)
            .map((e) => Earthquake.fromJson(e))
            .toList();
      } else {
        earthquakes = localExampleData;
      }
    } catch (error) {
      // print(error);
      earthquakes = localExampleData;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by region',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: earthquakes.length,
              itemBuilder: (context, index) {
                if (earthquakes[index]
                    .title
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) {
                  return GestureDetector(
                    child: ListTile(
                      title: Text(earthquakes[index].title),
                      subtitle:
                          Text('Magnitude: ${earthquakes[index].magnitude}'),
                    ),
                    onTap: () {
                      print(earthquakes[index].title);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }
}

class EarthquakePage extends StatelessWidget {
  const EarthquakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Earthquakes'),
      ),
      body: const EarthquakeList(),
    );
  }
}
