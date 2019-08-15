part of charts;

class _CrosshairPainter extends CustomPainter {
  _CrosshairPainter({this.chart, this.valueNotifier})
      : super(repaint: valueNotifier);
  final SfCartesianChart chart;
  ValueNotifier<int> valueNotifier;
  double pointerLength;
  double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  bool isTop = false;
  double cornerRadius;
  Path backgroundPath = Path();
  bool canResetPath = false;
  bool isLeft = false;
  bool isRight = false;
  bool enable;
  double padding = 0;
  List<String> stringValue = <String>[];
  Rect boundaryRect = Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (!canResetPath) {
      chart.crosshairBehavior.onPaint(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  // calculate trackball points
  void generateAllPoints(Offset position) {
    final Rect seriesBounds = chart._chartAxis._axisClipRect;
    if (seriesBounds.contains(position)) {
      chart.crosshairBehavior._position = position;
    }
  }

  Paint getLinePainter(Paint crosshairLinePaint) {
    return crosshairLinePaint;
  }

  void drawCrosshairLine(Canvas canvas, Paint paint, int index) {
    if (chart.crosshairBehavior._position != null) {
      final Path dashArrayPath = Path();
      if (chart.crosshairBehavior.lineType == CrosshairLineType.both) {
        final Path dashArrayVerticalPath = Path();
        dashArrayVerticalPath.moveTo(chart._chartAxis._axisClipRect.left,
            chart.crosshairBehavior._position.dy);
        dashArrayVerticalPath.lineTo(chart._chartAxis._axisClipRect.right,
            chart.crosshairBehavior._position.dy);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(paint, canvas, dashArrayVerticalPath)
            : canvas.drawPath(dashArrayVerticalPath, paint);
        final Path dashArrayHorizontalPath = Path();
        dashArrayHorizontalPath.moveTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.top);
        dashArrayHorizontalPath.lineTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.bottom);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(paint, canvas, dashArrayHorizontalPath)
            : canvas.drawPath(dashArrayHorizontalPath, paint);
      } else if (chart.crosshairBehavior.lineType ==
          CrosshairLineType.horizontal) {
        dashArrayPath.moveTo(chart._chartAxis._axisClipRect.left,
            chart.crosshairBehavior._position.dy);
        dashArrayPath.lineTo(chart._chartAxis._axisClipRect.right,
            chart.crosshairBehavior._position.dy);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(paint, canvas, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      } else if (chart.crosshairBehavior.lineType ==
          CrosshairLineType.vertical) {
        dashArrayPath.moveTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.bottom);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(paint, canvas, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    }
  }

  void _drawDashedLine(Paint paint, Canvas canvas, Path dashArrayPath) {
    bool even = false;
    for (int i = 1;
        i < chart.crosshairBehavior.lineDashArray.length;
        i = i + 2) {
      if (chart.crosshairBehavior.lineDashArray[i] == 0) {
        even = true;
      }
    }
    if (even == false) {
      paint.isAntiAlias = false;
      canvas.drawPath(
          _dashPath(
            dashArrayPath,
            dashArray: _CircularIntervalList<double>(
                chart.crosshairBehavior.lineDashArray),
          ),
          paint);
    } else {
      canvas.drawPath(dashArrayPath, paint);
    }
  }

  void drawCrosshair(Canvas canvas) {
    const double paddingForRect = 10;
    RRect tooltipRect;
    dynamic value;
    Size labelSize;
    Rect labelRect;
    Rect validatedRect;
    ChartAxis axis;
    Color crosshairLineColor;
    final Paint fillPaint = Paint()
      ..color = chart._chartTheme.crosshairFillColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = chart._chartTheme.crosshairFillColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;
    chart.crosshairBehavior.lineWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Paint crosshairLinePaint = Paint();
    final Path backgroundPath = Path();
    if (chart.crosshairBehavior._position != null) {
      final Offset position = chart.crosshairBehavior._position;
      CrosshairRenderArgs crosshairEventArgs;
      for (int index = 0;
          index < chart._chartAxis._bottomAxesCount.length;
          index++) {
        axis = chart._chartAxis._bottomAxesCount[index].axis;
        if (axis.crosshairTooltip.enable) {
          fillPaint.color = axis.crosshairTooltip.color != null
              ? axis.crosshairTooltip?.color
              : chart._chartTheme.crosshairFillColor;
          strokePaint.color = axis.crosshairTooltip.borderColor != null
              ? axis.crosshairTooltip?.borderColor
              : chart._chartTheme.crosshairFillColor;
          strokePaint.strokeWidth = axis.crosshairTooltip.borderWidth;
          value = _pointToXVal(
              chart,
              axis,
              axis._bounds,
              position.dx -
                  (chart._chartAxis._axisClipRect.left + axis.plotOffset),
              position.dy -
                  (chart._chartAxis._axisClipRect.top + axis.plotOffset));
          value = _getCrosshairLabel(value, axis);
          if (chart.onCrosshairPositionChanging != null) {
            crosshairEventArgs = CrosshairRenderArgs();
            crosshairEventArgs.axis = axis;
            crosshairEventArgs.orientation = axis._orientation;
            crosshairEventArgs.axisName = axis._name;
            crosshairEventArgs.text = value.toString();
            crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
                chart._chartTheme.crosshairLineColor;
            crosshairEventArgs.value = value;
            chart.onCrosshairPositionChanging(crosshairEventArgs);
            value = crosshairEventArgs.text;
            crosshairLineColor = crosshairEventArgs.lineColor;
          }
          labelSize =
              _measureText(value.toString(), axis.crosshairTooltip.textStyle);
          labelRect = Rect.fromLTWH(
              position.dx - (labelSize.width / 2 + paddingForRect / 2),
              axis._bounds.top + axis.crosshairTooltip.arrowLength,
              labelSize.width + paddingForRect,
              labelSize.height + paddingForRect);
          labelRect =
              _validateRectBounds(labelRect, chart._chartState.containerRect);
          validatedRect = _validateRectXPosition(labelRect, chart);
          backgroundPath.reset();
          tooltipRect = _getRoundedCornerRect(
              validatedRect, axis.crosshairTooltip.borderRadius);
          backgroundPath.addRRect(tooltipRect);
          // Arrow head for tooltip
          _drawTooltipArrowhead(
              canvas,
              backgroundPath,
              fillPaint,
              strokePaint,
              position.dx,
              tooltipRect.top - axis.crosshairTooltip.arrowLength,
              (tooltipRect.right - tooltipRect.width / 2) +
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.top,
              (tooltipRect.left + tooltipRect.width / 2) -
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.top,
              position.dx,
              tooltipRect.top - axis.crosshairTooltip.arrowLength);
          _drawText(
              canvas,
              value.toString(),
              Offset(
                  (tooltipRect.left + tooltipRect.width / 2) -
                      labelSize.width / 2,
                  (tooltipRect.top + tooltipRect.height / 2) -
                      labelSize.height / 2),
              ChartTextStyle(
                  color: axis.crosshairTooltip.textStyle.color ??
                      chart._chartTheme.tooltipLabelColor,
                  fontSize: axis.crosshairTooltip.textStyle.fontSize,
                  fontWeight: axis.crosshairTooltip.textStyle.fontWeight,
                  fontFamily: axis.crosshairTooltip.textStyle.fontFamily,
                  fontStyle: axis.crosshairTooltip.textStyle.fontStyle),
              0);
        }
      }
      for (int index = 0;
          index < chart._chartAxis._topAxesCount.length;
          index++) {
        axis = chart._chartAxis._topAxesCount[index].axis;
        if (axis.crosshairTooltip.enable) {
          fillPaint.color = axis.crosshairTooltip.color != null
              ? axis.crosshairTooltip?.color
              : chart._chartTheme.crosshairFillColor;
          strokePaint.color = axis.crosshairTooltip.borderColor != null
              ? axis.crosshairTooltip?.borderColor
              : chart._chartTheme.crosshairFillColor;
          strokePaint.strokeWidth = axis.crosshairTooltip.borderWidth;
          value = _pointToXVal(
              chart,
              axis,
              axis._bounds,
              position.dx -
                  (chart._chartAxis._axisClipRect.left + axis.plotOffset),
              position.dy -
                  (chart._chartAxis._axisClipRect.top + axis.plotOffset));
          value = _getCrosshairLabel(value, axis);
          if (chart.onCrosshairPositionChanging != null) {
            crosshairEventArgs = CrosshairRenderArgs();
            crosshairEventArgs.axis = axis;
            crosshairEventArgs.orientation = axis._orientation;
            crosshairEventArgs.axisName = axis._name;
            crosshairEventArgs.text = value.toString();
            crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
                chart._chartTheme.crosshairLineColor;
            crosshairEventArgs.value = value;
            chart.onCrosshairPositionChanging(crosshairEventArgs);
            value = crosshairEventArgs.text;
            crosshairLineColor = crosshairEventArgs.lineColor;
          }
          labelSize =
              _measureText(value.toString(), axis.crosshairTooltip.textStyle);
          labelRect = Rect.fromLTWH(
              position.dx - (labelSize.width / 2 + paddingForRect / 2),
              axis._bounds.top -
                  (labelSize.height + paddingForRect) -
                  axis.crosshairTooltip.arrowLength,
              labelSize.width + paddingForRect,
              labelSize.height + paddingForRect);
          labelRect =
              _validateRectBounds(labelRect, chart._chartState.containerRect);
          validatedRect = _validateRectXPosition(labelRect, chart);
          backgroundPath.reset();
          tooltipRect = _getRoundedCornerRect(
              validatedRect, axis.crosshairTooltip.borderRadius);
          backgroundPath.addRRect(tooltipRect);
          // Arrow head for tooltip
          _drawTooltipArrowhead(
              canvas,
              backgroundPath,
              fillPaint,
              strokePaint,
              position.dx,
              tooltipRect.bottom + axis.crosshairTooltip.arrowLength,
              (tooltipRect.right - tooltipRect.width / 2) +
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.bottom,
              (tooltipRect.left + tooltipRect.width / 2) -
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.bottom,
              position.dx,
              tooltipRect.bottom + axis.crosshairTooltip.arrowLength);
          _drawText(
              canvas,
              value.toString(),
              Offset(
                  (tooltipRect.left + tooltipRect.width / 2) -
                      labelSize.width / 2,
                  (tooltipRect.top + tooltipRect.height / 2) -
                      labelSize.height / 2),
              ChartTextStyle(
                  color: axis.crosshairTooltip.textStyle.color ??
                      chart._chartTheme.tooltipLabelColor,
                  fontSize: axis.crosshairTooltip.textStyle.fontSize,
                  fontWeight: axis.crosshairTooltip.textStyle.fontWeight,
                  fontFamily: axis.crosshairTooltip.textStyle.fontFamily,
                  fontStyle: axis.crosshairTooltip.textStyle.fontStyle),
              0);
        }
      }

      for (int index = 0;
          index < chart._chartAxis._leftAxesCount.length;
          index++) {
        axis = chart._chartAxis._leftAxesCount[index].axis;
        if (axis.crosshairTooltip.enable) {
          fillPaint.color = axis.crosshairTooltip.color != null
              ? axis.crosshairTooltip.color
              : chart._chartTheme.crosshairFillColor;
          strokePaint.color = axis.crosshairTooltip.borderColor != null
              ? axis.crosshairTooltip?.borderColor
              : chart._chartTheme.crosshairFillColor;
          strokePaint.strokeWidth = axis.crosshairTooltip.borderWidth;
          value = _pointToYVal(
              chart,
              axis,
              axis._bounds,
              position.dx -
                  (chart._chartAxis._axisClipRect.left + axis.plotOffset),
              position.dy -
                  (chart._chartAxis._axisClipRect.top + axis.plotOffset));
          value = _getCrosshairLabel(value, axis);
          if (chart.onCrosshairPositionChanging != null) {
            crosshairEventArgs = CrosshairRenderArgs();
            crosshairEventArgs.axis = axis;
            crosshairEventArgs.orientation = axis._orientation;
            crosshairEventArgs.axisName = axis._name;
            crosshairEventArgs.text = value.toString();
            crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
                chart._chartTheme.crosshairLineColor;
            crosshairEventArgs.value = value;
            chart.onCrosshairPositionChanging(crosshairEventArgs);
            value = crosshairEventArgs.text;
            crosshairLineColor = crosshairEventArgs.lineColor;
          }
          labelSize =
              _measureText(value.toString(), axis.crosshairTooltip.textStyle);
          labelRect = Rect.fromLTWH(
              axis._bounds.left -
                  (labelSize.width + paddingForRect) -
                  axis.crosshairTooltip.arrowLength,
              position.dy - (labelSize.height + paddingForRect) / 2,
              labelSize.width + paddingForRect,
              labelSize.height + paddingForRect);
          labelRect =
              _validateRectBounds(labelRect, chart._chartState.containerRect);
          validatedRect = _validateRectYPosition(labelRect, chart);
          backgroundPath.reset();
          tooltipRect = _getRoundedCornerRect(
              validatedRect, axis.crosshairTooltip.borderRadius);
          // Arrow head for tooltip
          backgroundPath.addRRect(tooltipRect);
          _drawTooltipArrowhead(
              canvas,
              backgroundPath,
              fillPaint,
              strokePaint,
              tooltipRect.right,
              tooltipRect.top +
                  tooltipRect.height / 2 -
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.right,
              tooltipRect.bottom -
                  tooltipRect.height / 2 +
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.right + axis.crosshairTooltip.arrowLength,
              position.dy,
              tooltipRect.right + axis.crosshairTooltip.arrowLength,
              position.dy);
          _drawText(
              canvas,
              value.toString(),
              Offset(
                  (tooltipRect.left + tooltipRect.width / 2) -
                      labelSize.width / 2,
                  (tooltipRect.top + tooltipRect.height / 2) -
                      labelSize.height / 2),
              ChartTextStyle(
                  color: axis.crosshairTooltip.textStyle.color ??
                      chart._chartTheme.tooltipLabelColor,
                  fontSize: axis.crosshairTooltip.textStyle.fontSize,
                  fontWeight: axis.crosshairTooltip.textStyle.fontWeight,
                  fontFamily: axis.crosshairTooltip.textStyle.fontFamily,
                  fontStyle: axis.crosshairTooltip.textStyle.fontStyle),
              0);
        }
      }

      for (int index = 0;
          index < chart._chartAxis._rightAxesCount.length;
          index++) {
        axis = chart._chartAxis._rightAxesCount[index].axis;
        if (axis.crosshairTooltip.enable) {
          fillPaint.color = axis.crosshairTooltip.color != null
              ? axis.crosshairTooltip.color
              : chart._chartTheme.crosshairFillColor;
          strokePaint.color = axis.crosshairTooltip.borderColor != null
              ? axis.crosshairTooltip?.borderColor
              : chart._chartTheme.crosshairFillColor;
          strokePaint.strokeWidth = axis.crosshairTooltip.borderWidth;
          value = _pointToYVal(
              chart,
              axis,
              axis._bounds,
              position.dx -
                  (chart._chartAxis._axisClipRect.left + axis.plotOffset),
              position.dy -
                  (chart._chartAxis._axisClipRect.top + axis.plotOffset));
          value = _getCrosshairLabel(value, axis);
          if (chart.onCrosshairPositionChanging != null) {
            crosshairEventArgs = CrosshairRenderArgs();
            crosshairEventArgs.axis = axis;
            crosshairEventArgs.orientation = axis._orientation;
            crosshairEventArgs.axisName = axis._name;
            crosshairEventArgs.text = value.toString();
            crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
                chart._chartTheme.crosshairLineColor;
            crosshairEventArgs.value = value;
            chart.onCrosshairPositionChanging(crosshairEventArgs);
            value = crosshairEventArgs.text;
            crosshairLineColor = crosshairEventArgs.lineColor;
          }
          labelSize =
              _measureText(value.toString(), axis.crosshairTooltip.textStyle);
          labelRect = Rect.fromLTWH(
              axis._bounds.left + axis.crosshairTooltip.arrowLength,
              position.dy - (labelSize.height / 2 + paddingForRect / 2),
              labelSize.width + paddingForRect,
              labelSize.height + paddingForRect);
          labelRect =
              _validateRectBounds(labelRect, chart._chartState.containerRect);
          validatedRect = _validateRectYPosition(labelRect, chart);
          backgroundPath.reset();
          tooltipRect = _getRoundedCornerRect(
              validatedRect, axis.crosshairTooltip.borderRadius);
          backgroundPath.addRRect(tooltipRect);
          // Arrow head for tooltip
          _drawTooltipArrowhead(
              canvas,
              backgroundPath,
              fillPaint,
              strokePaint,
              tooltipRect.left,
              tooltipRect.top +
                  tooltipRect.height / 2 -
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.left,
              tooltipRect.bottom -
                  tooltipRect.height / 2 +
                  axis.crosshairTooltip.arrowWidth,
              tooltipRect.left - axis.crosshairTooltip.arrowLength,
              position.dy,
              tooltipRect.left - axis.crosshairTooltip.arrowLength,
              position.dy);
          _drawText(
              canvas,
              value.toString(),
              Offset(
                  (tooltipRect.left + tooltipRect.width / 2) -
                      labelSize.width / 2,
                  (tooltipRect.top + tooltipRect.height / 2) -
                      labelSize.height / 2),
              ChartTextStyle(
                  color: axis.crosshairTooltip.textStyle.color ??
                      chart._chartTheme.tooltipLabelColor,
                  fontSize: axis.crosshairTooltip.textStyle.fontSize,
                  fontWeight: axis.crosshairTooltip.textStyle.fontWeight,
                  fontFamily: axis.crosshairTooltip.textStyle.fontFamily,
                  fontStyle: axis.crosshairTooltip.textStyle.fontStyle),
              0);
        }
      }

      crosshairLinePaint.color = crosshairLineColor ??
          chart.crosshairBehavior.lineColor ??
          chart._chartTheme.crosshairLineColor;
      crosshairLinePaint.strokeWidth = chart.crosshairBehavior.lineWidth;
      crosshairLinePaint.style = PaintingStyle.stroke;
      if (chart.zoomPanBehavior._canPerformSelection != true) {
        chart.crosshairBehavior._drawLine(canvas,
            chart.crosshairBehavior._linePainter(crosshairLinePaint), null);
      }
    }
  }

  Rect _validateRectXPosition(Rect labelRect, SfCartesianChart chart) {
    Rect validatedRect = labelRect;
    if (labelRect.right >= chart._chartAxis._axisClipRect.right) {
      validatedRect = Rect.fromLTRB(
          labelRect.left -
              (labelRect.right - chart._chartAxis._axisClipRect.right),
          labelRect.top,
          chart._chartAxis._axisClipRect.right,
          labelRect.bottom);
    } else if (labelRect.left <= chart._chartAxis._axisClipRect.left) {
      validatedRect = Rect.fromLTRB(
          chart._chartAxis._axisClipRect.left,
          labelRect.top,
          labelRect.right +
              (chart._chartAxis._axisClipRect.left - labelRect.left),
          labelRect.bottom);
    }
    return validatedRect;
  }

  Rect _validateRectYPosition(Rect labelRect, SfCartesianChart chart) {
    Rect validatedRect = labelRect;
    if (labelRect.bottom >= chart._chartAxis._axisClipRect.bottom) {
      validatedRect = Rect.fromLTRB(
          labelRect.left,
          labelRect.top -
              (labelRect.bottom - chart._chartAxis._axisClipRect.bottom),
          labelRect.right,
          chart._chartAxis._axisClipRect.bottom);
    } else if (labelRect.top <= chart._chartAxis._axisClipRect.top) {
      validatedRect = Rect.fromLTRB(
          labelRect.left,
          chart._chartAxis._axisClipRect.top,
          labelRect.right,
          labelRect.bottom +
              (chart._chartAxis._axisClipRect.top - labelRect.top));
    }
    return validatedRect;
  }

  // This method will validate whether the tooltip exceeds the screen or not
  Rect _validateRectBounds(Rect tooltipRect, Rect boundary) {
    Rect validatedRect = tooltipRect;
    double difference = 0;
    const double padding = 0.5; // Padding between the corners

    if (tooltipRect.left < boundary.left) {
      difference = (boundary.left - tooltipRect.left) + padding;
      validatedRect = Rect.fromLTRB(
          validatedRect.left + difference,
          validatedRect.top,
          validatedRect.right + difference,
          validatedRect.bottom);
    }
    if (tooltipRect.right > boundary.right) {
      difference = (tooltipRect.right - boundary.right) + padding;
      validatedRect = Rect.fromLTRB(
          validatedRect.left - difference,
          validatedRect.top,
          validatedRect.right - difference,
          validatedRect.bottom);
    }
    if (tooltipRect.top < boundary.top) {
      difference = (boundary.top - tooltipRect.top) + padding;
      validatedRect = Rect.fromLTRB(
          validatedRect.left,
          validatedRect.top + difference,
          validatedRect.right,
          validatedRect.bottom + difference);
    }

    if (tooltipRect.bottom > boundary.bottom) {
      difference = (tooltipRect.bottom - boundary.bottom) + padding;
      validatedRect = Rect.fromLTRB(
          validatedRect.left,
          validatedRect.top - difference,
          validatedRect.right,
          validatedRect.bottom - difference);
    }

    return validatedRect;
  }

  void _drawTooltipArrowhead(
      Canvas canvas,
      Path backgroundPath,
      Paint fillPaint,
      Paint strokePaint,
      double x1,
      double y1,
      double x2,
      double y2,
      double x3,
      double y3,
      double x4,
      double y4) {
    backgroundPath.moveTo(x1, y1);
    backgroundPath.lineTo(x2, y2);
    backgroundPath.lineTo(x3, y3);
    backgroundPath.lineTo(x4, y4);
    backgroundPath.lineTo(x1, y1);
    fillPaint.isAntiAlias = true;
    canvas.drawPath(backgroundPath, strokePaint);
    canvas.drawPath(backgroundPath, fillPaint);
  }

  RRect _getRoundedCornerRect(Rect rect, double cornerRadius) {
    return RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(cornerRadius),
      bottomRight: Radius.circular(cornerRadius),
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
    );
  }

  /// Calculate the X value from the current screen point
  double _pointToXVal(
      SfCartesianChart chart, ChartAxis axis, Rect rect, double x, double y) {
    if (axis != null) {
      return _coefficientToValue(x / rect.width, axis);
    }
    return double.nan;
  }

  /// Calculate the Y value from the current screen point
  double _pointToYVal(
      SfCartesianChart chart, ChartAxis axis, Rect rect, double x, double y) {
    if (axis != null) {
      return _coefficientToValue(1 - (y / rect.height), axis);
    }
    return double.nan;
  }
}
