part of charts;

/// Creates the segments for area series.
class AreaSegment extends ChartSegment {
  Path _path, _strokePath;
  Rect _pathRect;

  ///Area series
  XyDataSeries<dynamic, dynamic> series;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    fillPaint = Paint();
    if (series.gradient == null) {
      if (color != null) {
        fillPaint.color = color;
        fillPaint.style = PaintingStyle.fill;
        _defaultFillColor = fillPaint;
      }
    } else {
      fillPaint = _getLinearGradientPaint(
          series.gradient, _pathRect, series._chart._requireInvertedAxis);
    }
    fillPaint.color = fillPaint.color.withOpacity(series.opacity);
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (strokeColor != null) {
      strokePaint
        ..color = series.borderColor.withOpacity(series.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = series.borderWidth;
      series.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color;
    }
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final Rect rect = series._chart._chartAxis._axisClipRect;
    _CartesianChartPoint<dynamic> prevPoint;
    _ChartLocation currentPoint, originPoint;
    final ChartAxis xAxis = series._xAxis;
    final ChartAxis yAxis = series._yAxis;
    _CartesianChartPoint<dynamic> point;
    _path = Path();
    _strokePath = Path();
    for (int pointIndex = 0;
        pointIndex < series._dataPoints.length;
        pointIndex++) {
      point = series._dataPoints[pointIndex];
      if (point.isVisible) {
        currentPoint = _calculatePoint(point.xValue, point.yValue, xAxis, yAxis,
            series._chart._requireInvertedAxis, series, rect);
        originPoint = _calculatePoint(
            point.xValue,
            math_lib.max(yAxis._visibleRange.minimum, 0),
            xAxis,
            yAxis,
            series._chart._requireInvertedAxis,
            series,
            rect);

        if (prevPoint == null ||
            series._dataPoints[pointIndex - 1].isGap == true ||
            (series._dataPoints[pointIndex].isGap == true) ||
            (series._dataPoints[pointIndex - 1].isVisible == false &&
                series.emptyPointSettings.mode == EmptyPointMode.gap)) {
          _path.moveTo(originPoint.x, originPoint.y);
          _strokePath.moveTo(currentPoint.x, currentPoint.y);
          _path.lineTo(currentPoint.x, currentPoint.y);
        } else if (pointIndex == series._dataPoints.length - 1 ||
            series._dataPoints[pointIndex + 1].isGap == true) {
          _strokePath.lineTo(currentPoint.x, currentPoint.y);
          _path.lineTo(currentPoint.x, currentPoint.y);
          _path.lineTo(originPoint.x, originPoint.y);
        } else {
          _strokePath.lineTo(currentPoint.x, currentPoint.y);
          _path.lineTo(currentPoint.x, currentPoint.y);
        }
        prevPoint = point;
      }
    }
    final AreaSeries<dynamic, dynamic> areaSeries = series;
    if (areaSeries.borderMode == AreaBorderMode.all) {
      _path.close();
      _strokePath = _path;
    } else if (areaSeries.borderMode == AreaBorderMode.excludeBottom) {
      _strokePath = _path;
    }
    _pathRect = _path.getBounds();
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer
        ._checkWithSelectionState(series.segments[0], series._chart);
    canvas.drawPath(_path, fillPaint);
    if (strokePaint.color != Colors.transparent)
      _drawDashedLine(canvas, series, strokePaint, _strokePath);
  }
}
