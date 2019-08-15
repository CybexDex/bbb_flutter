part of charts;

abstract class _CustomizeLegend {
  void drawLegendItem(int index, _LegendRenderContext legendItem, Legend legend,
      dynamic chart, Canvas canvas, Size size);
  Color getLegendTextColor(
      int index, _LegendRenderContext legendItem, Color textColor);
  Color getLegendIconColor(
      int index, _LegendRenderContext legendItem, Color iconColor);
  Color getLegendIconBorderColor(
      int index, _LegendRenderContext legendItem, Color iconBorderColor);
  double getLegendIconBorderWidth(
      int index, _LegendRenderContext legendItem, double iconBorderWidth);
}

class _LegendRenderer with _CustomizeLegend {
  @override
  Color getLegendIconBorderColor(
      int index, _LegendRenderContext legendItem, Color iconBorderColor) {
    return iconBorderColor;
  }

  @override
  Color getLegendIconColor(
      int index, _LegendRenderContext legendItem, Color iconColor) {
    return iconColor;
  }

  @override
  Color getLegendTextColor(
      int index, _LegendRenderContext legendItem, Color textColor) {
    return textColor;
  }

  @override
  double getLegendIconBorderWidth(
      int index, _LegendRenderContext legendItem, double iconBorderWidth) {
    return iconBorderWidth;
  }

  @override
  void drawLegendItem(int index, _LegendRenderContext legendItem, Legend legend,
      dynamic chart, Canvas canvas, Size size) {
    final String legendText = legendItem.text;
    final List<Color> palette = chart.palette;
    Color color = legendItem.iconColor ?? palette[index % palette.length];
    color = legend._renderer.getLegendIconColor(index, legendItem, color);
    final Size textSize = legendItem.textSize;
    final Offset iconOffset =
        Offset(legend.itemPadding + legend.iconWidth / 2, size.height / 2);
    legendItem.isSelect = chart is SfCartesianChart
        ? !legendItem.series._visible
        : !legendItem.point.isVisible;
    final ChartTextStyle textStyle = legendItem.isSelect
        ? _getTextStyle(
            textStyle: legend.textStyle,
            takeFontColorValue: true,
            fontColor: const Color.fromRGBO(211, 211, 211, 1))
        : _getTextStyle(
            textStyle: legend.textStyle,
            fontColor: legend._renderer.getLegendTextColor(
                index, legendItem, chart._chartTheme.legendLabelColor));

    drawLegendShape(
        index,
        iconOffset,
        canvas,
        Size(legend.iconWidth.toDouble(), legend.iconHeight.toDouble()),
        legend,
        legendItem.iconType,
        color,
        legendItem,
        chart);
    _drawText(
        canvas,
        legendText,
        Offset(
            legend.itemPadding +
                legend.iconWidth +
                legend.padding +
                legend.padding / 2,
            (size.height / 2) - textSize.height / 2),
        textStyle);
  }

  LegendIconType getIconType(DataMarkerType shape) {
    LegendIconType iconType;
    switch (shape) {
      case DataMarkerType.circle:
        iconType = LegendIconType.circle;
        break;
      case DataMarkerType.rectangle:
        iconType = LegendIconType.rectangle;
        break;
      case DataMarkerType.image:
        iconType = LegendIconType.image;
        break;
      case DataMarkerType.pentagon:
        iconType = LegendIconType.pentagon;
        break;
      case DataMarkerType.verticalLine:
        iconType = LegendIconType.verticalLine;
        break;
      case DataMarkerType.invertedTriangle:
        iconType = LegendIconType.invertedTriangle;
        break;
      case DataMarkerType.horizontalLine:
        iconType = LegendIconType.horizontalLine;
        break;
      case DataMarkerType.diamond:
        iconType = LegendIconType.diamond;
        break;
      case DataMarkerType.triangle:
        iconType = LegendIconType.triangle;
        break;
    }
    return iconType;
  }

  void drawLegendShape(
      int index,
      Offset location,
      Canvas canvas,
      Size size,
      Legend legend,
      LegendIconType iconType,
      Color color,
      _LegendRenderContext legendRenderContext,
      dynamic chart) {
    final Path path = Path();
    PaintingStyle style = PaintingStyle.fill;
    iconType = legendRenderContext.series._seriesType == 'scatter'
        ? (iconType != LegendIconType.seriesType
            ? iconType
            : getIconType(legendRenderContext.series.markerSettings.shape))
        : (legendRenderContext.series._seriesType == 'line' &&
                legendRenderContext.series.markerSettings.isVisible
            ? getIconType(legendRenderContext.series.markerSettings.shape)
            : iconType);
    final double width = (legendRenderContext.series.legendIconType ==
                LegendIconType.seriesType &&
            legendRenderContext.series._seriesType == 'line')
        ? size.width / 1.5
        : size.width;
    final double height = (legendRenderContext.series.legendIconType ==
                LegendIconType.seriesType &&
            legendRenderContext.series._seriesType == 'line')
        ? size.height / 1.5
        : size.height;
    switch (iconType) {
      case LegendIconType.seriesType:
        style = _calculateLegendShapes(path, location.dx, location.dy, width,
            height, legendRenderContext.series);
        break;
      case LegendIconType.circle:
        _ChartShapeUtils.drawCircle(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.rectangle:
        _ChartShapeUtils.drawRectangle(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.image:
        break;
      case LegendIconType.pentagon:
        _ChartShapeUtils.drawPentagon(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.verticalLine:
        _ChartShapeUtils.drawVerticalLine(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.invertedTriangle:
        _ChartShapeUtils.drawInvertedTriangle(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.horizontalLine:
        _ChartShapeUtils.drawHorizontalLine(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.diamond:
        _ChartShapeUtils.drawDiamond(
            path, location.dx, location.dy, width, height);
        break;

      case LegendIconType.triangle:
        _ChartShapeUtils.drawTriangle(
            path, location.dx, location.dy, width, height);
        break;
    }
    if (color != null) {
      final Paint fillPaint = Paint()
        ..color = !legendRenderContext.isSelect
            ? color.withOpacity(legend.opacity)
            : const Color.fromRGBO(211, 211, 211, 1)
        ..strokeWidth = legend.iconBorderWidth > 0 ? legend.iconBorderWidth : 1
        ..style = (iconType == LegendIconType.seriesType)
            ? style
            : (iconType == LegendIconType.horizontalLine ||
                    iconType == LegendIconType.verticalLine
                ? PaintingStyle.stroke
                : PaintingStyle.fill);
      final String _seriesType = legendRenderContext.series._seriesType;
      if (legendRenderContext.series.legendIconType ==
                  LegendIconType.seriesType &&
              _seriesType == 'line' ||
          _seriesType == 'fastline') {
        if (iconType != LegendIconType.seriesType) {
          canvas.drawPath(path, fillPaint);
        }
        final Path linePath = Path();
        linePath.moveTo(location.dx - size.width / 1.5, location.dy);
        linePath.lineTo(location.dx + size.width / 1.5, location.dy);
        final Paint _paint = Paint()
          ..color = fillPaint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              legend.iconBorderWidth > 0 ? legend.iconBorderWidth : 2;
        legendRenderContext.series.dashArray[0] != 0
            ? canvas.drawPath(
                _dashPath(linePath,
                    dashArray: _CircularIntervalList<double>(<double>[3, 2])),
                _paint)
            : canvas.drawPath(linePath, _paint);
      } else if (iconType == LegendIconType.seriesType &&
          _seriesType == 'radialbar') {
        _drawPath(
            canvas,
            _StyleOptions(Colors.grey[100], fillPaint.strokeWidth,
                Colors.grey[300].withOpacity(0.5)),
            _getArcPath(
                (width / 2) - 2,
                width / 2,
                Offset(location.dx, location.dy),
                0,
                360 - 0.01,
                360 - 0.01,
                chart,
                true));

        const num pointStartAngle = -90;
        num degree = legendRenderContext.series._renderPoints[index].y.abs() /
            (legendRenderContext.series.maximumValue ??
                legendRenderContext.series._sumOfPoints);
        degree = (degree > 1 ? 1 : degree) * (360 - 0.001);
        final num pointEndAngle = pointStartAngle + degree;

        _drawPath(
            canvas,
            _StyleOptions(
                fillPaint.color, fillPaint.strokeWidth, Colors.transparent),
            _getArcPath(
                (width / 2) - 2,
                width / 2,
                Offset(location.dx, location.dy),
                pointStartAngle,
                pointEndAngle,
                degree,
                chart,
                true));
      } else if (iconType == LegendIconType.seriesType &&
          _seriesType == 'doughnut') {
        _drawPath(
            canvas,
            _StyleOptions(fillPaint.color, fillPaint.strokeWidth,
                Colors.grey[300].withOpacity(0.5)),
            _getArcPath(width / 4, width / 2, Offset(location.dx, location.dy),
                0, 270, 270, chart, true));
        _drawPath(
            canvas,
            _StyleOptions(fillPaint.color, fillPaint.strokeWidth,
                Colors.grey[300].withOpacity(0.5)),
            _getArcPath(
                width / 4,
                width / 2,
                Offset(location.dx + 1, location.dy - 1),
                -5,
                -85,
                -85,
                chart,
                true));
      } else {
        (legendRenderContext.series.legendIconType ==
                    LegendIconType.seriesType &&
                (_seriesType == 'spline' ||
                    _seriesType == 'stepline' ||
                    _seriesType == 'fastline') &&
                legendRenderContext.series.dashArray[0] != 0)
            ? canvas.drawPath(
                _dashPath(path,
                    dashArray: _CircularIntervalList<double>(<double>[3, 2])),
                fillPaint)
            : canvas.drawPath(path, fillPaint);
      }
    }

    final double iconBorderWidth = legend._renderer.getLegendIconBorderWidth(
        index, legendRenderContext, legend.iconBorderWidth);

    if (iconBorderWidth != null && iconBorderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = legend._renderer.getLegendIconBorderColor(
            index, legendRenderContext, legend.iconBorderColor)
        ..strokeWidth = iconBorderWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strokePaint);
    }
  }
}

class _RenderLegend extends StatelessWidget {
  const _RenderLegend({this.index, this.size, this.chart, this.template});

  final int index;

  final Size size;

  final dynamic chart;

  final Widget template;

  @override
  Widget build(BuildContext context) {
    bool isSelect;
    if (chart.legend.legendItemBuilder != null) {
      final _MeasureWidgetContext _measureWidgetContext =
          chart._chartState.legendWidgetContext[index];
      isSelect = chart is SfCartesianChart
          ? chart.series[_measureWidgetContext.seriesIndex]._visible
          : chart._chartSeries.visibleSeries[_measureWidgetContext.seriesIndex]
              ._renderPoints[_measureWidgetContext.pointIndex].isVisible;
    }
    return Container(
        height: size.height,
        width: (chart.legend._orientation == LegendItemOrientation.vertical &&
                chart._chartLegend.rowCount == chart._chartLegend.columnCount)
            ? chart._chartLegend.legendSize.width
            : size.width,
        child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              if (chart is SfCartesianChart) {
                processCartesianSeriesToggle();
              } else {
                processCircularPointsToggle();
              }
            },
            child: template != null
                ? !isSelect ? Opacity(child: template, opacity: 0.5) : template
                : CustomPaint(
                    painter: _ChartLegendPainter(
                        chart: chart,
                        legendIndex: index,
                        isSelect: chart
                            ._chartLegend.legendCollections[index].isSelect,
                        notifier: chart._chartLegend.legendRepaintNotifier))));
  }

  void processCircularPointsToggle() {
    LegendTapArgs legendTapArgs;
    const int seriesIndex = 0;
    if (chart.onLegendTapped != null) {
      legendTapArgs = LegendTapArgs();
      legendTapArgs.series = chart._series[seriesIndex];
      legendTapArgs.seriesIndex = seriesIndex;
      legendTapArgs.pointIndex = index;
      chart.onLegendTapped(legendTapArgs);
    }
    if (chart.legend.toggleSeriesVisibility) {
      if (chart.legend.legendItemBuilder != null) {
        _legendToggleTemplateState(
            chart._chartState.legendWidgetContext[index], chart, '');
      } else {
        _legendToggleState(chart._chartLegend.legendCollections[index], chart);
      }
      chart._chartState._redraw();
    }
  }

  void processCartesianSeriesToggle() {
    LegendTapArgs legendTapArgs;
    _MeasureWidgetContext _measureWidgetContext;
    _LegendRenderContext _legendRenderContext;
    if (chart.onLegendTapped != null) {
      legendTapArgs = LegendTapArgs();
      if (chart.legend.legendItemBuilder != null) {
        _measureWidgetContext = chart._chartState.legendWidgetContext[index];
        legendTapArgs.seriesIndex = _measureWidgetContext.seriesIndex;
        legendTapArgs.series =
            chart._chartSeries.visibleSeries[_measureWidgetContext.seriesIndex];
      } else {
        _legendRenderContext = chart._chartLegend.legendCollections[index];
        legendTapArgs.seriesIndex = _legendRenderContext.seriesIndex;
        legendTapArgs.series = _legendRenderContext.series;
      }
      chart.onLegendTapped(legendTapArgs);
    }
    if (chart.legend.toggleSeriesVisibility) {
      if (chart.legend.legendItemBuilder != null) {
        _legendToggleTemplateState(
            chart._chartState.legendWidgetContext[index], chart, '');
      } else {
        _legendToggleState(chart._chartLegend.legendCollections[index], chart);
      }
      chart._chartState._redraw();
    }
  }
}

class _ChartLegendStylePainter extends CustomPainter {
  _ChartLegendStylePainter({this.chart});

  final dynamic chart;

  @override
  void paint(Canvas canvas, Size size) {
    final Legend legend = chart.legend;
    if (legend.backgroundColor != null) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()
            ..color = legend.backgroundColor ??
                chart._chartTheme.legendBackGroundColor
            ..style = PaintingStyle.fill);
    }
    if (legend.borderColor != null && legend.borderWidth > 0) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()
            ..color = legend.borderColor
            ..strokeWidth = legend.borderWidth
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _ChartLegendPainter extends CustomPainter {
  _ChartLegendPainter(
      {this.chart,
      this.legendIndex,
      this.isSelect,
      ValueNotifier<int> notifier})
      : super(repaint: notifier);

  final dynamic chart;

  final int legendIndex;

  final bool isSelect;

  @override
  void paint(Canvas canvas, Size size) {
    final Legend legend = chart.legend;
    final _LegendRenderContext legendRenderContext =
        chart._chartLegend.legendCollections[legendIndex];
    legend._renderer.drawLegendItem(
        legendIndex, legendRenderContext, legend, chart, canvas, size);
  }

  @override
  bool shouldRepaint(_ChartLegendPainter oldDelegate) {
    return true;
  }
}

class _LegendRenderContext {
  _LegendRenderContext(
      {this.size,
      this.text,
      this.textSize,
      this.iconColor,
      this.iconType,
      this.point,
      this.isSelect,
      this.seriesIndex,
      this.series});

  String text;

  Color iconColor;

  Size textSize;

  LegendIconType iconType;

  Size size;

  Size templateSize;

  dynamic series;

  dynamic point;

  int seriesIndex;

  bool isSelect;

  bool isRender = false;
}
