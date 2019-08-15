part of charts;

/// Renders the pie series.
class PieSeries<T, D> extends CircularSeries<T, D> {
  PieSeries(
      {List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> pointRadiusMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      ChartValueMapper<T, String> sortFieldValueMapper,
      int startAngle,
      int endAngle,
      String radius,
      bool explode,
      bool explodeAll,
      int explodeIndex,
      ActivationMode explodeGesture,
      String explodeOffset,
      double groupTo,
      CircularChartGroupMode groupMode,
      EmptyPointSettings emptyPointSettings,
      Color strokeColor,
      double strokeWidth,
      double opacity,
      DataLabelSettings dataLabelSettings,
      bool enableTooltip,
      bool enableSmartLabels,
      String name,
      double animationDuration,
      SelectionSettings selectionSettings,
      SortingOrder sortingOrder,
      LegendIconType legendIconType})
      : super(
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: (int index) => xValueMapper(dataSource[index], index),
            yValueMapper: (int index) => yValueMapper(dataSource[index], index),
            pointColorMapper: (int index) => pointColorMapper != null
                ? pointColorMapper(dataSource[index], index)
                : null,
            pointRadiusMapper: (int index) => pointRadiusMapper != null
                ? pointRadiusMapper(dataSource[index], index)
                : null,
            dataLabelMapper: (int index) => dataLabelMapper != null
                ? dataLabelMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource[index], index)
                : null,
            startAngle: startAngle,
            endAngle: endAngle,
            radius: radius,
            explode: explode,
            explodeAll: explodeAll,
            explodeIndex: explodeIndex,
            explodeOffset: explodeOffset,
            explodeGesture: explodeGesture,
            groupTo: groupTo,
            groupMode: groupMode,
            emptyPointSettings: emptyPointSettings,
            borderColor: strokeColor,
            borderWidth: strokeWidth,
            opacity: opacity,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            name: name,
            selectionSettings: selectionSettings,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            enableSmartLabels: enableSmartLabels);
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    this.chart,
    this.index,
    this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    ValueNotifier<num> notifier,
  }) : super(repaint: notifier);
  final SfCircularChart chart;
  final int index;
  final bool isRepaint;
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  PieSeries<dynamic, dynamic> series;
  static _ChartPoint<dynamic> point;
  @override
  void paint(Canvas canvas, Size size) {
    num pointStartAngle;
    series = chart._chartSeries.visibleSeries[index];
    pointStartAngle = series._start;
    series._pointRegions = <_Region>[];
    bool isAnyPointNeedSelect = false;
    if (chart._chartState.initialRender) {
      isAnyPointNeedSelect = _checkIsAnyPointSelect(series, point, chart);
    }
    canvas.clipRect(chart._chartState.chartAreaRect);
    for (int i = 0; i < series._renderPoints.length; i++) {
      point = series._renderPoints[i];
      if (point.isVisible) {
        point.innerRadius = 0.0;
        point.outerRadius = series._renderer
            .getPointOuterRadius(series, point, i, index, point.outerRadius);
        pointStartAngle = series._renderPoint(
            chart,
            series,
            point,
            pointStartAngle,
            point.innerRadius,
            point.outerRadius,
            canvas,
            index,
            i,
            seriesAnimation != null ? seriesAnimation?.value : 1,
            seriesAnimation != null ? seriesAnimation?.value : 1,
            isAnyPointNeedSelect);
      }
    }
    series._renderOtherElements(canvas, index, series, seriesAnimation, chart);
  }

  @override
  bool shouldRepaint(_PieChartPainter oldDelegate) => isRepaint;
}
