part of charts;

num _percentToValue(String value, num size) {
  if (value != null) {
    return value.contains('%')
        ? (size / 100) * num.tryParse(value.replaceAll(RegExp('%'), ''))
        : num.tryParse(value);
  }
  return null;
}

/// Convert degree to radian
num _degreesToRadians(num deg) {
  return deg * (pi / 180);
}

Path _getArcPath(num innerRadius, num radius, Offset center, num startAngle,
    num endAngle, num degree, SfCircularChart chart, bool isAnimate) {
  final Path path = Path();
  startAngle = _degreesToRadians(startAngle);
  endAngle = _degreesToRadians(endAngle);
  degree = _degreesToRadians(degree);

  final Point<double> innerRadiusStartPoint = Point<double>(
      innerRadius * cos(startAngle) + center.dx,
      innerRadius * sin(startAngle) + center.dy);
  final Point<double> innerRadiusEndPoint = Point<double>(
      innerRadius * cos(endAngle) + center.dx,
      innerRadius * sin(endAngle) + center.dy);

  final Point<double> radiusStartPoint = Point<double>(
      radius * cos(startAngle) + center.dx,
      radius * sin(startAngle) + center.dy);

  if (isAnimate) {
    path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
  }

  final bool isFullCircle =
      startAngle != null && endAngle != null && endAngle - startAngle == 2 * pi;

  final num midpointAngle = (endAngle + startAngle) / 2;

  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);

  if (isFullCircle) {
    path.arcTo(new Rect.fromCircle(center: center, radius: radius), startAngle,
        midpointAngle - startAngle, true);
    path.arcTo(new Rect.fromCircle(center: center, radius: radius),
        midpointAngle, endAngle - midpointAngle, true);
  } else {
    path.arcTo(Rect.fromCircle(center: center, radius: radius), startAngle,
        degree, true);
  }

  path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);

  if (isFullCircle) {
    path.arcTo(new Rect.fromCircle(center: center, radius: innerRadius),
        endAngle, midpointAngle - endAngle, true);
    path.arcTo(new Rect.fromCircle(center: center, radius: innerRadius),
        midpointAngle, startAngle - midpointAngle, true);
  } else {
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius), endAngle,
        startAngle - endAngle, true);
  }

  path.lineTo(radiusStartPoint.x, radiusStartPoint.y);

  return path;
}

Path _getRoundedCornerArcPath(num innerRadius, num outerRadius, Offset center,
    num startAngle, num endAngle, num degree, CornerStyle cornerStyle) {
  final Path path = Path();

  Offset midPoint;
  num midStartAngle, midEndAngle;
  if (cornerStyle == CornerStyle.startCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    midPoint =
        _degreeToPoint(startAngle, (innerRadius + outerRadius) / 2, center);

    midStartAngle = _degreesToRadians(90 + 90);

    midEndAngle = midStartAngle + _degreesToRadians(180);

    path.addArc(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle);
  }

  path.addArc(Rect.fromCircle(center: center, radius: outerRadius),
      _degreesToRadians(startAngle), _degreesToRadians(endAngle - startAngle));

  if (cornerStyle == CornerStyle.endCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    midPoint =
        _degreeToPoint(endAngle, (innerRadius + outerRadius) / 2, center);

    midStartAngle = _degreesToRadians(endAngle / 2);

    midEndAngle = midStartAngle + _degreesToRadians(180);

    path.arcTo(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle,
        false);
  }

  path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      _degreesToRadians(endAngle),
      _degreesToRadians(startAngle) - _degreesToRadians(endAngle),
      false);

  return path;
}

_Region _getPointRegion(SfCircularChart chart, Offset position) {
  _Region pointRegion;
  const num chartStartAngle = -.5 * pi;
  for (int i = 0; i < chart._chartSeries.visibleSeries.length; i++) {
    final CircularSeries<dynamic, dynamic> series =
        chart._chartSeries.visibleSeries[i];
    for (_Region region in series._pointRegions) {
      final num fromCenterX = position.dx - region.center.dx;
      final num fromCenterY = position.dy - region.center.dy;
      num tapAngle =
          (atan2(fromCenterY, fromCenterX) - chartStartAngle) % (2 * pi);
      num pointStartAngle = region.start - _degreesToRadians(-90);
      num pointEndAngle = region.end - _degreesToRadians(-90);
      if (((region.endAngle + 90) > 360) && (region.startAngle + 90) > 360) {
        pointEndAngle = _degreesToRadians((region.endAngle + 90) % 360);
        pointStartAngle = _degreesToRadians((region.startAngle + 90) % 360);
      } else if ((region.endAngle + 90) > 360) {
        tapAngle = tapAngle > pointStartAngle ? tapAngle : 2 * pi + tapAngle;
      }
      if (tapAngle >= pointStartAngle && tapAngle <= pointEndAngle) {
        final num distanceFromCenter =
            sqrt(pow(fromCenterX.abs(), 2) + pow(fromCenterY.abs(), 2));
        if (distanceFromCenter <= region.outerRadius &&
            distanceFromCenter >= region.innerRadius) {
          pointRegion = region;
        }
      }
    }
  }
  return pointRegion;
}

// Draw the path
void _drawPath(Canvas canvas, _StyleOptions style, Path path) {
  final Paint paint = Paint();
  if (style.fill != null) {
    paint.color = style.fill.withOpacity(style.opacity ?? 1);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }
  if (style.strokeColor != null &&
      style.strokeWidth != null &&
      style.strokeWidth > 0) {
    paint.color = style.strokeColor;
    paint.strokeWidth = style.strokeWidth;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }
}

Offset _degreeToPoint(num degree, num radius, Offset center) {
  degree = _degreesToRadians(degree);
  return Offset(
      center.dx + cos(degree) * radius, center.dy + sin(degree) * radius);
}

// Measure the text and return the text size
Size _measureTextSize(String textValue, ChartTextStyle textStyle, [int angle]) {
  Size size;
  final Color color = textStyle.color;
  final double fontSize = textStyle.fontSize;
  final String fontFamily = textStyle.fontFamily;
  final FontStyle fontStyle = textStyle.fontStyle;
  final FontWeight fontWeight = textStyle.fontWeight;
  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(
        text: textValue,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontStyle: fontStyle,
            fontWeight: fontWeight)),
  );
  textPainter.layout();
  size = Size(textPainter.width, textPainter.height);
  return size;
}

void _needsRepaintCircularChart(
    SfCircularChart chart, SfCircularChart oldChart) {
  if (chart.series.length == oldChart.series.length) {
    for (int seriesIndex = 0;
        seriesIndex < chart.series.length;
        seriesIndex++) {
      _canRepaintSeries(chart, oldChart, seriesIndex);
    }
  } else {
    // ignore: avoid_function_literals_in_foreach_calls
    chart.series.forEach((CircularSeries<dynamic, dynamic> series) =>
        series._needsRepaint = true);
  }
}

void _canRepaintSeries(
    SfCircularChart chart, SfCircularChart oldChart, int seriesIndex) {
  final CircularSeries<dynamic, dynamic> series = chart.series[seriesIndex];
  final CircularSeries<dynamic, dynamic> oldWidgetSeries =
      oldChart.series[seriesIndex];
  if (series._center?.dy != oldWidgetSeries._center?.dy ||
      series._center?.dx != oldWidgetSeries._center?.dx ||
      series.borderWidth != oldWidgetSeries.borderWidth ||
      series.name != oldWidgetSeries.name ||
      series.borderColor?.value != oldWidgetSeries.borderColor?.value ||
      series._currentInnerRadius != oldWidgetSeries._currentInnerRadius ||
      series._currentRadius != oldWidgetSeries._currentRadius ||
      series._start != oldWidgetSeries._start ||
      series._totalAngle != oldWidgetSeries._totalAngle ||
      series._dataPoints?.length != oldWidgetSeries._dataPoints?.length ||
      series.emptyPointSettings.borderWidth !=
          oldWidgetSeries.emptyPointSettings.borderWidth ||
      series.emptyPointSettings.borderColor?.value !=
          oldWidgetSeries.emptyPointSettings.borderColor?.value ||
      series.emptyPointSettings.color?.value !=
          oldWidgetSeries.emptyPointSettings.color?.value ||
      series.emptyPointSettings.mode !=
          oldWidgetSeries.emptyPointSettings.mode ||
      series.dataSource?.length != oldWidgetSeries.dataSource?.length ||
      series.dataLabelSettings.isVisible !=
          oldWidgetSeries.dataLabelSettings.isVisible ||
      series.dataLabelSettings.color?.value !=
          oldWidgetSeries.dataLabelSettings.color?.value ||
      series.dataLabelSettings.borderRadius !=
          oldWidgetSeries.dataLabelSettings.borderRadius ||
      series.dataLabelSettings.borderWidth !=
          oldWidgetSeries.dataLabelSettings.borderWidth ||
      series.dataLabelSettings.borderColor?.value !=
          oldWidgetSeries.dataLabelSettings.borderColor?.value ||
      series.dataLabelSettings.textStyle?.color?.value !=
          oldWidgetSeries.dataLabelSettings.textStyle?.color?.value ||
      series.dataLabelSettings.textStyle?.fontWeight !=
          oldWidgetSeries.dataLabelSettings.textStyle?.fontWeight ||
      series.dataLabelSettings.textStyle?.fontSize !=
          oldWidgetSeries.dataLabelSettings.textStyle?.fontSize ||
      series.dataLabelSettings.textStyle?.fontFamily !=
          oldWidgetSeries.dataLabelSettings.textStyle?.fontFamily ||
      series.dataLabelSettings.textStyle?.fontStyle !=
          oldWidgetSeries.dataLabelSettings.textStyle?.fontStyle ||
      series.dataLabelSettings.labelIntersectAction !=
          oldWidgetSeries.dataLabelSettings.labelIntersectAction ||
      series.dataLabelSettings.labelPosition !=
          oldWidgetSeries.dataLabelSettings.labelPosition ||
      series.dataLabelSettings.connectorLineSettings.color?.value !=
          oldWidgetSeries
              .dataLabelSettings.connectorLineSettings.color?.value ||
      series.dataLabelSettings.connectorLineSettings.width !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.width ||
      series.dataLabelSettings.connectorLineSettings.length !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.length ||
      series.dataLabelSettings.connectorLineSettings.type !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.type ||
      series.xValueMapper != oldWidgetSeries.xValueMapper ||
      series.yValueMapper != oldWidgetSeries.yValueMapper ||
      series.enableTooltip != oldWidgetSeries.enableTooltip) {
    series._needsRepaint = true;
  } else {
    series._needsRepaint = false;
  }
}

void _selectPoint(
    int pointIndex,
    _ChartPoint<dynamic> point,
    SfCircularChart chart,
    bool isAnyPointSelect,
    _Region pointRegion,
    num animationValue) {
  if (chart.initialSelectedDataIndexes.isNotEmpty) {
    for (int i = 0; i < chart.initialSelectedDataIndexes.length; i++) {
      final IndexesModel indexesModel = chart.initialSelectedDataIndexes[i];
      if (indexesModel.pointIndex == pointIndex) {
        point.fill = chart.series[0].selectionSettings.selectedColor;
        point.strokeColor =
            chart.series[0].selectionSettings.selectedBorderColor;
        point.strokeWidth =
            chart.series[0].selectionSettings.selectedBorderWidth;
        if (animationValue >= 1) {
          chart._chartState.selectedDataPoints
              .add(chart.series[0]._dataPoints[pointIndex]);
          chart._chartState.selectedRegions.add(pointRegion);
        }
        break;
      } else if (isAnyPointSelect &&
          i == chart.initialSelectedDataIndexes.length - 1) {
        point.fill = chart.series[0].selectionSettings.unselectedColor;
        point.strokeColor =
            chart.series[0].selectionSettings.unselectedBorderColor;
        point.strokeWidth =
            chart.series[0].selectionSettings.unselectedBorderWidth;
        if (chart._chartState.animateCompleted) {
          chart._chartState.unselectedDataPoints
              .add(chart.series[0]._dataPoints[pointIndex]);
          chart._chartState.unselectedRegions.add(pointRegion);
        }
      }
    }
  }
}

void _checkWithSelectionState(int pointIndex, _ChartPoint<dynamic> point,
    CircularSeries<dynamic, dynamic> series, SfCircularChart chart) {
  bool isSelected = false;
  final List<_Region> selectedRegions = chart._chartState.selectedRegions;
  if (selectedRegions.isNotEmpty) {
    for (int i = 0; i < selectedRegions.length; i++) {
      if (selectedRegions[i].pointIndex == pointIndex) {
        isSelected = true;
        point.fill = series.selectionSettings.selectedColor;
        break;
      }
    }
  }
  final List<_Region> unselectedRegions = chart._chartState.unselectedRegions;
  if (!isSelected && unselectedRegions.isNotEmpty) {
    for (int i = 0; i < unselectedRegions.length; i++) {
      if (unselectedRegions[i].pointIndex == pointIndex) {
        point.fill = series.selectionSettings.unselectedColor;
        break;
      }
    }
  }
}

num _findAngleDeviation(num innerRadius, num outerRadius, num totalAngle) {
  final num calcRadius = (innerRadius + outerRadius) / 2;

  final num circumference = 2 * pi * calcRadius;

  final num rimSize = (innerRadius - outerRadius).abs();

  final num deviation = ((rimSize / 2) / circumference) * 100;

  return (deviation * 360) / 100;
}
