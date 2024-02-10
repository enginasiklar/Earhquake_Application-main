import 'package:flutter/material.dart';
//import '../model/stock_model.dart';
import '../pages/predict_line_chart_page.dart';
import '../services/api_service.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({Key? key}) : super(key: key);

  @override
  State<SearchViewPage> createState() => _SearchViewPageState();
}

class _SearchViewPageState extends State<SearchViewPage> {
  TextEditingController searchTextController = TextEditingController();

  late Future<List<Stations>> _stationkList;
  List<Stations> _auxStationList = [];

  @override
  void initState() {
    super.initState();
    _stationkList = getStationNames();
    _stationkList.then((value) {
      setState(() {
        _auxStationList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextController,
          decoration: const InputDecoration(labelText: 'Search'),
          onChanged: (value) {
            setState(() {
              _auxStationList = getListFromQuery(value);
            });
          },
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: _auxStationList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(_auxStationList[index].ticker),
                    subtitle: Text(_auxStationList[index].name),
                    trailing: SizedBox(
                        width: 100,
                        height: 50,
                        child: Column(
                          children: [
                            Text(
                              _auxStationList[index].latestPrediction.toStringAsFixed(2),
                              style: TextStyle(
                                color:
                                    _auxStationList[index].latestPrediction > 0
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'LP',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PredictLineDataPage(
                          key: null,
                          stationCode: _auxStationList[index].ticker,
                          stationName: _auxStationList[index].name,
                        );
                      }));
                    },
                  ),
                  const Divider(color: Colors.black)
                ],
              );
            },
          ),
        )
      ]),
    );
  }

  List<Stations> getListFromQuery(String query) {
    return _auxStationList
        .where((element) =>
            element.ticker.contains(RegExp(query, caseSensitive: false)) ||
            element.name.contains(RegExp(query, caseSensitive: false)))
        .toList();
  }
}

  // Function to get station names from the API

