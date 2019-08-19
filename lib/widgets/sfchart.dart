import 'dart:math';

import 'package:intl/intl.dart';
import 'package:bbb_flutter/vendor/sfcharts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui';
import 'package:bbb_flutter/widgets/sparkline.dart';

class PriceChart extends StatelessWidget {
  PriceChart({Key key, @required this.data, this.zoom, this.cutOff, this.takeProfit});

  List<TickerData> data;
  bool zoom;
  double cutOff;
  double takeProfit;

  double getMin(double factor){

    if(data.length>0){
      double min = data[0].value;
      for(int i=1; i<data.length;i++){
        if(data[i].value<min){
          min = data[i].value;
        }
      }
      int level = min*factor~/100;
      return level.toDouble()*100;
    }
    return null;
  }

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
              minimum: getMin(0.99),
              opposedPosition: true,
              axisLine: AxisLine(width: 0),
              majorTickLines: MajorTickLines(size: 0)),
          series: getLineSeries(data, takeProfit, cutOff),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
              enablePinching: zoom,
              zoomMode: ZoomMode.x,
              enablePanning: zoom
          ),
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineType: TrackballLineType.vertical,
              tooltipSettings:
              InteractiveTooltip(format: '{point.y}')
          ),
        );
  }
}

num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

List<ChartSeries<_ChartData, DateTime>> getLineSeries(data, profit, loss) {
  DateTime today = new DateTime.now();
  List<_ChartData> chartDataLine = new List<_ChartData>();
  today = today.add(new Duration(seconds: 60 * 10));

  const List<double> strikes = [8, 9, 10, 12, 13, 14];
  const List<String> namesList = [
    "tradefun",
    "tokehunt",
    "shiranui-mai",
    "cybest-test",
    "hyper-jagger",
    "py-test"
  ];

  const redOrange = const Color(0xffff5135);
  const shamrockGreen = const Color(0xff3cb879);
  const Color t_green = Color.fromRGBO(60,184,121, 0);
  const Color t_red = Color.fromRGBO(255,81,53, 0);

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

  List<_ChartData> chartData = new List<_ChartData>();;
  for (int i = 20; i < chartDataLine.length-5; i++) {
    if(chartDataLine[i].x.minute%15==0){
      //int val = getRandomInt(0, strikes.length);
      int val = ((chartDataLine[i].x.minute/5)%6).toInt();
      _OrderInfo order =
      new _OrderInfo(strikes[val] * 1000, strikes[val] < 11, namesList[val]);
      chartData.add(
          _ChartData(chartDataLine[i].x, chartDataLine[i].y, order));
    }
  }

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
    CustomLineSeries<_ChartData, DateTime>(
        enableTooltip: false,
        animationDuration: 0,
        dataSource: timeSequence,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => current,
        color: Colors.blueAccent,
        lineVal: current,
        width: 1),
    CustomLineSeries<_ChartData, DateTime>(
        enableTooltip: false,
        visible: profit!=null,
        animationDuration: 0,
        dashArray: [3, 3, 3, 3],
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => profit,
        lineVal: profit,
        color: Colors.redAccent,
        width: 2),
    CustomLineSeries<_ChartData, DateTime>(
        name: 'Loss',
        visible: loss!=null,
        enableTooltip: false,
        animationDuration: 0,
        dashArray: [3, 3, 3, 3],
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => loss,
        lineVal: loss,
        color: Colors.lightGreen,
        width: 2),
    LineSeries<_ChartData, DateTime>(
        name: 'Orders',
        enableTooltip: true,
        animationDuration: 500,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        pointColorMapper: (_ChartData sales, _) =>
            sales.order.isLong ? t_red : t_green,
        markerSettings: MarkerSettings(isVisible: true),
        width: 1)
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

class CustomLineSeries<T, D> extends LineSeries<T, D> {
  CustomLineSeries({
    @required List<T> dataSource,
    @required ChartValueMapper<T, D> xValueMapper,
    @required ChartValueMapper<T, num> yValueMapper,
    String name,
    String xAxisName,
    String yAxisName,
    Color color,
    double width,
    MarkerSettings markerSettings,
    EmptyPointSettings emptyPointSettings,
    DataLabelSettings dataLabel,
    bool visible,
    bool enableTooltip,
    List<double> dashArray,
    double animationDuration,
    double lineVal
  }) : lineVal = lineVal,
        super(
          name: name,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          dataSource: dataSource,
          xAxisName: xAxisName,
          yAxisName: yAxisName,
          color: color,
          width: width,
          markerSettings: markerSettings,
          emptyPointSettings: emptyPointSettings,
          dataLabelSettings: dataLabel,
          isVisible: visible,
          enableTooltip: enableTooltip,
          dashArray: dashArray,
          animationDuration: animationDuration);

  double lineVal;

  @override
  ChartSegment createSegment() {
    return CustomPainter(lineVal);
  }
}

class CustomPainter extends LineSegment {
  CustomPainter(this.lineVal);

  double lineVal;

  @override
  void onPaint(Canvas canvas) {
    final double x1 = this.x1, y1 = this.y1, x2 = this.x2, y2 = this.y2;

    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, getStrokePaint());

    if (currentSegmentIndex == 0 && x1.isNaN==false && y1.isNaN==false) {

      final TextSpan span = TextSpan(
        style: TextStyle(
            color: color, fontSize: 12.0, fontFamily: 'Roboto'),
        text: lineVal.toString(),
      );
      final TextPainter tp =
      TextPainter(text: span, textDirection: prefix0.TextDirection.ltr);
      tp.layout();
      tp.paint( canvas, Offset(x1-50,y1-14));
    }
  }
}