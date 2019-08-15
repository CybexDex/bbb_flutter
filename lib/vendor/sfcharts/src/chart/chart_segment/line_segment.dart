part of charts;

/// Creates the segments for line series.
class LineSegment extends ChartSegment {
  num x1, y1, x2, y2, _x1Pos, _y1Pos, _x2Pos, _y2Pos;
  Color _pointColorMapper;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (color != null) {
      fillPaint.color = _pointColorMapper ?? color.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = strokeWidth;
    fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (series.gradient == null) {
      if (strokeColor != null) {
        strokePaint.color =
            _pointColorMapper ?? strokeColor.withOpacity(series.opacity);
      }
    } else {
      strokePaint.color = series.gradient.colors[0];
    }
    strokePaint.strokeWidth = strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final dynamic start = series._xAxis._visibleRange.minimum;
    final dynamic end = series._xAxis._visibleRange.maximum;
    x1 = y1 = x2 = y2 = double.nan;
    final Rect rect = _calculatePlotOffset(
        series._chart._chartAxis._axisClipRect,
        Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    if ((_x1Pos != null &&
            _x2Pos != null &&
            _y1Pos != null &&
            _y2Pos != null) &&
        ((_x1Pos >= start && _x1Pos <= end) ||
            (_x2Pos >= start && _x2Pos <= end) ||
            (start >= _x1Pos && start <= _x2Pos))) {
      final _ChartLocation currentChartPoint = _calculatePoint(
          _x1Pos,
          _y1Pos,
          series._xAxis,
          series._yAxis,
          series._chart._requireInvertedAxis,
          series,
          rect);
      final _ChartLocation nextPoint = _calculatePoint(
          _x2Pos,
          _y2Pos,
          series._xAxis,
          series._yAxis,
          series._chart._requireInvertedAxis,
          series,
          rect);
      x1 = currentChartPoint.x;
      y1 = currentChartPoint.y;
      x2 = nextPoint.x;
      y2 = nextPoint.y;
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        series.segments[currentSegmentIndex], series._chart);
    final Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    _drawDashedLine(canvas, series, strokePaint, path);

    if (currentSegmentIndex == -1 && series.enableTooltip==false) {
      final double labelPadding = 5;

      final Paint bottomLinePaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final Path bottomLinePath = Path();

      double start = x1 + 20;

      bottomLinePath.moveTo(0, y1);
      bottomLinePath.lineTo(start, y1);

      canvas.drawPath(
          _dashPath(
            bottomLinePath,
            dashArray: _CircularIntervalList<double>(<double>[15, 3, 3, 3]),
          ),
          bottomLinePaint);

      final TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.blueAccent, fontSize: 12.0, fontFamily: 'Roboto'),
        text: 'Current',
      );
      final TextPainter tp =
      TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas, Offset(start + labelPadding, y1-7));
    }
  }

  /// Method to set data.
  void _setData(List<num> values) {
    _x1Pos = values[0];
    _y1Pos = values[1];
    _x2Pos = values[2];
    _y2Pos = values[3];
  }
}
