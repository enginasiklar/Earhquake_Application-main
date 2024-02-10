import 'package:flutter/material.dart';
import 'package:earthquakes/pages/gauge_range_page.dart';
import 'package:earthquakes/pages/map.dart';
import 'package:earthquakes/pages/search_page.dart';
import 'package:earthquakes/pages/kandilli.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.map),
            ),
            Tab(
              icon: Icon(Icons.list),
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
          ]),
        ),
        backgroundColor: Colors.amber[40],
        body: TabBarView(children: [
          const MyMapPage(),
          const EarthquakeListPage(),

          // const BarChartPage(),
          GaugeRangePage(),
          // ignore: prefer_const_constructors
          const SearchViewPage(),
        ]),
      ),
    );
  }
}
