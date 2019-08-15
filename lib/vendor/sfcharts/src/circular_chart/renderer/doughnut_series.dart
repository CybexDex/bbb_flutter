part of charts;

//// Renders the doughnut series.
class DoughnutSeries<T, D> extends CircularSeries<T, D> {
  DoughnutSeries(
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
      String innerRadius,
      bool explode,
      bool explodeAll,
      int explodeIndex,
      String explodeOffset,
      ActivationMode explodeGesture,
      double groupTo,
      CircularChartGroupMode groupMode,
      EmptyPointSettings emptyPointSettings,
      Color strokeColor,
      double strokeWidth,
      DataLabelSettings dataLabelSettings,
      bool enableTooltip,
      bool enableSmartLabels,
      String name,
      double opacity,
      double animationDuration,
      SelectionSettings selectionSettings,
      SortingOrder sortingOrder,
      LegendIconType legendIconType,
      CornerStyle cornerStyle})
      : super(
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
            animationDuration: animationDuration,
            startAngle: startAngle,
            endAngle: endAngle,
            radius: radius,
            innerRadius: innerRadius,
            explode: explode,
            opacity: opacity,
            explodeAll: explodeAll,
            explodeIndex: explodeIndex,
            explodeOffset: explodeOffset,
            explodeGesture: explodeGesture,
            groupMode: groupMode,
            groupTo: groupTo,
            emptyPointSettings: emptyPointSettings,
            borderColor: strokeColor,
            borderWidth: strokeWidth,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            name: name,
            selectionSettings: selectionSettings,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            enableSmartLabels: enableSmartLabels,
            cornerStyle: cornerStyle);
}

class _DoughnutChartPainter extends CustomPainter {
  _DoughnutChartPainter({
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

  DoughnutSeries<dynamic, dynamic> series;

  num innerRadius;

  num radius;

  @override
  void paint(Canvas canvas, Size size) {
    num pointStartAngle;
    series = chart._chartSeries.visibleSeries[index];
    pointStartAngle = series._start;
    innerRadius = series._currentInnerRadius;
    radius = series._currentRadius;
    _ChartPoint<dynamic> point;
    series._pointRegions = <_Region>[];
    canvas.clipRect(chart._chartState.chartAreaRect);
    for (int i = 0; i < series._renderPoints.length; i++) {
      point = series._renderPoints[i];
      if (point.isVisible) {
        point.innerRadius = series._renderer
            .getPointOuterRadius(series, point, i, index, innerRadius);
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
            1,
            _checkIsAnyPointSelect(series, point, chart));
      }
    }
    series._renderOtherElements(canvas, index, series, seriesAnimation, chart);
  }

  @override
  bool shouldRepaint(_DoughnutChartPainter oldDelegate) => isRepaint;
}
