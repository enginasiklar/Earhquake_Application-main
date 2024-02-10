// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../model/stock_model.dart';
// import '../services/api_service.dart';
// import '../constants.dart';

// //TODO list available stocks when clicked into the box, zoom-out func, better starting position, remove the right part

// class stockPage extends StatefulWidget {
//   const stockPage({super.key});

//   @override
//   _stockPageState createState() => _stockPageState();
// }

// class _stockPageState extends State<stockPage> {
//   late Future<List<PredictionData>> _chartData;
//   final TrackballBehavior _trackballBehavior =
//       TrackballBehavior(enable: true, activationMode: ActivationMode.singleTap);
//   String _stockCode = 'AYV'; // default region AYV code

//   @override
//   void initState() {
//     super.initState();
//     _chartData = ApiService().fetchPredictionkData(_stockCode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             body: Column(children: <Widget>[
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(labelText: 'Enter region'),
//                 onChanged: (value) {
//                   _stockCode = value;
//                 },
//               ),
//             ),
//             ElevatedButton(
//               child: Text('Enter'),
//               onPressed: () {
//                 // print(_stockCode);
//                 setState(() {
//                   _chartData = ApiService().fetchPredictionkData(_stockCode);
//                   // print(_stockCode);
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       Expanded(
//         child: Center(
//           child: Text(""),
//         ),
//       ),
//     ])));
//   }
// }
