import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:earthquakes/constants.dart';

class MyMapPage extends StatefulWidget {
  const MyMapPage({super.key});

  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  Future<List> _fetchEarthquakes() async {
    final response = await http.get(Uri.parse(ApiConstants.kandilli));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['result']; // 'result' is the key that contains the list.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load earthquake data');
    }
  }

  Future<List<dynamic>> _fetchHistoricalEarthquakes(String city) async {
    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime(now.year - 10, now.month, now.day);
    final DateTime endDate = now;
    const double minLatitude = 36.0;
    const double maxLatitude = 42.0;
    const double minLongitude = 26.0;
    const double maxLongitude = 45.0;

    final String apiUrl =
        'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=${startDate.toIso8601String()}&endtime=${endDate.toIso8601String()}&minlatitude=$minLatitude&maxlatitude=$maxLatitude&minlongitude=$minLongitude&maxlongitude=$maxLongitude';

    final response = await http.get(Uri.parse(apiUrl));
    print(apiUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> earthquakes = data['features'];

      // Şehre göre depremleri filtrele
      List<dynamic> filteredEarthquakes = earthquakes.where((quake) {
        // Deprem bilgilerine erişim sağlayın ve filtreleyin (ör. closestCity vs.)
        String? earthquakeCity = quake['properties']['place'];
        int? earthquakeTime = quake['properties']['time'];
        return earthquakeCity?.contains(city) == true && earthquakeTime != null;
      }).toList();

      return filteredEarthquakes;
    } else {
      throw Exception('Failed to load historical earthquake data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: _fetchEarthquakes(),
        builder: (context, snapshot) {
          List<Marker> markers = [];
          if (snapshot.hasData) {
            markers = snapshot.data!
                .map((quake) {
                  List<dynamic>? coordinates = quake['geojson']['coordinates'];
                  if (coordinates != null && coordinates.length == 2) {
                    double lat = coordinates[1].toDouble();
                    double lng = coordinates[0].toDouble();
                    double magnitude =
                        quake['mag'] != null ? quake['mag'].toDouble() : 0.0;
                    String? closestCity =
                        quake['location_properties']['closestCity']['name'];
                    print(
                        "Creating marker at lat: $lat, lng: $lng, magnitude: $magnitude, closest city: $closestCity");

                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat, lng),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: ctx,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Earthquake Details'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Closest City: $closestCity'),
                                      Text('Latitude: $lat'),
                                      Text('Longitude: $lng'),
                                      Text('Magnitude: $magnitude'),

                                      // Add more details here...
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: magnitude > 3.0
                            ? const Icon(
                                Icons.warning,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                      ),
                    );
                  }
                })
                .where((marker) => marker != null)
                .cast<Marker>()
                .toList();
          }

          return FlutterMap(
            options: MapOptions(
              center: LatLng(39.9333635, 32.8597419),
              zoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          );
        },
      ),
    );
  }
}
