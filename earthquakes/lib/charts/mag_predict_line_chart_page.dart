import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/stock_model.dart';
import 'package:intl/intl.dart';

class MagPredictLineDataWidget extends StatelessWidget {
  final List<DataPoint> points;
  final bool showCloseData;

  MagPredictLineDataWidget(
      {required this.points, this.showCloseData = true, super.key});
  final _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
      maximumZoomLevel: 0.3);

  @override
  Widget build(BuildContext context) {
    List<DataPoint> lastSevenDaysData = points;
    List<ChartSeries> series = [
      LineSeries<DataPoint, String>(
          dataSource: lastSevenDaysData,
          xValueMapper: (DataPoint data, _) =>
              DateFormat("yyyy-MM-dd").format(data.date),
          yValueMapper: (DataPoint data, _) => data.realValue != null
              ? (log(data.realValue) / log(2) - 5.24) / 1.44
              : 0.0,
          name: "Actual"),
    ];
    if (showCloseData) {
      series.add(
        LineSeries<DataPoint, String>(
            dataSource: lastSevenDaysData,
            xValueMapper: (DataPoint data, _) =>
                DateFormat("yyyy-MM-dd").format(data.date),
            yValueMapper: (DataPoint data, _) => data.predictedValue != null
                ? (log(data.predictedValue) / log(2) - 5.24) / 1.44
                : 0.0,
            name: "Predicted"),
      );
    }
    return Stack(
      children: [
        SfCartesianChart(
          primaryYAxis: NumericAxis(minimum: -4),
          enableAxisAnimation: true,
          zoomPanBehavior: _zoomPanBehavior,
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            isResponsive: true,
          ),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: series,
        ),
        Positioned(
          bottom: 35,
          right: 10,
          child: ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.end,
            buttonPadding: const EdgeInsets.all(0),
            children: [
              IconButton(
                  onPressed: () {
                    _zoomPanBehavior.zoomIn();
                  },
                  icon: const Icon(Icons.zoom_in)),
              IconButton(
                  onPressed: () {
                    _zoomPanBehavior.reset();
                  },
                  icon: const Icon(Icons.restart_alt_rounded)),
              IconButton(
                  onPressed: () {
                    _zoomPanBehavior.zoomOut();
                  },
                  icon: const Icon(Icons.zoom_out)),
            ],
          ),
        )
      ],
    );
  }
}
