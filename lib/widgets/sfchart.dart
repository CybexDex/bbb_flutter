import 'dart:math';

import 'package:intl/intl.dart';
import 'package:bbb_flutter/vendor/sfcharts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:bbb_flutter/widgets/sparkline.dart';

class PriceChart extends StatelessWidget {
  PriceChart({Key key, @required this.data});

  List<TickerData> data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            dateFormat: DateFormat.Hm(),
            zoomFactor: 0.2,
            zoomPosition: 1.0,
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              minimum: 9300,
              opposedPosition: true,
              axisLine: AxisLine(width: 0),
              majorTickLines: MajorTickLines(size: 0)),
          series: getLineSeries(data),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
//          trackballBehavior: TrackballBehavior(
//              enable: true,
//              activationMode: ActivationMode.singleTap,
//              lineType: TrackballLineType.vertical,
//              tooltipSettings:
//              InteractiveTooltip(format: '{point.x} : {point.y}')
//          ),
        );
  }
}

num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

double profit = 12300;
double loss = 8600;

List<ChartSeries<_ChartData, DateTime>> getLineSeries(data) {
  DateTime today = new DateTime.now();
  List<_ChartData> chartDataLine = new List<_ChartData>();
  today = today.add(new Duration(seconds: 60 * 10));

  const List<double> strikes = [8, 9, 10, 12, 13];
  const List<String> namesList = [
    "tradefun",
    "tokehunt",
    "shiranui-mai",
    "cybest-test",
    "hyper-jagger"
  ];

  const Color t_green = Color.fromRGBO(0, 189, 174, 0);
  const Color t_red = Color.fromRGBO(229, 101, 144, 0);

  if(data.length <= 0){
    return <LineSeries<_ChartData, DateTime>>[];
  }
  // var reversed = data.reversed.toList();
  double current = data[data.length-1].value;
  DateTime last = data[data.length-1].time.add(Duration(hours: 8));
  for (int i = 0; i < data.length; i++) {
    chartDataLine.add(
        _ChartData(data[i].time.add(Duration(hours: 8)), data[i].value)
    );
  }

  for (int i = 1; i < 20; i++) {
    chartDataLine.add(
        _ChartData(last.add(Duration(seconds: 60*i)), null)
    );
  }

//  List<_ChartData> chartData;
//  for (int i = 0; i < 30; i++) {
//    int val = getRandomInt(0, strikes.length);
//    _OrderInfo order =
//        new _OrderInfo(strikes[val] * 1000, strikes[val] < 11, namesList[val]);
//    chartData[i] =
//        _ChartData(chartDataLine[i * 10].x, chartDataLine[i * 10].y, order);
//  }

  var timeSequence = chartDataLine.reversed.toList();
  final List<Color> color = <Color>[];
  color.add(Colors.blue[50]);
  color.add(Colors.blue[200]);
  color.add(Colors.blue);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
  LinearGradient(colors: color, stops: stops);

  return <ChartSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
        name: 'Prices',
        enableTooltip: false,
        dataSource: timeSequence,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        color: Colors.blueAccent,
//        gradient: gradientColors,
        ),
    LineSeries<_ChartData, DateTime>(
        name: 'Current',
        enableTooltip: false,
        animationDuration: 0,
        dataSource: timeSequence,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => current,
        color: Colors.blueAccent,
        width: 1),
//    LineSeries<_ChartData, DateTime>(
//        name: 'Profit',
//        enableTooltip: false,
//        animationDuration: 0,
//        dashArray: [3, 3, 3, 3],
//        dataSource: chartDataLine,
//        xValueMapper: (_ChartData sales, _) => sales.x,
//        yValueMapper: (_ChartData sales, _) => profit,
//        color: Colors.redAccent,
//        width: 2),
//    LineSeries<_ChartData, DateTime>(
//        name: 'Loss',
//        enableTooltip: false,
//        animationDuration: 0,
//        dashArray: [3, 3, 3, 3],
//        dataSource: chartDataLine,
//        xValueMapper: (_ChartData sales, _) => sales.x,
//        yValueMapper: (_ChartData sales, _) => loss,
//        color: Colors.lightGreen,
//        width: 2),
//    LineSeries<_ChartData, DateTime>(
//        name: 'Orders',
//        enableTooltip: true,
//        animationDuration: 500,
//        dataSource: chartData,
//        xValueMapper: (_ChartData sales, _) => sales.x,
//        yValueMapper: (_ChartData sales, _) => sales.y,
//        pointColorMapper: (_ChartData sales, _) =>
//            sales.order.isLong ? t_red : t_green,
//        markerSettings: MarkerSettings(isVisible: true),
//        width: 1)
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, [this.order]);

  final DateTime x;
  final double y;
  final _OrderInfo order;
}

class _OrderInfo {
  _OrderInfo(this.strike, this.isLong, this.username);

  final double strike;
  final bool isLong;
  final String username;
}
