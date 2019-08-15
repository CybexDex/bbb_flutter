part of charts;

void _calculateSeriesRegion(SfCartesianChart chartBase, int index) {
  final SfCartesianChart chart = chartBase;
  final List<Color> palette = chart.palette;
  final XyDataSeries<dynamic, dynamic> series =
      chart._chartSeries.visibleSeries[index];
  series._chart = chartBase;
  series._seriesColor = series.color ??
      palette[index % palette.length]; // sets default color for series.
  final ChartAxis xAxis = series._xAxis;
  final ChartAxis yAxis = series._yAxis;
  final Rect rect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
      Offset(xAxis.plotOffset, yAxis.plotOffset));
  series._isRectSeries =
      (series._seriesType == 'column' || series._seriesType == 'bar')
          ? true
          : false;
  series._regionalData = <dynamic, dynamic>{};
  _CartesianChartPoint<dynamic> point;
  _ChartLocation currentPoint;
  final num markerHeight = series.markerSettings.height,
      markerWidth = series.markerSettings.width;
  final dynamic tempSize = <dynamic>[];
  double bubbleSize;
  final bool isPointSeries =
      (series._seriesType == 'scatter' || series._seriesType == 'bubble')
          ? true
          : false;
  final bool isFastLine = (series._seriesType == 'fastline') ? true : false;

  if (series._seriesType == 'bubble') {
    for (int pointIndex = 0;
        pointIndex < series._dataPoints.length;
        pointIndex++) {
      point = series._dataPoints[pointIndex];
      bubbleSize = ((point.bubbleSize) ?? 4).toDouble();
      tempSize.add(bubbleSize.abs());
    }
    tempSize.sort();
  }
  if ((!isFastLine ||
          (isFastLine &&
              (series.markerSettings.isVisible ||
                  series.dataLabelSettings.isVisible ||
                  series.enableTooltip))) &&
      series._visible) {
    for (int pointIndex = 0;
        pointIndex < series._dataPoints.length;
        pointIndex++) {
      point = series._dataPoints[pointIndex];
      if (series._isRectSeries) {
        /// side by side range calculated
        final _VisibleRange sideBySideInfo =
            _calculateSideBySideInfo(series, chart);
        final num origin = math.max(yAxis._visibleRange.minimum, 0);

        /// Get the rectangle based on points
        final Rect rect = _calculateRectangle(
            point.xValue + sideBySideInfo.minimum,
            point.yValue,
            point.xValue + sideBySideInfo.maximum,
            origin,
            series,
            chart);
        point.region = rect;

        ///Get shadow rect region
        final Rect shadowPointRect = _calculateShadowRectangle(
            point.xValue + sideBySideInfo.minimum,
            point.yValue,
            point.xValue + sideBySideInfo.maximum,
            origin,
            series,
            chart,
            Offset(xAxis?.plotOffset, yAxis?.plotOffset));
        point.trackerRectRegion = shadowPointRect;
        point.markerPoint = chart._requireInvertedAxis != true
            ? (yAxis.isInversed
                ? (point.yValue.isNegative
                    ? _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
                    : _ChartLocation(
                        rect.bottomCenter.dx, rect.bottomCenter.dy))
                : (point.yValue.isNegative
                    ? _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
                    : _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)))
            : (yAxis.isInversed
                ? (point.yValue.isNegative
                    ? _ChartLocation(rect.centerRight.dx, rect.centerRight.dy)
                    : _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy))
                : (point.yValue.isNegative
                    ? _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy)
                    : _ChartLocation(
                        rect.centerRight.dx, rect.centerRight.dy)));
      } else if (isPointSeries) {
        /// Get the location of current point.
        currentPoint = _calculatePoint(point.xValue, point.yValue, xAxis, yAxis,
            chartBase._requireInvertedAxis, series, rect);
        point.markerPoint = currentPoint;
        if (series._seriesType == 'scatter') {
          point.region = Rect.fromLTRB(
              currentPoint.x - series.markerSettings.width,
              currentPoint.y - series.markerSettings.width,
              currentPoint.x + series.markerSettings.width,
              currentPoint.y + series.markerSettings.width);
        } else {
          final BubbleSeries<dynamic, dynamic> bubbleSeries = series;
          num bubbleRadius, sizeRange, radiusRange, maxSize, minSize;
          maxSize = tempSize[tempSize.length - 1];
          minSize = tempSize[0];
          sizeRange = maxSize - minSize;
          bubbleSize = ((point.bubbleSize) ?? 4).toDouble();
          if (bubbleSeries.sizeValueMapper == null)
            bubbleSeries.minimumRadius != null
                ? bubbleRadius = bubbleSeries.minimumRadius
                : bubbleRadius = bubbleSeries.maximumRadius;
          else {
            if ((bubbleSeries.maximumRadius != null) &&
                (bubbleSeries.minimumRadius != null)) {
              if (sizeRange == 0)
                bubbleRadius = bubbleSeries.maximumRadius;
              else {
                radiusRange =
                    (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) *
                        2;
                bubbleRadius =
                    (((bubbleSize.abs() - minSize) * radiusRange) / sizeRange) +
                        bubbleSeries.minimumRadius;
              }
            }
          }
          point.region = Rect.fromLTRB(
              currentPoint.x - 2 * bubbleRadius,
              currentPoint.y - 2 * bubbleRadius,
              currentPoint.x + 2 * bubbleRadius,
              currentPoint.y + 2 * bubbleRadius);
        }
      } else {
        /// Get the location of current point.
        currentPoint = _calculatePoint(point.xValue, point.yValue, xAxis, yAxis,
            chartBase._requireInvertedAxis, series, rect);
        point.region = Rect.fromLTWH(currentPoint.x - markerWidth,
            currentPoint.y - markerHeight, 2 * markerWidth, 2 * markerHeight);
        point.markerPoint = currentPoint;
      }
      // For tooltip implementation
      if (series.enableTooltip != null &&
          series.enableTooltip &&
          point != null &&
          !point.isGap &&
          !point.isDrop) {
        final List<String> regionData = <String>[];
        String date;
        final List<dynamic> regionRect = <dynamic>[];
        if (xAxis is DateTimeAxis) {
          final DateFormat dateFormat =
              xAxis.dateFormat ?? xAxis._getLabelFormat(xAxis);
          date = dateFormat
              .format(DateTime.fromMillisecondsSinceEpoch(point.xValue));
        }
        xAxis is CategoryAxis
            ? regionData.add(point.x)
            : xAxis is DateTimeAxis
                ? regionData.add(date.toString())
                : regionData
                    .add(_getLabelValue(point.xValue, xAxis).toString());
        regionData.add(_getLabelValue(point.yValue, yAxis).toString());
        regionData.add(series.name);
        regionRect.add(point.region);
        regionRect.add((series._isRectSeries)
            ? point.region.topCenter
            : point.region.center);
        regionRect.add(point.pointColorMapper);
        regionRect.add(point.bubbleSize);
        series._regionalData[regionRect] = regionData;
      }
    }

//      /// Store the marker points before rendering

    if (series._seriesType == 'scatter') {
      series._markerShapes = <Path>[];
      for (int i = 0; i < series._dataPoints.length; i++) {
        final _CartesianChartPoint<dynamic> point = series._dataPoints[i];
        final DataMarkerType markerType = series.markerSettings.shape;
        final Size size =
            Size(series.markerSettings.width, series.markerSettings.height);
        series._markerShapes.add(_getMarkerShapes(markerType,
            Offset(point.markerPoint.x, point.markerPoint.y), size, series));
      }
    } else {
      if (series.markerSettings.isVisible) {
        series._markerShapes = <Path>[];
        for (int i = 0; i < series._dataPoints.length; i++) {
          final _CartesianChartPoint<dynamic> point = series._dataPoints[i];
          final DataMarkerType markerType = series.markerSettings.shape;
          final Size size =
              Size(series.markerSettings.width, series.markerSettings.height);
          series._markerShapes.add(_getMarkerShapes(markerType,
              Offset(point.markerPoint.x, point.markerPoint.y), size, series));
        }
      }
    }
  }
}

void _renderSeriesElements(
  Canvas canvas,
  CartesianSeries<dynamic, dynamic> series, [
  Animation<double> animationController,
  Color scatterColor,
  Color scatterBorderColor,
]) {
  Paint strokePaint;
  Paint fillPaint;
  _CartesianChartPoint<dynamic> point;
  Color _borderColor;
  final bool hasPointColor = (series.pointColorMapper != null) ? true : false;
  final double opacity =
      (animationController != null) ? animationController.value : 1;
  for (int pointIndex = 0;
      pointIndex < series._dataPoints.length;
      pointIndex++) {
    point = series._dataPoints[pointIndex];
    _borderColor = series.markerSettings.borderColor ?? series._seriesColor;
    strokePaint = Paint()
      ..color = point.isEmpty == true
          ? (series.emptyPointSettings.borderWidth == 0
              ? Colors.transparent
              : series.emptyPointSettings.borderColor.withOpacity(opacity))
          : (series.markerSettings.borderWidth == 0
              ? Colors.transparent
              : (hasPointColor
                  ? point.pointColorMapper.withOpacity(opacity)
                  : _borderColor.withOpacity(opacity)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = point.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : series.markerSettings.borderWidth;

    fillPaint = Paint()
      ..color = point.isEmpty == true
          ? series.emptyPointSettings.color
          : series.markerSettings.color.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    final bool isScatter = series is ScatterSeries;

    /// Render marker points
    if (series.markerSettings.isVisible &&
        point.isVisible &&
        point.isGap != true &&
        series._markerShapes != null &&
        series._markerShapes.isNotEmpty &&
        !isScatter) {
      series.drawDataMarker(pointIndex, canvas, fillPaint, strokePaint,
          point.markerPoint.x, point.markerPoint.y);
      if (series.markerSettings.shape == DataMarkerType.image) {
        _loadImage(series, canvas, fillPaint, point.region.center.dx,
            point.region.center.dy);
      }
    }
  }

  /// Render dataLabels
  if (series.dataLabelSettings.isVisible &&
      series.dataLabelSettings.builder == null) {
    for (dynamic Point in series._dataPoints) {
      if (series.dataLabelSettings != null) {
        _drawDataLabel(canvas, series, series._chart, series.dataLabelSettings,
            Point, series._dataPoints.indexOf(Point), animationController);
      }
    }
  }
}

/// Load image from asset to render marker
void _loadImage(CartesianSeries<dynamic, dynamic> series, Canvas canvas,
    Paint fillPaint, double pointX, double pointY) {
  if (series.markerSettings._image != null) {
    final double imageWidth = 2 * series.markerSettings.width;
    final double imageHeight = 2 * series.markerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    canvas.drawImageNine(
        series.markerSettings._image, positionRect, positionRect, fillPaint);
  }
}

/// This method is for to calculate and rendering the length and Offsets of the dashed lines
void _drawDashedLine(Canvas canvas, CartesianSeries<dynamic, dynamic> series,
    Paint paint, Path path,
    [List<Path> pathList, List<Color> colorList]) {
  bool even = false;
  for (int i = 1; i < series.dashArray.length; i = i + 2) {
    if (series.dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false) {
    paint.isAntiAlias = false;
    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(series.dashArray),
        ),
        paint);
  } else
    canvas.drawPath(path, paint);
}
