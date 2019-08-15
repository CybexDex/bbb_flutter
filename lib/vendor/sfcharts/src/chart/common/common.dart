part of charts;

class _CustomPaintStyle {
  _CustomPaintStyle(this.strokeWidth, this.color, this.paintStyle);
  Color color;
  double strokeWidth;
  PaintingStyle paintStyle;
}

class _AxisSize {
  _AxisSize(this.axis, this.size);
  num size;
  ChartAxis axis;
}

/// Holds the series index and point index for selection.
class IndexesModel {
  IndexesModel(this.pointIndex, this.seriesIndex);

  ///Index of the data point to be selected.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///         initialSelectedDataIndexes: <IndexesModel>[IndexesModel(2, 0)],
  ///      );
  ///}
  ///```
  final int pointIndex;

  ///Index of the series to be selected.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///         initialSelectedDataIndexes: <IndexesModel>[IndexesModel(2, 0)],
  ///      );
  ///}
  ///```
  final int seriesIndex;
}

/// Customizes the interactive tooltip.
class InteractiveTooltip {
  InteractiveTooltip(
      {this.enable = true,
      this.color,
      this.borderColor,
      this.borderWidth = 0,
      this.borderRadius = 5,
      this.arrowLength = 7,
      this.arrowWidth = 5,
      this.format,
      ChartTextStyle textStyle})
      : textStyle = textStyle ?? ChartTextStyle();

  ///Toggles the visibility of the interactive tooltip in an axis. This tooltip will be displayed at the axis for crosshair and will be displayed near to the track line for trackball.
  ///
  ///Defaults to true
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(enable:false)),
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Color of the interactive tooltip.
  ///
  ///Defaults to null
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             color:Colors.grey)),
  ///        ));
  ///}
  ///```
  final Color color;

  ///Border color of the interactive tooltip.
  ///
  ///Defaults to Colors.black
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:2)),
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the interactive tooltip.
  ///
  ///Defaults to 0.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:2)),
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Customizes the text in the interactive tooltip.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             textStyle: ChartTextStyle(color:Colors.red))),
  ///        ));
  ///}
  ///```
  final ChartTextStyle textStyle;

  ///Customizes the corners of the interactive tooltip. Each corner can be customized
  ///with a desired value or with a single value.
  ///
  ///Defaults to Radius.zero
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:3,
  ///             borderRadius:2)),
  ///        ));
  ///}
  ///```
  final double borderRadius;

  ///Length of the tooltip arrow.
  ///
  ///Defaults to 7
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             arrowLength:4)),
  ///        ));
  ///}
  ///```
  final double arrowLength;

  ///Width of the tooltip arrow.
  ///
  ///Defaults to 5
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             arrowWidth:4)),
  ///        ));
  ///}
  ///```
  final double arrowWidth;

  ///Text format of the interactive tooltip.
  ///
  /// By default, axis value will be displayed in the tooltip, and it can be customized by
  /// adding desired text as prefix or suffix.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             format:'point.x %')),
  ///        ));
  ///}
  ///```
  final String format;
}

/// To get cartesian type data label saturation color
Color _getDataLabelSaturationColor(_CartesianChartPoint<dynamic> currentPoint,
    XyDataSeries<dynamic, dynamic> series, SfCartesianChart chart) {
  Color color;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  final CartesianLabelPosition labelPosition = dataLabel.position;
  final ChartAlignment alignment = dataLabel.alignment;
  final String _seriesType = series._seriesType == 'line' ||
          series._seriesType == 'spline' ||
          series._seriesType == 'stepline'
      ? 'Line'
      : series._isRectSeries || series._seriesType == 'area'
          ? 'Column'
          : series._seriesType == 'bubble' || series._seriesType == 'scatter'
              ? 'Circle'
              : 'Default';
  switch (_seriesType) {
    case 'Line':
      color = _getOuterDataLabelColor(
          dataLabel, chart.plotAreaBackgroundColor, chart._chartTheme);
      break;
    case 'Column':
      if (!currentPoint.dataLabelSaturationRegionInside &&
          ((labelPosition == CartesianLabelPosition.outer &&
                  alignment != ChartAlignment.near) ||
              (labelPosition == CartesianLabelPosition.top &&
                  alignment == ChartAlignment.far) ||
              labelPosition == CartesianLabelPosition.auto &&
                  series._seriesType != 'area')) {
        color = _getOuterDataLabelColor(
            dataLabel, chart.plotAreaBackgroundColor, chart._chartTheme);
      } else {
        color =
            _getInnerDataLabelColor(currentPoint, series, chart._chartTheme);
      }
      break;
    case 'Circle':
      if (labelPosition == CartesianLabelPosition.middle &&
              alignment == ChartAlignment.center ||
          labelPosition == CartesianLabelPosition.bottom &&
              alignment == ChartAlignment.far ||
          labelPosition == CartesianLabelPosition.top &&
              alignment == ChartAlignment.near ||
          labelPosition == CartesianLabelPosition.outer &&
              alignment == ChartAlignment.near) {
        color =
            _getInnerDataLabelColor(currentPoint, series, chart._chartTheme);
      } else {
        color = _getOuterDataLabelColor(
            dataLabel, chart.plotAreaBackgroundColor, chart._chartTheme);
      }
      break;
    default:
      color = Colors.white;
  }
  return _getSaturationColor(color);
}

/// To get outer data label color
Color _getOuterDataLabelColor(DataLabelSettings dataLabel,
        Color backgroundColor, _ChartTheme theme) =>
    dataLabel.color != null
        ? dataLabel.color
        : backgroundColor != null
            ? backgroundColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

///To get inner data label
Color _getInnerDataLabelColor(_CartesianChartPoint<dynamic> currentPoint,
    CartesianSeries<dynamic, dynamic> series, _ChartTheme theme) {
  Color innerColor;
  final dynamic dataLabel = series.dataLabelSettings;
  innerColor = dataLabel.color != null
      ? dataLabel.color
      : currentPoint.pointColorMapper != null
          ? currentPoint.pointColorMapper
          : series.color != null
              ? series.color
              : series._seriesColor != null
                  ? series._seriesColor
                  : theme.brightness == Brightness.light
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : Colors.black;
  return innerColor;
}

// To animate column series
void _animateColumnSeries(Canvas canvas, XyDataSeries<dynamic, dynamic> series,
    Paint fillPaint, RRect segmentRect, num yPoint, double animationFactor) {
  double factor;
  if (series._chart.isTransposed) {
    factor = segmentRect.width * animationFactor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                series._yAxis.isInversed
                    ? yPoint < 0 ? segmentRect.left : segmentRect.right - factor
                    : yPoint < 0
                        ? segmentRect.right - factor
                        : segmentRect.left,
                segmentRect.top,
                series._yAxis.isInversed
                    ? yPoint < 0 ? segmentRect.left + factor : segmentRect.right
                    : yPoint < 0
                        ? segmentRect.right
                        : segmentRect.left + factor,
                segmentRect.bottom),
            segmentRect.blRadius),
        fillPaint);
  } else {
    final double height = segmentRect.height * animationFactor;
    double top;
    if (!series._yAxis.isInversed) {
      top = yPoint < 0
          ? segmentRect.top
          : (segmentRect.top + segmentRect.height) - height;
    } else {
      top = yPoint < 0
          ? (segmentRect.top + segmentRect.height) - height
          : segmentRect.top;
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(segmentRect.left, top, segmentRect.width, height),
            segmentRect.blRadius),
        fillPaint);
  }
}

// To animate bar series
void _animateBarSeries(Canvas canvas, XyDataSeries<dynamic, dynamic> series,
    Paint fillPaint, RRect segmentRect, num yPoint, double animationFactor) {
  double factor;
  if (series._chart.isTransposed) {
    factor = segmentRect.height * animationFactor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                segmentRect.left,
                series._yAxis.isInversed
                    ? segmentRect.top
                    : yPoint < 0
                        ? segmentRect.top
                        : segmentRect.bottom - factor,
                segmentRect.width,
                series._yAxis.isInversed
                    ? yPoint < 0
                        ? (segmentRect.height)
                        : (segmentRect.height * animationFactor)
                    : yPoint < 0
                        ? segmentRect.height
                        : (segmentRect.height * animationFactor)),
            segmentRect.blRadius),
        fillPaint);
  } else {
    factor = segmentRect.width * animationFactor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(
                series._yAxis.isInversed
                    ? yPoint < 0 ? segmentRect.left : segmentRect.right - factor
                    : yPoint < 0
                        ? segmentRect.right - factor
                        : segmentRect.left,
                segmentRect.top,
                series._yAxis.isInversed
                    ? yPoint < 0 ? segmentRect.left + factor : segmentRect.right
                    : yPoint < 0
                        ? segmentRect.right
                        : segmentRect.left + factor,
                segmentRect.bottom),
            segmentRect.blRadius),
        fillPaint);
  }
}

// To animate scatter series
void _animateScatterSeries(
    CartesianSeries<dynamic, dynamic> series,
    _CartesianChartPoint<dynamic> point,
    double animationFactor,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint) {
  final num width = series.markerSettings.width,
      height = series.markerSettings.height;
  final DataMarkerType markerType = series.markerSettings.shape;
  final Path path = Path();
  {
    switch (markerType) {
      case DataMarkerType.circle:
        {
          _ChartShapeUtils.drawCircle(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.rectangle:
        {
          _ChartShapeUtils.drawRectangle(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;
      case DataMarkerType.image:
        {}
        break;
      case DataMarkerType.pentagon:
        {
          _ChartShapeUtils.drawPentagon(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.verticalLine:
        {
          _ChartShapeUtils.drawVerticalLine(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.invertedTriangle:
        {
          _ChartShapeUtils.drawInvertedTriangle(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.horizontalLine:
        {
          _ChartShapeUtils.drawHorizontalLine(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.diamond:
        {
          _ChartShapeUtils.drawDiamond(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;

      case DataMarkerType.triangle:
        {
          _ChartShapeUtils.drawTriangle(
              path,
              point.markerPoint.x,
              point.markerPoint.y,
              animationFactor * width,
              animationFactor * height);
        }
        break;
    }
  }
  canvas.drawPath(path, strokePaint);
  canvas.drawPath(path, fillPaint);
}

// To animate linear type animation
void _performLinearAnimation(XyDataSeries<dynamic, dynamic> series,
    Canvas canvas, double animationFactor) {
  series._chart.isTransposed
      ? canvas.clipRect(Rect.fromLTRB(
          0,
          series._xAxis.isInversed
              ? 0
              : (1 - animationFactor) *
                  series._chart._chartAxis._axisClipRect.bottom,
          series._chart._chartAxis._axisClipRect.left +
              series._chart._chartAxis._axisClipRect.width,
          series._xAxis.isInversed
              ? animationFactor *
                  (series._chart._chartAxis._axisClipRect.top +
                      series._chart._chartAxis._axisClipRect.height)
              : series._chart._chartAxis._axisClipRect.top +
                  series._chart._chartAxis._axisClipRect.height))
      : canvas.clipRect(Rect.fromLTRB(
          series._xAxis.isInversed
              ? (1 - animationFactor) *
                  (series._chart._chartAxis._axisClipRect.right)
              : 0,
          0,
          series._xAxis.isInversed
              ? series._chart._chartAxis._axisClipRect.left +
                  series._chart._chartAxis._axisClipRect.width
              : animationFactor *
                  (series._chart._chartAxis._axisClipRect.left +
                      series._chart._chartAxis._axisClipRect.width),
          series._chart._chartAxis._axisClipRect.top +
              series._chart._chartAxis._axisClipRect.height));
}

// To get nearest chart points from the touch point
List<dynamic> _getNearestChartPoints(
    double pointX,
    double pointY,
    ChartAxis actualXAxis,
    ChartAxis actualYAxis,
    XyDataSeries<dynamic, dynamic> cartesianSeries,
    [List<dynamic> firstNearestDataPoints]) {
  final List<dynamic> dataPointList = <dynamic>[];
  List<dynamic> dataList = <dynamic>[];
  final List<num> xValues = <num>[];
  final List<num> yValues = <num>[];

  firstNearestDataPoints != null
      ? dataList = firstNearestDataPoints
      : dataList = cartesianSeries._dataPoints;

  for (int i = 0; i < dataList.length; i++) {
    xValues.add(dataList[i].xValue);
    yValues.add(dataList[i].yValue);
  }
  num nearPointX = actualXAxis._visibleRange.minimum;

  final Rect rect = _calculatePlotOffset(
      cartesianSeries._chart._chartAxis._axisClipRect,
      Offset(cartesianSeries._xAxis.plotOffset,
          cartesianSeries._yAxis.plotOffset));

  final num touchXValue = _pointToXValue(cartesianSeries._chart, actualXAxis,
      actualXAxis._bounds, pointX - rect.left, pointY - rect.top);
  double delta = 0;
  for (int i = 0; i < dataList.length; i++) {
    final double currX = xValues[i].toDouble();
    if (delta == touchXValue - currX) {
      final _CartesianChartPoint<dynamic> dataPoint = dataList[i];
      if (dataPoint.isDrop != true && dataPoint.isGap != true) {
        dataPointList.add(dataPoint);
      }
    } else if ((touchXValue - currX).abs() <=
        (touchXValue - nearPointX).abs()) {
      nearPointX = currX;
      delta = touchXValue - currX;
      final _CartesianChartPoint<dynamic> dataPoint = dataList[i];
      dataPointList.clear();
      if (dataPoint.isDrop != true && dataPoint.isGap != true) {
        dataPointList.add(dataPoint);
      }
    }
  }
  return dataPointList;
}

ZoomPanArgs _zoomEvent(SfCartesianChart chart, dynamic axis,
    ZoomPanArgs zoomPanArgs, ChartZoomingCallback zoomEventType) {
  zoomPanArgs = ZoomPanArgs();
  zoomPanArgs.axis = axis;
  zoomPanArgs.currentZoomFactor = axis._zoomFactor;
  zoomPanArgs.currentZoomPosition = axis._zoomPosition;
  zoomPanArgs.previousZoomFactor = axis._previousZoomFactor;
  zoomPanArgs.previousZoomPosition = axis._previousZoomPosition;
  zoomEventType == chart.onZoomStart
      ? chart.onZoomStart(zoomPanArgs)
      : zoomEventType == chart.onZoomEnd
          ? chart.onZoomEnd(zoomPanArgs)
          : zoomEventType == chart.onZooming
              ? chart.onZooming(zoomPanArgs)
              : chart.onZoomReset(zoomPanArgs);

  return zoomPanArgs;
}
