import 'dart:math' as math;
import 'dart:ui' as dui;

import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path_drawing/path_drawing.dart';
import 'package:logging/logging.dart';

@immutable
class TickerData {
  final double value;
  final DateTime time;

  TickerData(this.value, this.time);

  @override
  String toString() {
    return "$value " + ", time:" + time.toString();
  }
}

@immutable
class SuppleData {
  final double cutOff;
  final double takeProfit;
  final double underOrder;
  final double current;
  final bool alwaysShow;

  DateTime stopTime;
  DateTime endTime;
  SuppleData(
      {this.cutOff,
      this.takeProfit,
      this.underOrder,
      this.alwaysShow,
      this.current,
      this.stopTime,
      this.endTime});
}

class Sparkline extends StatelessWidget {
  Sparkline({
    Key key,
    @required this.data,
    @required this.startTime,
    @required this.endTime,
    this.startLineOfTime,
    this.suppleData,
    this.timeLineGap = const Duration(minutes: 5),
    this.marginSpace = 20,
    this.lineWidth = 2.0,
    this.lineColor = Colors.lightBlue,
    this.lineGradient,
    this.pointSize = 4.0,
    this.width,
    this.pointColor = const Color(0xFF0277BD), //Colors.lightBlue[800]
    this.fillColor = const Color(0xFF81D4FA), //Colors.lightBlue[200]
    this.fillGradient,
    this.gridLineColor = Colors.grey,
    this.gridLineAmount = 6,
    this.gridLineWidth = 0.5,
    this.repaint,
    this.labelStyle = const TextStyle(
        color: Color(0xffcccccc),
        fontSize: 10.0,
        fontWeight: FontWeight.normal),
  })  : assert(data != null),
        assert(startTime != null),
        assert(endTime != null),
        assert(lineWidth != null),
        assert(lineColor != null),
        assert(pointSize != null),
        assert(pointColor != null),
        assert(fillColor != null),
        super(key: key);

  List<TickerData> data;
  DateTime startTime;
  DateTime endTime;
  DateTime startLineOfTime;
  SuppleData suppleData;

  final Duration timeLineGap;
  final double marginSpace;

  final double width;

  final double lineWidth;

  final Color lineColor;

  final Gradient lineGradient;

  final double pointSize;

  final Color pointColor;

  final Color fillColor;

  final Gradient fillGradient;

  final Color gridLineColor;
  final TextStyle labelStyle;

  final int gridLineAmount;

  final double gridLineWidth;

  final double timeAreaHeight = 30;

  DateTime realStartTime;
  DateTime realEndTime;

  Listenable repaint;

  Future<List<dui.Image>> loadImages() async {
    List<dui.Image> images = [];
    List<String> names = [
      "res/assets/icons/icHand.png",
      "res/assets/icons/icTime.png"
    ];

    for (var name in names) {
      ByteData data = await rootBundle.load(name);
      dui.Codec codec =
          await dui.instantiateImageCodec(data.buffer.asUint8List());
      dui.FrameInfo fi = await codec.getNextFrame();
      images.add(fi.image);
    }
    return images;
  }

  clearExtraSeconds() {
    startTime = removeSeconds(startTime);
    endTime = removeSeconds(endTime);
    startLineOfTime = removeSeconds(startLineOfTime);
    data = data.map((d) => TickerData(d.value, removeSeconds(d.time))).toList();
    if (suppleData != null) {
      suppleData.stopTime = removeSeconds(suppleData.stopTime);
      suppleData.endTime = removeSeconds(suppleData.endTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    clearExtraSeconds();
    var calculateWidth = width - 2 * marginSpace;
    var totalSeconds = endTime.difference(startTime).inSeconds;
    var extraSeconds = totalSeconds * marginSpace / calculateWidth;
    realStartTime = startTime.subtract(Duration(seconds: extraSeconds.toInt()));

    realEndTime = endTime.add(Duration(seconds: extraSeconds.toInt()));
    var filterData = data
        .where((t) =>
            (t.time.isAfter(removeSeconds(realStartTime)) ||
                t.time.isAtSameMomentAs(removeSeconds(realStartTime))) &&
            (t.time.isBefore(ceilSecondsToMinute(realEndTime)) ||
                t.time.isAtSameMomentAs(ceilSecondsToMinute(realEndTime))))
        .toList();
    // Log(package: "").printWrapped(filterData.toString());
    if (filterData.length <= 1) {
      return Container();
    }
    double max = filterData.map((t) => t.value).reduce(math.max);
    double min = filterData.map((t) => t.value).reduce(math.min);
    double space = (max - min) / 4; //  2 / 3 空间展示

    return Stack(
      children: <Widget>[
        Container(
            child: CustomPaint(
          size: Size.infinite,
          painter: _CartesianPainter(
              startTime: startTime,
              startLineOfTime: startLineOfTime,
              endTime: endTime,
              timeLineGap: timeLineGap,
              gridLineColor: gridLineColor,
              labelStyle: labelStyle,
              timeAreaHeight: timeAreaHeight,
              gridLineWidth: gridLineWidth,
              valueLineAmount: gridLineAmount,
              marginSpace: marginSpace,
              maxValue: max + space,
              minValue: min - space),
        )),
        Container(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double totalValue = ((max - min) * 3 / 2);
            double unit =
                (constraints.maxHeight - 2 * marginSpace - timeAreaHeight) /
                    totalValue;
            return Container(
              padding: EdgeInsets.only(
                  top: totalValue * unit / 6 + marginSpace,
                  bottom: totalValue * unit / 6 + marginSpace + timeAreaHeight),
              child: CustomPaint(
                size: Size.infinite,
                painter: _TimeSharePainter(
                    data: filterData,
                    startTime: startTime,
                    realStartTime: realStartTime,
                    realEndTime: realEndTime,
                    endTime: endTime,
                    maxValue: max,
                    minValue: min,
                    fillGradient: fillGradient,
                    fillColor: fillColor,
                    lineColor: lineColor,
                    lineGradient: lineGradient,
                    lineWidth: lineWidth,
                    repaint: repaint,
                    marginSpace: marginSpace),
              ),
            );
          }),
        ),
        suppleData != null
            ? Container(
                child: CustomPaint(
                    size: Size.infinite,
                    painter: _HorizontalSupplePainter(
                        minValue: min - space,
                        maxValue: max + space,
                        gridLineAmount: gridLineAmount,
                        timeAreaHeight: timeAreaHeight,
                        marginSpace: marginSpace,
                        suppleData: suppleData)))
            : Container(),
        Container(
            child: FutureBuilder(
                future: loadImages(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dui.Image>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      return CustomPaint(
                          size: Size.infinite,
                          painter: _VerticalSupplePainter(
                              images: snapshot.data,
                              startTime: startTime,
                              endTime: endTime,
                              suppleData: suppleData,
                              timeAreaHeight: timeAreaHeight));
                  }
                })),
        Container(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double totalValue = ((max - min) * 3 / 2);
            double unit =
                (constraints.maxHeight - 2 * marginSpace - timeAreaHeight) /
                    totalValue;
            return Container(
              padding: EdgeInsets.only(
                  top: totalValue * unit / 6 + marginSpace,
                  bottom: totalValue * unit / 6 + marginSpace + timeAreaHeight),
              child: CustomPaint(
                size: Size.infinite,
                painter: _Pointer(
                    data: filterData,
                    startTime: startTime,
                    realStartTime: realStartTime,
                    realEndTime: realEndTime,
                    endTime: endTime,
                    maxValue: max,
                    minValue: min,
                    lineColor: lineColor,
                    repaint: repaint,
                    marginSpace: marginSpace),
              ),
            );
          }),
        )
      ],
    );
  }
}

class _CartesianPainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;
  final DateTime startLineOfTime;
  final double minValue;
  final double maxValue;

  final Duration timeLineGap;

  final Color gridLineColor;
  final TextStyle labelStyle;
  final double gridLineWidth;

  final int valueLineAmount;

  final double marginSpace;

  final double timeAreaHeight;

  List<TextPainter> verticalTextPainters = [];
  List<TextPainter> horizontalTextPainters = [];

  _CartesianPainter(
      {@required this.startTime,
      @required this.endTime,
      startLineOfTime,
      @required this.minValue,
      @required this.maxValue,
      this.timeLineGap = const Duration(minutes: 5),
      this.gridLineColor = const Color(0xffeaeaea),
      this.labelStyle = const TextStyle(
          color: Color(0xffcccccc),
          fontSize: 10.0,
          fontWeight: FontWeight.normal),
      this.gridLineWidth = 1,
      this.timeAreaHeight,
      this.valueLineAmount = 6,
      this.marginSpace = 20})
      : startLineOfTime = startLineOfTime ?? startTime;

  prepareTextPainter() {
    /// vertical
    double valueDist = (maxValue - minValue) / (valueLineAmount - 1);

    double value;
    for (int i = 0; i < valueLineAmount; i++) {
      value = maxValue - (valueDist * i);

//      String gridLineText;
//      if (value < 1) {
//        gridLineText = value.toStringAsPrecision(4);
//      } else if (value < 999) {
//        gridLineText = value.toStringAsFixed(2);
//      } else {
//        gridLineText = value.round().toString();
//      }

      verticalTextPainters.add(TextPainter(
          text: new TextSpan(text: value.toStringAsFixed(4), style: labelStyle),
          textDirection: TextDirection.ltr));
      verticalTextPainters[i].layout();
    }

    var totalSeconds = endTime.difference(startTime).inSeconds;

    /// horizontal
    DateTime time;
    int i = 0;
    for (Duration d = Duration();
        d <= Duration(seconds: totalSeconds);
        d += timeLineGap) {
      time = startLineOfTime.add(d);

      horizontalTextPainters.add(TextPainter(
          text: TextSpan(
              text: DateFormat('HH:mm').format(time), style: labelStyle),
          textDirection: TextDirection.ltr));

      horizontalTextPainters[i].layout();
      i++;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    ///prepareTextPainter

    if (horizontalTextPainters.isEmpty || verticalTextPainters.isEmpty) {
      prepareTextPainter();
    }

    Paint gridPaint = new Paint()
      ..color = gridLineColor
      ..strokeWidth = gridLineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    /// Draw Vertical Line
    double timeDist =
        (size.width - 2 * marginSpace) / (horizontalTextPainters.length - 1);
    double timeNormalizer = timeDist / timeLineGap.inSeconds;

    double timeOffset =
        startLineOfTime.difference(startTime).inSeconds * timeNormalizer;

    horizontalTextPainters.asMap().forEach((index, value) {
      double gridLineX = timeDist * index + timeOffset + marginSpace;
      canvas.drawPath(
        dashPath(
          Path()
            ..moveTo(gridLineX, 0)
            ..lineTo(gridLineX, size.height - timeAreaHeight),
          dashArray: CircularIntervalList<double>(<double>[4, 4]),
        ),
        gridPaint,
      );

      value.paint(
          canvas,
          Offset(gridLineX - value.size.width / 2,
              size.height - value.size.height / 2 - timeAreaHeight / 2));
    });

    /// Draw Horizontal Line
    double height = size.height - 2 * marginSpace - timeAreaHeight;
    double width;

    double gridLineDist = height / (valueLineAmount - 1);
    double gridLineY;
    for (int i = 0; i < valueLineAmount; i++) {
      width = size.width - verticalTextPainters[i].size.width;
      gridLineY = marginSpace + (gridLineDist * i).round().toDouble();

      canvas.drawPath(
        dashPath(
          Path()
            ..moveTo(0, gridLineY)
            ..lineTo(width, gridLineY),
          dashArray: CircularIntervalList<double>(<double>[4, 4]),
        ),
        gridPaint,
      );

      verticalTextPainters[i].paint(canvas,
          Offset(width, gridLineY - verticalTextPainters[i].size.height / 2));
    }

    canvas.drawLine(Offset(0, size.height - timeAreaHeight),
        Offset(size.width, size.height - timeAreaHeight), gridPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _TimeSharePainter extends CustomPainter {
  List<TickerData> data;
  final DateTime startTime;
  final DateTime realStartTime;
  final DateTime realEndTime;
  final DateTime endTime;
  final double minValue;
  final double maxValue;

  final double lineWidth;
  final Color lineColor;
  final Gradient lineGradient;
  final Color fillColor;
  final Gradient fillGradient;
  final double marginSpace;
  final Listenable repaint;

  _TimeSharePainter(
      {@required this.data,
      @required this.startTime,
      @required this.realStartTime,
      @required this.realEndTime,
      @required this.endTime,
      @required this.minValue,
      @required this.maxValue,
      this.lineWidth = 1,
      this.lineColor = Colors.blue,
      this.lineGradient,
      this.fillColor,
      this.fillGradient,
      this.repaint,
      this.marginSpace})
      : super(repaint: repaint);

  double getPixelX(int seconds, Size size) {
    var totalSeconds = endTime.difference(startTime).inSeconds;
    final double widthNormalizer =
        (size.width - 2 * marginSpace) / totalSeconds;
    return widthNormalizer * seconds;
  }

  getPixelY(double value, Size size) {
    final double heightNormalizer = size.height / (maxValue - minValue);
    return size.height - (value - minValue) * heightNormalizer;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// draw fillPath and line
    Offset startPoint, endPoint;
    final Path path = Path();

    double lX = 0.0, lY = 0.0;

    for (int i = 0; i < data.length; i++) {
      var seconds = data[i].time.difference(realStartTime).inSeconds;

      double x = getPixelX(seconds, size);
      double y = getPixelY(data[i].value, size);

      if (i == 0) {
        startPoint = Offset(x, y);
        path.moveTo(x, y);
      } else {
        /// CurrentSpot
        double px = x;
        double py = y;

        /// previous spot
        double p0x = getPixelX(
            data[i - 1].time.difference(realStartTime).inSeconds, size);
        double p0y = getPixelY(data[i - 1].value, size);

        double x1 = p0x + lX;
        double y1 = p0y + lY;

        /// next point
        int nextIndex = i + 1 < data.length ? i + 1 : i;
        double p1x = getPixelX(
            data[nextIndex].time.difference(realStartTime).inSeconds, size);
        double p1y = getPixelY(data[nextIndex].value, size);

        double smoothness = 0.3; //0 - 1
        lX = ((p1x - p0x) / 2) * smoothness;
        lY = ((p1y - p0y) / 2) * smoothness;
        double x2 = px - lX;
        double y2 = py - lY;

        path.cubicTo(x1, y1, x2, y2, px, py);
        // path.lineTo(x, y);
      }

      if (i == data.length - 1) {
        endPoint = Offset(x, y);
      }
    }

    Paint paint = new Paint()
      ..strokeWidth = lineWidth
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (lineGradient != null) {
      final Rect lineRect =
          new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      paint.shader = lineGradient.createShader(lineRect);
    }

    Path fillPath = new Path()..addPath(path, Offset.zero);
    fillPath.relativeLineTo(lineWidth / 2, 0.0);
    fillPath.lineTo(endPoint.dx, size.height);
    fillPath.lineTo(0.0, size.height);
    fillPath.lineTo(startPoint.dx, startPoint.dy);

    fillPath.close();

    Paint fillPaint = new Paint()
      ..strokeWidth = 0.0
      ..color = fillColor
      ..style = PaintingStyle.fill;

    if (fillGradient != null) {
      final Rect fillRect =
          new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      fillPaint.shader = fillGradient.createShader(fillRect);
    }
    canvas.drawPath(fillPath, fillPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _Pointer extends CustomPainter {
  List<TickerData> data;
  final DateTime startTime;
  final DateTime realStartTime;
  final DateTime realEndTime;
  final DateTime endTime;
  final double minValue;
  final double maxValue;

  final Color lineColor;

  final double marginSpace;
  final Listenable repaint;

  _Pointer({
    @required this.data,
    @required this.startTime,
    @required this.realStartTime,
    @required this.realEndTime,
    @required this.endTime,
    @required this.minValue,
    @required this.maxValue,
    @required this.marginSpace,
    this.lineColor = Colors.blue,
    this.repaint,
  }) : super(repaint: repaint);

  double getPixelX(int seconds, Size size) {
    var totalSeconds = endTime.difference(startTime).inSeconds;
    final double widthNormalizer =
        (size.width - 2 * marginSpace) / totalSeconds;
    return widthNormalizer * seconds;
  }

  getPixelY(double value, Size size) {
    final double heightNormalizer = size.height / (maxValue - minValue);
    return size.height - (value - minValue) * heightNormalizer;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset endPoint;

    if (data.last != null) {
      if (realEndTime.compareTo(data.last.time) < 0) {
        return;
      }
      var seconds = data.last.time.difference(realStartTime).inSeconds;

      double x = getPixelX(seconds, size);
      double y = getPixelY(data.last.value, size);
      endPoint = Offset(x, y);
    }

    if (endPoint != null) {
      /// draw Point
      Paint pointsPaint = new Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8
        ..color = lineColor;
      canvas.drawPoints(dui.PointMode.points, [endPoint], pointsPaint);

      canvas.drawPoints(
          dui.PointMode.points,
          [endPoint],
          Paint()
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4
            ..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _HorizontalSupplePainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final int gridLineAmount;

  final double marginSpace;

  final double timeAreaHeight;

  final SuppleData suppleData;
  final Listenable repaint;

  final List<TextPainter> textPainters = [];

  _HorizontalSupplePainter(
      {@required this.minValue,
      @required this.maxValue,
      @required this.gridLineAmount,
      @required this.suppleData,
      this.marginSpace,
      this.repaint,
      this.timeAreaHeight})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (textPainters.isEmpty) {
      prepareTextPainter();
    }

    var gridPaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    var fillTextPaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    var textBorderPaint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final totalDist = maxValue - minValue;
    double normalizer =
        (size.height - 2 * marginSpace - timeAreaHeight) / totalDist;

    var dy;

    var offset;

    final values = [
      suppleData.cutOff,
      suppleData.takeProfit,
      suppleData.underOrder,
      suppleData.current
    ];

    final colors = [
      Color.fromARGB(255, 0, 196, 75),
      Color.fromARGB(255, 248, 54, 0),
      Color.fromARGB(255, 255, 139, 61),
      Color.fromARGB(255, 46, 149, 236),
    ];

    values.asMap().forEach((index, value) {
      if (value != null) {
        var textWidth = textPainters[index].width + 20;
        var textHeight = textPainters[index].height + 6;

        offset = value - minValue;
        gridPaint.color = colors[index];
        fillTextPaint.color = colors[index].withAlpha(30);
        textBorderPaint.color = colors[index];

        if (!suppleData.alwaysShow && (offset < 0 || offset > totalDist)) {
          return;
        }

        if (suppleData.alwaysShow) {
          if (offset < 0) {
            dy = size.height - timeAreaHeight - textHeight / 2;
          } else if (offset > totalDist) {
            dy = textHeight / 2;
          } else {
            dy = size.height -
                timeAreaHeight -
                marginSpace -
                offset * normalizer;
          }
        } else {
          dy = size.height - timeAreaHeight - marginSpace - offset * normalizer;
        }

        canvas.drawLine(
            Offset(0, dy), Offset(size.width - textWidth, dy), gridPaint);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(size.width - textWidth, dy - textHeight / 2,
                    textWidth, textHeight),
                Radius.circular(2)),
            fillTextPaint);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(size.width - textWidth, dy - textHeight / 2,
                    textWidth, textHeight),
                Radius.circular(2)),
            textBorderPaint);
        textPainters[index].paint(canvas,
            Offset(size.width - textWidth + 10, dy - textHeight / 2 + 4));
      }
    });
  }

  prepareTextPainter() {
    var labelStyle = const TextStyle(
        color: Color(0xff666666),
        fontSize: 11.0,
        fontWeight: FontWeight.normal);

    textPainters.add(TextPainter(
        text: new TextSpan(
            text: suppleData.cutOff?.toStringAsFixed(4), style: labelStyle),
        textDirection: TextDirection.ltr)
      ..layout());

    textPainters.add(TextPainter(
        text: new TextSpan(
            text: suppleData.takeProfit?.toStringAsFixed(4), style: labelStyle),
        textDirection: TextDirection.ltr)
      ..layout());
    textPainters.add(TextPainter(
        text: new TextSpan(
            text: suppleData.underOrder?.toStringAsFixed(4), style: labelStyle),
        textDirection: TextDirection.ltr)
      ..layout());
    textPainters.add(TextPainter(
        text: new TextSpan(
            text: suppleData.current?.toStringAsFixed(4), style: labelStyle),
        textDirection: TextDirection.ltr)
      ..layout());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _VerticalSupplePainter extends CustomPainter {
  final DateTime startTime;
  final DateTime endTime;
  final SuppleData suppleData;

  final double timeAreaHeight;
  final List<dui.Image> images;
  final Listenable repaint;

  _VerticalSupplePainter(
      {@required this.startTime,
      @required this.endTime,
      @required this.suppleData,
      @required this.timeAreaHeight,
      this.repaint,
      this.images})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    var gridPaint = Paint()
      ..color = Color.fromARGB(255, 249, 212, 35)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final normalizer = size.width / (endTime.difference(startTime).inSeconds);

    var dx;
    if (suppleData == null) {
      return;
    }

    /// stop
    if (suppleData.stopTime != null &&
        suppleData.stopTime.isAfter(startTime) &&
        suppleData.stopTime.isBefore(endTime)) {
      dx = (suppleData.stopTime.difference(startTime).inSeconds) * normalizer;
      canvas.drawLine(
          Offset(dx, 0), Offset(dx, size.height - timeAreaHeight), gridPaint);
      canvas.drawImage(
          images[0],
          Offset(dx - images[0].width / 2,
              size.height - timeAreaHeight / 2 - images[0].height + 2),
          Paint());
    }

    ///over
    if (suppleData.endTime != null &&
        suppleData.endTime.isAfter(startTime) &&
        suppleData.endTime.isBefore(endTime)) {
      dx = (suppleData.endTime.difference(startTime).inSeconds) * normalizer;
      canvas.drawLine(
          Offset(dx, 0), Offset(dx, size.height - timeAreaHeight), gridPaint);
      canvas.drawImage(
          images[1],
          Offset(dx - images[1].width / 2,
              size.height - timeAreaHeight / 2 - images[1].height + 2),
          Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
