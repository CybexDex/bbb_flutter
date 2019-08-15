part of charts;

///To get saturation color
Color _getSaturationColor(Color color) {
  Color saturationColor;
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  saturationColor = contrast >= 128 ? Colors.black : Colors.white;
  return saturationColor;
}

ChartTextStyle _getTextStyle(
    {ChartTextStyle textStyle,
    Color fontColor,
    double fontSize,
    FontStyle fontStyle,
    String fontFamily,
    FontWeight fontWeight,
    Paint background,
    bool takeFontColorValue}) {
  return ChartTextStyle(
    color: textStyle != null
        ? textStyle.color != null &&
                (takeFontColorValue == null ? true : !takeFontColorValue)
            ? textStyle.color
            : fontColor
        : fontColor,
    fontWeight:
        textStyle != null ? textStyle.fontWeight ?? fontWeight : fontWeight,
    fontSize: textStyle != null ? textStyle.fontSize ?? fontSize : fontSize,
    fontStyle: textStyle != null ? textStyle.fontStyle ?? fontStyle : fontStyle,
    fontFamily:
        textStyle != null ? textStyle.fontFamily ?? fontFamily : fontFamily,
  );
}

Widget _getElements(
    dynamic chart, Widget chartWidget, BoxConstraints constraints) {
  final LegendPosition legendPosition = chart.legend.legendPosition;
  double legendHeight, legendWidth, chartHeight, chartWidth;
  Widget element;
  const double legendPadding = 5;
  if (chart._chartLegend.needRenderLegend && chart.legend.isResponsive) {
    chartHeight = constraints.maxHeight - chart._chartLegend.legendSize.height;
    chartWidth = constraints.maxWidth - chart._chartLegend.legendSize.width;
    chart._chartLegend.needRenderLegend =
        (legendPosition == LegendPosition.bottom ||
                legendPosition == LegendPosition.top)
            ? (chartHeight > chart._chartLegend.legendSize.height)
            : (chartWidth > chart._chartLegend.legendSize.width);
  }
  if (!chart._chartLegend.needRenderLegend) {
    element = Container(
        child: chartWidget,
        width: constraints.maxWidth,
        height: constraints.maxHeight);
  } else {
    legendHeight = chart._chartLegend.legendSize.height;
    legendWidth = chart._chartLegend.legendSize.width;
    chartHeight = chart._chartLegend.chartSize.height - legendHeight;
    chartWidth = chart._chartLegend.chartSize.width - legendWidth;
    final Widget legendBorderWidget =
        CustomPaint(painter: _ChartLegendStylePainter(chart: chart));
    Widget legendWidget = Container(
        height: legendHeight,
        width: legendWidth,
        decoration: BoxDecoration(color: chart.legend.backgroundColor),
        child: _LegendContainer(chart: chart));
    switch (legendPosition) {
      case LegendPosition.bottom:
      case LegendPosition.top:
        final double legendLeft =
            (chart._chartLegend.chartSize.width > legendWidth)
                ? (chart.legend.alignment == ChartAlignment.near)
                    ? 0
                    : (chart.legend.alignment == ChartAlignment.center)
                        ? chart._chartLegend.chartSize.width / 2 -
                            chart._chartLegend.legendSize.width / 2
                        : chart._chartLegend.chartSize.width -
                            chart._chartLegend.legendSize.width
                : 0;
        final EdgeInsets margin = (legendPosition == LegendPosition.top)
            ? EdgeInsets.fromLTRB(legendLeft, legendPadding, 0, 0)
            : EdgeInsets.fromLTRB(
                legendLeft, chartHeight + legendPadding, 0, 0);
        legendWidget = Container(
          child: Stack(children: <Widget>[
            Container(
                margin: margin,
                height: legendHeight,
                width: legendWidth,
                child: legendBorderWidget),
            Container(
                margin: margin,
                height: legendHeight,
                width: legendWidth,
                child: legendWidget)
          ]),
        );
        if (legendPosition == LegendPosition.top) {
          element = Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: <Widget>[
                  legendWidget,
                  Container(
                    margin: EdgeInsets.fromLTRB(0, legendHeight, 0, 0),
                    height: chartHeight,
                    width: chart._chartLegend.chartSize.width,
                    child: chartWidget,
                  )
                ],
              ));
        } else {
          element = Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: chartHeight,
                    width: chart._chartLegend.chartSize.width,
                    child: chartWidget,
                  ),
                  legendWidget
                ],
              ));
        }
        break;
      case LegendPosition.right:
      case LegendPosition.left:
        final double legendTop =
            (chart._chartLegend.chartSize.height > legendHeight)
                ? (chart.legend.alignment == ChartAlignment.near)
                    ? 0
                    : (chart.legend.alignment == ChartAlignment.center)
                        ? chart._chartLegend.chartSize.height / 2 -
                            chart._chartLegend.legendSize.height / 2
                        : chart._chartLegend.chartSize.height -
                            chart._chartLegend.legendSize.height
                : 0;
        final EdgeInsets margin = (legendPosition == LegendPosition.left)
            ? EdgeInsets.fromLTRB(legendPadding, legendTop, 0, 0)
            : EdgeInsets.fromLTRB(chartWidth + legendPadding, legendTop, 0, 0);
        legendWidget = Container(
          child: Stack(children: <Widget>[
            Container(
              margin: margin,
              height: legendHeight,
              width: legendWidth,
              child: legendBorderWidget,
            ),
            Container(
              margin: margin,
              height: legendHeight,
              width: legendWidth,
              child: legendWidget,
            )
          ]),
        );
        if (legendPosition == LegendPosition.left) {
          element = Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: <Widget>[
                  legendWidget,
                  Container(
                    margin: EdgeInsets.fromLTRB(legendWidth, 0, 0, 0),
                    height: chart._chartLegend.chartSize.height,
                    width: chartWidth,
                    child: chartWidget,
                  )
                ],
              ));
        } else {
          element = Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: chart._chartLegend.chartSize.height,
                    width: chartWidth,
                    child: chartWidget,
                  ),
                  legendWidget
                ],
              ));
        }
        break;
      default:
        break;
    }
  }
  return element;
}

class _MeasureWidgetSize extends StatelessWidget {
  const _MeasureWidgetSize(
      {this.chart,
      this.currentWidget,
      this.opacityValue,
      this.currentKey,
      this.seriesIndex,
      this.pointIndex,
      this.type});
  final dynamic chart;
  final Widget currentWidget;
  final double opacityValue;
  final Key currentKey;
  final int seriesIndex;
  final int pointIndex;
  final String type;
  @override
  Widget build(BuildContext context) {
    final List<_MeasureWidgetContext> templates =
        chart._chartState.legendWidgetContext;
    templates.add(_MeasureWidgetContext(
        widget: currentWidget,
        key: currentKey,
        context: context,
        seriesIndex: seriesIndex,
        pointIndex: pointIndex));
    return Container(
        key: currentKey,
        child: Opacity(opacity: opacityValue, child: currentWidget));
  }
}

bool _legendToggleTemplateState(
    _MeasureWidgetContext currentItem, dynamic chart, String checkType) {
  bool needSelect = false;
  final List<_MeasureWidgetContext> legendToggles =
      chart._chartState.legendToggleTemplateStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _MeasureWidgetContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex &&
          currentItem.pointIndex == item.pointIndex) {
        if (checkType != 'isSelect') {
          needSelect = true;
          legendToggles.removeAt(i);
        }
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    if (checkType != 'isSelect') {
      legendToggles.add(currentItem);
    }
  }
  return needSelect;
}

void _legendToggleState(_LegendRenderContext currentItem, dynamic chart) {
  bool needSelect = false;
  final List<_LegendRenderContext> legendToggles =
      chart._chartState.legendToggleStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _LegendRenderContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex) {
        needSelect = true;
        if (currentItem.isSelect) {
          currentItem.series._visible = true;
        }
        legendToggles.removeAt(i);
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    legendToggles.add(currentItem);
  }
}

bool _isCollide(Rect rect, List<Rect> regions) {
  bool isCollide = false;
  for (int i = 0; i < regions.length; i++) {
    final Rect regionRect = regions[i];
    if ((rect.left < regionRect.left + regionRect.width &&
            rect.left + rect.width > regionRect.left) &&
        (rect.top < regionRect.top + regionRect.height &&
            rect.top + rect.height > regionRect.top)) {
      isCollide = true;
      break;
    }
  }
  return isCollide;
}

num _getValueByPercentage(num value1, num value2) {
  num value;
  if (value1.isNegative) {
    value = num.tryParse('-' +
        (num.tryParse(value1.toString().replaceAll(RegExp('-'), '')) % value2)
            .toString());
  } else {
    value = value1 % value2;
  }
  return value;
}

void _animateComplete(List<AnimationController> controllerList, dynamic chart) {
  bool statusCompleted;
  for (AnimationController item in controllerList) {
    item.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        for (int i = 0; i < controllerList.length; i++) {
          if (controllerList[i].status != AnimationStatus.completed) {
            statusCompleted = false;
            break;
          } else {
            statusCompleted = true;
          }
        }
      }
      if (statusCompleted) {
        chart._chartState.animateCompleted = true;
      }
    });
  }
}
