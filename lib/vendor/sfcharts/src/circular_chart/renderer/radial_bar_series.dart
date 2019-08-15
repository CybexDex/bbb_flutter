part of charts;

/// Renders the radial bar series.
class RadialBarSeries<T, D> extends CircularSeries<T, D> {
  RadialBarSeries(
      {List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> pointRadiusMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      ChartValueMapper<T, String> sortFieldValueMapper,
      this.trackColor = const Color.fromRGBO(234, 236, 239, 1.0),
      this.trackBorderWidth = 0.0,
      this.trackOpacity = 1,
      this.useSeriesColor = false,
      this.trackBorderColor = Colors.transparent,
      DataLabelSettings dataLabelSettings,
      String radius,
      String innerRadius,
      String gap,
      double maximumValue,
      double strokeWidth,
      double opacity,
      Color strokeColor,
      bool enableTooltip,
      bool enableSmartLabels,
      String name,
      double animationDuration,
      SelectionSettings selectionSettings,
      SortingOrder sortingOrder,
      LegendIconType legendIconType,
      CornerStyle cornerStyle})
      : super(
            dataSource: dataSource,
            animationDuration: animationDuration,
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
            radius: radius,
            innerRadius: innerRadius,
            gap: gap,
            maximumValue: maximumValue,
            borderColor: strokeColor,
            borderWidth: strokeWidth,
            opacity: opacity,
            enableTooltip: enableTooltip,
            dataLabelSettings: dataLabelSettings,
            name: name,
            selectionSettings: selectionSettings,
            sortingOrder: sortingOrder,
            legendIconType: legendIconType,
            enableSmartLabels: enableSmartLabels,
            cornerStyle: cornerStyle);

  ///Color of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Border color of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Border width of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                  trackBorderWidth: 2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Opacity of the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackOpacity: 0.2,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackOpacity;

  ///Uses the point color for filling the track
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool useSeriesColor;

  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

}

class _RadialBarPainter extends CustomPainter {
  _RadialBarPainter({
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

  RadialBarSeries<dynamic, dynamic> series;

  num innerRadius;

  num radius;

  Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    num pointStartAngle, pointEndAngle;
    num degree;
    series = chart._chartSeries.visibleSeries[index];
    series._pointRegions = <_Region>[];
    final num sum = series._sumOfPoints;
    final num actualStartAngle = series._start;
    innerRadius = series._currentInnerRadius;
    radius = series._currentRadius;
    _ChartPoint<dynamic> point;
    center = series._center;
    bool isAnyPointNeedSelect = false;
    if (chart._chartState.initialRender) {
      isAnyPointNeedSelect = _checkIsAnyPointSelect(series, point, chart);
    }
    canvas.clipRect(chart._chartState.chartAreaRect);
    final num ringSize =
        (series._currentRadius - series._currentInnerRadius).abs() /
            series._renderPoints.length;
    final num gap = _percentToValue(
        series.gap, (series._currentRadius - series._currentInnerRadius).abs());
    final num animationValue =
        seriesAnimation != null ? seriesAnimation.value : 1;
    for (int i = 0; i < series._renderPoints.length; i++) {
      point = series._renderPoints[i];
      pointStartAngle = actualStartAngle;
      if (point.isVisible) {
        degree = point.y.abs() / (series.maximumValue ?? sum);
        degree = (degree > 1 ? 1 : degree) * (360 - 0.001);
        degree = degree * animationValue;
        pointEndAngle = pointStartAngle + degree;
        point.midAngle = (pointStartAngle + pointEndAngle) / 2;
        point.startAngle = pointStartAngle;
        point.endAngle = pointEndAngle;
        point.center = center;
        point.innerRadius = innerRadius = innerRadius + (i == 0 ? 0 : ringSize);
        point.outerRadius =
            radius = ringSize < gap ? 0 : innerRadius + ringSize - gap;
        _drawPath(
            canvas,
            _StyleOptions(
                series.useSeriesColor ? point.fill : series.trackColor,
                series.trackBorderWidth,
                series.trackBorderColor,
                series.trackOpacity),
            _getArcPath(innerRadius, radius, center, 0, 360 - 0.001,
                360 - 0.001, chart, true));
        if (radius > 0 && degree > 0) {
          final _Region pointRegion = _Region(
              _degreesToRadians(point.startAngle),
              _degreesToRadians(point.endAngle),
              point.startAngle,
              point.endAngle,
              index,
              i,
              point.center,
              innerRadius,
              point.outerRadius);

          series._pointRegions.add(pointRegion);
          if (chart._chartState.initialRender) {
            _selectPoint(i, point, chart, isAnyPointNeedSelect, pointRegion,
                animationValue);
          } else {
            _checkWithSelectionState(i, point, series, chart);
          }

          final num angleDeviation =
              _findAngleDeviation(innerRadius, radius, 360);

          final CornerStyle cornerStyle = series.cornerStyle;

          if (cornerStyle == CornerStyle.bothCurve ||
              cornerStyle == CornerStyle.startCurve) {
            pointStartAngle += angleDeviation;
          }

          if (cornerStyle == CornerStyle.bothCurve ||
              cornerStyle == CornerStyle.endCurve) {
            pointEndAngle -= angleDeviation;
          }

          final double opacity = series._renderer
              .getOpacity(series, point, i, index, series.opacity);

          if ((pointEndAngle - pointStartAngle) > 0) {
            _drawPath(
                canvas,
                _StyleOptions(
                    series._renderer.getPointColor(
                            series, point, i, index, point.fill, opacity) ??
                        point.fill.withOpacity(opacity),
                    chart._chartState.animateCompleted
                        ? series._renderer.getPointStrokeWidth(
                                series, point, i, index, point.strokeWidth) ??
                            point.strokeWidth
                        : 0,
                    series._renderer.getPointStrokeColor(
                            series, point, i, index, point.strokeColor) ??
                        point.strokeColor),
                _getRoundedCornerArcPath(
                    innerRadius,
                    radius,
                    center,
                    pointStartAngle,
                    pointEndAngle,
                    degree,
                    series.cornerStyle));
          }
        }
      }
    }
    series._renderOtherElements(canvas, index, series, seriesAnimation, chart);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
