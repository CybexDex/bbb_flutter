part of charts;

class _ChartLegend {
  _ChartLegend();
  dynamic chart;
  Legend legend;
  List<_LegendRenderContext> legendCollections;
  int rowCount;
  int columnCount;
  Size legendSize = const Size(0, 0);
  Size chartSize = const Size(0, 0);
  bool needRenderLegend = false;
  ValueNotifier<int> legendRepaintNotifier;
  bool isNeedScrollable;

  void _calculateLegendBounds(Size size) {
    legend = chart.legend;
    if (legend.isVisible) {
      calculateSeriesLegends();
      if (legendCollections.isNotEmpty ||
          chart._chartState.legendWidgetContext.isNotEmpty) {
        num legendHeight = 0,
            legendWidth = 0,
            titleHeight = 0,
            textHeight = 0,
            textWidth = 0;
        Size titleSize;
        final num padding = legend.itemPadding;
        num currentWidth = 0, currentHeight = 0;
        num maxTextHeight = 0,
            maxTextWidth = 0,
            maxLegendWidth = 0,
            maxLegendHeight = 0;
        chart._chartLegend.isNeedScrollable = false;
        if (legend.orientation == LegendItemOrientation.auto) {
          legend._orientation =
              (legend.legendPosition == LegendPosition.bottom ||
                      legend.legendPosition == LegendPosition.top)
                  ? LegendItemOrientation.horizontal
                  : LegendItemOrientation.vertical;
        } else {
          legend._orientation = legend.orientation;
        }

        num maxRenderHeight = legend.height != null
            ? _percentageToValue(legend.height, size.height)
            : (legend.legendPosition == LegendPosition.bottom ||
                    legend.legendPosition == LegendPosition.top)
                ? _percentageToValue('30%', size.height)
                : size.height;

        final num maxRenderWidth = legend.width != null
            ? _percentageToValue(legend.width, size.width)
            : (legend.legendPosition == LegendPosition.bottom ||
                    legend.legendPosition == LegendPosition.top)
                ? size.width
                : _percentageToValue('30%', size.width);

        if (legend.title.text != null && legend.title.text.isNotEmpty) {
          titleSize = _measureText(
              legend.title.text,
              legend.title.textStyle ??
                  ChartTextStyle(color: chart._chartTheme.legendTitleColor));
          titleHeight = titleSize.height + padding;
          maxRenderHeight = (maxRenderHeight - titleHeight).abs();
        }

        bool rowAdd, columnAdd;
        rowCount = 1;
        columnCount = 1;
        final bool isTemplate = legend.legendItemBuilder != null;
        final int length = isTemplate
            ? chart._chartState.legendWidgetContext.length
            : legendCollections.length;
        _MeasureWidgetContext legendContext;
        _LegendRenderContext legendRenderContext;
        String legendText;
        Size textSize;
        for (int i = 0; i < length; i++) {
          if (isTemplate) {
            legendContext = chart._chartState.legendWidgetContext[i];
            currentWidth = legendContext.size.width + padding;
            currentHeight = legendContext.size.height;
          } else {
            legendRenderContext = legendCollections[i];
            legendText = legendRenderContext.text;
            textSize = _measureText(legendText,
                legend.textStyle ?? ChartTextStyle(color: Colors.black));
            legendRenderContext.textSize = textSize;
            textHeight = textSize.height;
            textWidth = textSize.width;
            maxTextHeight = max(textHeight, maxTextHeight);
            maxTextWidth = max(textWidth, maxTextWidth);
            currentWidth =
                legend.iconWidth + legend.padding + textWidth + (padding * 2);
            currentHeight = max(maxTextHeight, legend.iconHeight);
            legendRenderContext.size =
                Size(currentWidth, currentHeight + padding);
          }
          needRenderLegend = true;
          titleHeight =
              titleHeight > 0 && i == 0 ? titleHeight + padding : padding;
          if (legend._orientation == LegendItemOrientation.horizontal) {
            if (legend.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendWidth + currentWidth) > maxRenderWidth) {
                rowCount++;
                maxTextHeight = textHeight;
                maxLegendWidth = max(maxLegendWidth, legendWidth);
                legendHeight = i == legendCollections.length - 1
                    ? !rowAdd
                        ? legendHeight + currentHeight + padding
                        : legendHeight
                    : legendHeight + currentHeight + padding;
                legendWidth = i == legendCollections.length - 1
                    ? maxLegendWidth
                    : currentWidth;
                rowAdd = true;
              } else {
                rowAdd = false;
                legendHeight = max(legendHeight, titleHeight + currentHeight);
                legendWidth += currentWidth;
              }
            } else if ((legend.overflowMode == LegendItemOverflowMode.scroll ||
                        legend.overflowMode == LegendItemOverflowMode.none) &&
                    legendWidth == 0
                ? true
                : legendWidth + currentWidth <= maxRenderWidth) {
              if (isTemplate) {
                legendContext.isRender = true;
              } else {
                legendRenderContext.isRender = true;
              }
              legendWidth += currentWidth;
              maxLegendWidth =
                  legendWidth > maxLegendWidth ? maxLegendWidth : 0;
              legendHeight = max(legendHeight,
                  (i == 0 ? titleHeight : 0) + currentHeight + padding);
            }
          } else {
            if (legend.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendHeight + currentHeight) > maxRenderHeight) {
                maxTextWidth = textWidth;
                columnCount++;
                maxLegendHeight = max(legendHeight, maxLegendHeight);
                legendHeight = titleHeight + currentHeight;
                legendWidth = i == legendCollections.length - 1
                    ? !columnAdd ? legendWidth + currentWidth : legendWidth
                    : legendWidth + currentWidth;
                columnAdd = true;
              } else {
                columnAdd = false;
                legendHeight +=
                    (i == 0 ? titleHeight : 0) + currentHeight + padding;
                legendWidth = max(legendWidth, currentWidth);
              }
            } else if (legend.overflowMode == LegendItemOverflowMode.scroll ||
                (legend.overflowMode == LegendItemOverflowMode.none &&
                    legendHeight + currentHeight <= maxRenderHeight)) {
              if (isTemplate) {
                legendContext.isRender = true;
              } else {
                legendRenderContext.isRender = true;
              }
              legendHeight += (i == 0 ? titleHeight : 0) +
                  currentHeight +
                  (i != length - 1 ? padding : 0);
              maxLegendHeight =
                  legendHeight > maxRenderHeight ? maxRenderHeight : 0;
              legendWidth = max(legendWidth, currentWidth);
            }
          }
        }
        legendSize = Size(
            ((maxLegendWidth > 0
                        ? maxLegendWidth
                        : legendWidth > maxRenderWidth &&
                                (legend._orientation ==
                                        LegendItemOrientation.vertical &&
                                    columnCount != 1)
                            ? maxRenderWidth
                            : legendWidth)
                    .floor())
                .toDouble(),
            ((maxLegendHeight > 0
                        ? maxLegendHeight
                        : legendHeight > maxRenderHeight
                            ? maxRenderHeight
                            : legendHeight)
                    .floor())
                .toDouble());
        if (legend._orientation == LegendItemOrientation.vertical
            ? legendWidth > maxRenderWidth
            : legendHeight > maxRenderHeight) {
          chart._chartLegend.isNeedScrollable = true;
        }
      }
    }
  }

  void calculateSeriesLegends() {
    legendCollections = <_LegendRenderContext>[];
    LegendRenderArgs legendEventArgs;
    if (chart.legend.legendItemBuilder == null) {
      if (chart is SfCartesianChart) {
        for (int i = 0; i < chart._chartSeries.visibleSeries.length; i++) {
          final dynamic series = chart._chartSeries.visibleSeries[i];
          series._seriesName = series._seriesName ?? 'series $i';
          if (series.isVisibleInLegend &&
              (series._seriesName != null || series.legendItemText != null)) {
            if (chart.onLegendItemRender != null) {
              legendEventArgs = LegendRenderArgs();
              legendEventArgs.text =
                  series.legendItemText ?? series._seriesName;
              legendEventArgs.legendIconType = series.legendIconType;
              legendEventArgs.seriesIndex = i;
              chart.onLegendItemRender(legendEventArgs);
            }
            final _LegendRenderContext _legendRenderContext =
                _LegendRenderContext(
                    series: series,
                    seriesIndex: i,
                    isSelect: !series.isVisible,
                    text: legendEventArgs?.text ??
                        series.legendItemText ??
                        series._seriesName,
                    iconColor: series.color,
                    iconType: legendEventArgs?.legendIconType ??
                        series.legendIconType);
            legendCollections.add(_legendRenderContext);
            if (!series.isVisible &&
                series.isVisibleInLegend &&
                chart._chartState.initialRender) {
              _legendRenderContext.isSelect = true;
              chart._chartState.legendToggleStates.add(_legendRenderContext);
            }
          }
        }
      } else {
        final dynamic series = chart._chartSeries.visibleSeries[0];
        for (int j = 0; j < series._renderPoints.length; j++) {
          final dynamic chartPoint = series._renderPoints[j];
          if (chart.onLegendItemRender != null) {
            legendEventArgs = LegendRenderArgs();
            legendEventArgs.text = chartPoint.x;
            legendEventArgs.legendIconType = series.legendIconType;
            legendEventArgs.seriesIndex = 0;
            legendEventArgs.pointIndex = j;
            chart.onLegendItemRender(legendEventArgs);
          }

          legendCollections.add(_LegendRenderContext(
              series: series,
              seriesIndex: j,
              isSelect: false,
              point: chartPoint,
              text: chartPoint.x,
              iconColor: chartPoint.fill,
              iconType: series.legendIconType));
        }
      }
    }
  }
}

class _LegendContainer extends StatelessWidget {
  const _LegendContainer({this.chart});

  final dynamic chart;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    final List<_LegendRenderContext> legendCollections =
        chart._chartLegend.legendCollections;
    final List<Widget> legendWidgets = <Widget>[];
    final Legend legend = chart.legend;
    num titleHeight = 0;
    chart._chartLegend.legendRepaintNotifier = ValueNotifier<int>(0);
    if (legend.legendItemBuilder != null) {
      for (int i = 0; i < chart._chartState.legendWidgetContext.length; i++) {
        final _MeasureWidgetContext legendRenderContext =
            chart._chartState.legendWidgetContext[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i,
              template: legendRenderContext.widget,
              size: legendRenderContext.size,
              chart: chart));
        }
      }
    } else {
      for (int i = 0; i < legendCollections.length; i++) {
        final _LegendRenderContext legendRenderContext = legendCollections[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i, size: legendRenderContext.size, chart: chart));
        }
      }
    }

    final bool needLegendTitle =
        legend.title.text != null && legend.title.text.isNotEmpty;

    final double legendHeight = chart._chartLegend.legendSize.height;

    if (needLegendTitle) {
      titleHeight = _measureText(
                  legend.title.text,
                  legend.title.textStyle ??
                      ChartTextStyle(color: chart._chartTheme.legendTitleColor))
              .height +
          5;
    }

    if (chart._chartLegend.isNeedScrollable) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legend._orientation == LegendItemOrientation.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
              child: legend._orientation == LegendItemOrientation.horizontal
                  ? Wrap(direction: Axis.horizontal, children: legendWidgets)
                  : Wrap(direction: Axis.vertical, children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.scroll) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legend._orientation == LegendItemOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              child: legend._orientation == LegendItemOrientation.horizontal
                  ? Row(children: legendWidgets)
                  : Column(children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.none) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: legend._orientation == LegendItemOrientation.horizontal
              ? Row(children: legendWidgets)
              : Column(children: legendWidgets));
    } else {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          width: chart._chartLegend.legendSize.width,
          child: Wrap(
              direction: legend._orientation == LegendItemOrientation.horizontal
                  ? Axis.horizontal
                  : Axis.vertical,
              children: legendWidgets));
    }

    if (needLegendTitle) {
      final ChartAlignment titleAlign = legend.title.alignment;
      final Color color = chart.legend.title.textStyle.color ??
          chart._chartTheme.legendTitleColor;
      final double fontSize = chart.legend.title.textStyle.fontSize;
      final String fontFamily = chart.legend.title.textStyle.fontFamily;
      final FontStyle fontStyle = chart.legend.title.textStyle.fontStyle;
      final FontWeight fontWeight = chart.legend.title.textStyle.fontWeight;
      widget = Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Container(
                height: titleHeight,
                alignment: titleAlign == ChartAlignment.center
                    ? Alignment.center
                    : titleAlign == ChartAlignment.near
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                child: Container(
                  child: Text(legend.title.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          fontStyle: fontStyle,
                          fontWeight: fontWeight)),
                )),
            widget
          ]));
    }
    return widget;
  }
}
