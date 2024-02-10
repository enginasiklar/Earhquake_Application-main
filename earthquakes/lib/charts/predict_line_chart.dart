import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/stock_model.dart';
import 'package:intl/intl.dart';

class PredictLineDataWidget extends StatelessWidget {
  final List<DataPoint> points;
  final bool showCloseData;

  PredictLineDataWidget(
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
          yValueMapper: (DataPoint data, _) => data.realValue,
          name: "Actual"),
    ];
    if (showCloseData) {
      series.add(
        LineSeries<DataPoint, String>(
            dataSource: lastSevenDaysData,
            xValueMapper: (DataPoint data, _) =>
                DateFormat("yyyy-MM-dd").format(data.date),
            yValueMapper: (DataPoint data, _) => data.predictedValue,
            name: "Predicted"),
      );
    }
    // _zoomPanBehavior.zoomByFactor(0.8);
    return Stack(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SfCartesianChart(
          primaryYAxis: NumericAxis(minimum: -300),
          enableAxisAnimation: true,
          zoomPanBehavior: _zoomPanBehavior,
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            isResponsive: true,
            // Legend title
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
