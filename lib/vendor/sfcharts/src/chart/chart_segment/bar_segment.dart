part of charts;

/// Creates the segments for bar series.
class BarSegment extends ChartSegment {
  num x1, y1, x2, y2;
  BorderRadius _borderRadius;
  RRect _trackBarRect;
  _CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = series.pointColorMapper != null ? true : false;
    if (series.gradient == null) {
      if (color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : (hasPointColor ? _currentPoint.pointColorMapper : color)
          ..style = PaintingStyle.fill;
        _defaultFillColor = fillPaint;
      }
    } else {
      fillPaint = _getLinearGradientPaint(series.gradient, _currentPoint.region,
          series._chart._requireInvertedAxis);
    }
    fillPaint.color = fillPaint.color.withOpacity(series.opacity);
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    strokePaint = Paint()
      ..color = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderColor
          : strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : strokeWidth;
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final BarSeries<dynamic, dynamic> barSeries = series;
    if (color != null) {
      _trackerFillPaint = Paint()
        ..color = barSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final BarSeries<dynamic, dynamic> barSeries = series;
    _trackerStrokePaint = Paint()
      ..color = barSeries.trackBorderColor
      ..strokeWidth = barSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    barSeries.trackBorderWidth == 0
        ? _trackerStrokePaint.color = Colors.transparent
        : _trackerStrokePaint.color;
    return _trackerStrokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final BarSeries<dynamic, dynamic> barSeries = series;
    _borderRadius = barSeries.borderRadius;
    if (_currentPoint.region != null) {
      segmentRect = RRect.fromRectAndCorners(
        _currentPoint.region,
        bottomLeft: _borderRadius.bottomLeft,
        bottomRight: _borderRadius.bottomRight,
        topLeft: _borderRadius.topLeft,
        topRight: _borderRadius.topRight,
      );
      //Tracker rect
      if (barSeries.isTrackVisible) {
        _trackBarRect = RRect.fromRectAndCorners(
          _currentPoint.trackerRectRegion,
          bottomLeft: _borderRadius.bottomLeft,
          bottomRight: _borderRadius.bottomRight,
          topLeft: _borderRadius.topLeft,
          topRight: _borderRadius.topRight,
        );
      }
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final BarSeries<dynamic, dynamic> barSeries = series;
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    if (_trackerFillPaint != null && barSeries.isTrackVisible) {
      canvas.drawRRect(_trackBarRect, _trackerFillPaint);
    }
    if (_trackerStrokePaint != null && barSeries.isTrackVisible) {
      canvas.drawRRect(_trackBarRect, _trackerStrokePaint);
    }

    if (fillPaint != null) {
      series.animationDuration > 0
          ? _animateBarSeries(canvas, series, fillPaint, segmentRect,
              _currentPoint.yValue, animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint);
    }
    if (strokePaint != null) {
      series.animationDuration > 0
          ? _animateBarSeries(canvas, series, strokePaint, segmentRect,
              _currentPoint.yValue, animationFactor)
          : canvas.drawRRect(segmentRect, strokePaint);
    }
  }

  /// Method to set data.
  void _setData(List<num> values) {
    x1 = values[0];
    y1 = values[1];
  }
}
