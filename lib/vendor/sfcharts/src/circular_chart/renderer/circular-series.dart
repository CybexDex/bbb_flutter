part of charts;

/// Renders the circular series.
class CircularSeries<T, D> extends ChartSeries<T, D> {
  CircularSeries(
      {this.dataSource,
      this.xValueMapper,
      this.yValueMapper,
      this.pointColorMapper,
      this.pointRadiusMapper,
      this.dataLabelMapper,
      this.sortFieldValueMapper,
      int startAngle,
      int endAngle,
      String radius,
      String innerRadius,
      bool explode,
      bool explodeAll,
      this.explodeIndex,
      ActivationMode explodeGesture,
      String explodeOffset,
      this.groupTo,
      this.groupMode,
      String gap,
      double opacity,
      this.maximumValue,
      EmptyPointSettings emptyPointSettings,
      Color borderColor,
      double borderWidth,
      DataLabelSettings dataLabelSettings,
      bool enableTooltip,
      bool enableSmartLabels,
      this.name,
      double animationDuration,
      SelectionSettings selectionSettings,
      SortingOrder sortingOrder,
      LegendIconType legendIconType,
      CornerStyle cornerStyle})
      : startAngle = startAngle ?? 0,
        animationDuration = animationDuration ?? 1500,
        endAngle = endAngle ?? 360,
        radius = radius ?? '80%',
        innerRadius = innerRadius ?? '50%',
        explode = explode ?? false,
        explodeAll = explodeAll ?? false,
        explodeOffset = explodeOffset ?? '10%',
        explodeGesture = explodeGesture ?? ActivationMode.singleTap,
        gap = gap ?? '1%',
        cornerStyle = cornerStyle ?? CornerStyle.bothFlat,
        dataLabelSettings = dataLabelSettings ?? DataLabelSettings(),
        emptyPointSettings = emptyPointSettings ?? EmptyPointSettings(),
        selectionSettings = selectionSettings ?? SelectionSettings(),
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0.0,
        opacity = opacity ?? 1,
        enableTooltip = enableTooltip ?? true,
        sortingOrder = sortingOrder ?? SortingOrder.none,
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        enableSmartLabels = enableSmartLabels ?? true,
        super(name: name) {
    _needsRepaint = true;
    _renderer = _ChartSeriesRender();
  }

  ///Opacity of the series. The value ranges from 0 to 1.
  ///
  ///Defaults to 1
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                 opacity: 1,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final double opacity;

  ///Toggles the visibility of the tooltip for this series.
  ///
  ///Defaults to true
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                dataLabelSettings: DataLabelSettings(isVisible: true),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final DataLabelSettings dataLabelSettings;

  _ChartSeriesRender _renderer;

  ///A collection of data required for rendering the series. If no data source is specified,
  ///empty chart will be rendered without series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final List<T> dataSource;

  ///Maps the field name, which will be considered as x-values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<D> xValueMapper;

  ///Maps the field name, which will be considered as y-values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<num> yValueMapper;

  ///Maps the field name, which will be considered as x-values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, Colors.red),
  ///                   ChartData('China', 11, Colors.green),
  ///                   ChartData('Russia', 9, Colors.blue),
  ///                   ChartData('Germany', 10, Colors.voilet),
  ///                ],
  ///                pointColorMapper: (ChartData data, _) => data.pointColor,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.pointColor]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final Color pointColor;
  ///}
  ///```
  final ChartIndexedValueMapper<Color> pointColorMapper;

  ///Maps the field name, which will be considered for calculating the radius of
  /// all the data points.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, '50%'),
  ///                   ChartData('China', 11, '55%'),
  ///                   ChartData('Russia', 9, '60%'),
  ///                   ChartData('Germany', 10, '65%'),
  ///                ],
  ///                pointRadiusMapper: (ChartData data, _) => data.radius,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<String> pointRadiusMapper;

  ///Maps the field name, which will be considered as text for the data points.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                dataLabelMapper: (ChartData data, _) => data.xVal,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<String> dataLabelMapper;

  ///Field in the data source for performing sorting. Sorting will be performed
  ///based on this field.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                sortFieldValueMapper: (ChartData data, _) => data.xVal,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<dynamic> sortFieldValueMapper;

  ///Data label placement without collision.
  ///
  ///Defaults to true
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                   enableSmartLabels: true,
  ///                  )
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enableSmartLabels;

  ///Shape of the legend icon. Any shape in the LegendIconType can be applied to this property.
  ///By default, icon will be rendered based on the type of the series.
  ///
  ///Defaults to LegendIconType.seriesType
  ///
  ///Also refer [LegendIconType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  legendIconType: LegendIconType.diamond,
  ///                  )
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final LegendIconType legendIconType;

  ///Type of sorting. The data points in the series can be sorted in ascending or descending
  ///order.The data points will be rendered in the specified order if it is set to none.
  ///
  ///Default to none
  ///
  ///Also refer [SortingOrder]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  sortingOrder: SortingOrder.ascending,
  ///                  )
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final SortingOrder sortingOrder;

  ///Toggles the visibility of the tooltip for this series.
  ///
  ///Defaults to true
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                enableTooltip: true,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final bool enableTooltip;

  ///Border width of the data points in the series.
  ///
  ///Defaults to 0
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderColor: Colors.red,
  ///            borderWidth: 2
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Border color of the data points in the series.
  ///
  ///Defaults to Colors.transparent
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderColor: Colors.red
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Customizes the empty data points in the series
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  emptyPointSettings: EmptyPointSettings (color: Colors.red)
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final EmptyPointSettings emptyPointSettings;

  ///Customizes the selection of series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final SelectionSettings selectionSettings;

  ///Starting angle of the series.
  ///
  ///Defaults to 0
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  startAngle: 270;
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final int startAngle;

  ///Ending angle of the series.
  ///
  ///Defaults to 360
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  endAngle: 270;
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final int endAngle;

  ///Radius of the series. The value ranges from 0% to 100%.
  ///
  ///Defaults to ‘80%’
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  radius: '10%';
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final String radius;

  ///Inner radius of the series. The value ranges from 0% to 100%.
  ///
  ///Defaults to ‘50%’
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <DoughnutSeries<ChartData, String>>[
  ///                DoughnutSeries<ChartData, String>(
  ///                  innerRadius: '20%';
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final String innerRadius;

  ///Enables or disables the explode of slices on tap.
  ///
  ///Default to false.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true;
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool explode;

  ///Enables or disables exploding all the slices at the initial rendering.
  ///
  ///Defaults to false.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explodeAll: true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool explodeAll;

  ///Index of the slice to explode it at the initial rendering.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeIndex: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final int explodeIndex;

  ///Offset of exploded slice. The value ranges from 0% to 100%.
  ///
  ///Defaults to 20%.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeOffset: '30%'
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final String explodeOffset;

  ///Gesture for activating the explode. Explode can be activated in tap, double tap,
  ///and long press.
  ///
  ///Defaults to ActivationMode.tap
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeGesture: ActivationMode.singleTap
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ActivationMode explodeGesture;

  ///Groups the data points of the series based on their index or values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupTo: 4,
  ///                  groupMode: CircularChartGroupMode.point
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double groupTo;

  ///Slice can also be grouped based on the data points value or based on index.
  ///
  ///Defaults to CircularChartGroupMode.point
  ///
  ///Also refer [CircularChartGroupMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupTo: 3,
  ///                  groupMode: CircularChartGroupMode.point,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final CircularChartGroupMode groupMode;

  ///Specifies the gap between the radial bars in percentage.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  gap: '10%',
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final String gap;

  ///Specifies the radial bar’s corner type.
  ///
  ///Note – This is applicable only for radial bar series type.
  ///
  ///Defaults to CornerStyle.bothFlat
  ///
  ///Also refer [CornerStyle]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  cornerStyle: CornerStyle.bothCurve,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final CornerStyle cornerStyle;

  ///Specifies the maximum value of the radial bar. By default, the maximum value of
  ///the data point will be considered as maximum value.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  maximumValue: 100,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double maximumValue;

  ///Name of the series.
  ///
  ///Defaults to ‘’
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                name: 'default',
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final String name;

  ///Duration for animating the data points.
  ///
  ///Defaults to 1500
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  animationDuration: 3000;
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double animationDuration;

  String _seriesType;

  List<_ChartPoint<dynamic>> _dataPoints;

  List<_ChartPoint<dynamic>> _renderPoints;

  num _sumOfPoints;

  num _start;

  num _end;

  num _totalAngle;

  num _currentRadius;

  num _currentInnerRadius;

  Offset _center;

  List<_Region> _pointRegions;

  /// Whether to repaint series or not
  bool _needsRepaint;

  void _renderOtherElements(
      Canvas canvas,
      int seriesIndex,
      CircularSeries<dynamic, dynamic> series,
      Animation<double> seriesAnimation,
      SfCircularChart chart) {
    if (chart._chartState.animateCompleted) {
      if (series.dataLabelSettings != null &&
          series.dataLabelSettings.isVisible) {
        _renderDataLabel(series, canvas, chart, seriesIndex);
      }
    }
  }

  num _renderPoint(
      SfCircularChart chart,
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      num pointStartAngle,
      num innerRadius,
      num outerRadius,
      Canvas canvas,
      num seriesIndex,
      num pointIndex,
      num animationDegreeValue,
      num animationRadiusValue,
      bool isAnyPointSelect) {
    Path renderPath;
    final num degree = animationDegreeValue * point.degree;
    final num pointEndAngle = pointStartAngle + degree;
    outerRadius = animationRadiusValue * outerRadius;
    final CornerStyle cornerStyle = series.cornerStyle;
    num actualStartAngle, actualEndAngle;
    if (cornerStyle != CornerStyle.bothFlat) {
      final num angleDeviation =
          _findAngleDeviation(innerRadius, outerRadius, 360);
      if (cornerStyle == CornerStyle.startCurve ||
          cornerStyle == CornerStyle.bothCurve) {
        actualStartAngle = pointStartAngle + angleDeviation;
      }

      if (cornerStyle == CornerStyle.endCurve ||
          cornerStyle == CornerStyle.bothCurve) {
        actualEndAngle = pointEndAngle - angleDeviation;
      }

      renderPath = Path();
      if ((pointEndAngle - pointStartAngle) >
          (innerRadius - outerRadius).abs() / (pi / 2)) {
        renderPath = _getRoundedCornerArcPath(
            innerRadius,
            outerRadius,
            point.center,
            actualStartAngle,
            actualEndAngle,
            degree,
            CornerStyle.bothCurve);
      } else {
        final Offset midPoint = _degreeToPoint(
          (actualStartAngle + actualEndAngle) / 2,
          (innerRadius + outerRadius) / 2,
          point.center,
        );
        renderPath.addArc(
            Rect.fromCircle(
                center: midPoint,
                radius: (innerRadius - outerRadius).abs() / 2),
            _degreesToRadians(0),
            _degreesToRadians(360));
      }
    } else {
      renderPath = _getArcPath(
          innerRadius,
          outerRadius,
          point.center,
          pointStartAngle,
          pointEndAngle,
          degree,
          chart,
          chart._chartState.animateCompleted);
    }

    final _Region pointRegion = _Region(
        _degreesToRadians(point.startAngle),
        _degreesToRadians(point.endAngle),
        point.startAngle,
        point.endAngle,
        seriesIndex,
        pointIndex,
        point.center,
        innerRadius,
        point.outerRadius);

    if (chart._chartState.animateCompleted &&
        chart._chartState.initialRender &&
        (pointIndex == series.explodeIndex || series.explodeAll)) {
      chart._chartState.explodedRegions.add(pointRegion);
    }

    series._pointRegions.add(pointRegion);

    if (chart._chartState.initialRender) {
      _selectPoint(pointIndex, point, chart, isAnyPointSelect, pointRegion,
          animationDegreeValue);
    } else {
      _checkWithSelectionState(pointIndex, point, series, chart);
    }

    final double opacity = series._renderer
        .getOpacity(series, point, pointIndex, seriesIndex, series.opacity);

    _drawPath(
        canvas,
        _StyleOptions(
            series._renderer.getPointColor(series, point, pointIndex,
                    seriesIndex, point.fill, opacity) ??
                point.fill.withOpacity(opacity),
            chart._chartState.animateCompleted
                ? series._renderer.getPointStrokeWidth(series, point,
                        pointIndex, seriesIndex, point.strokeWidth) ??
                    point.strokeWidth
                : 0,
            series._renderer.getPointStrokeColor(series, point, pointIndex,
                    seriesIndex, point.strokeColor) ??
                point.strokeColor,
            opacity),
        renderPath);
    return pointEndAngle;
  }
}

abstract class _CircularChartSegment {
  Color getPointColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color color,
      double opacity);

  double getPointOuterRadius(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double outerRadius);

  double getPointInnerRadius(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double innerRadius);

  bool getPointExplode(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      bool isExplode);

  double getOpacity(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double opacity);

  Color getPointStrokeColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor);

  double getPointStrokeWidth(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double strokeWidth);
}

abstract class _LabelSegment {
  String getLabelContent(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      String content);

  ChartTextStyle getDataLabelStyle(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      ChartTextStyle style,
      SfCircularChart chart);

  Color getDataLabelColor(CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point, int pointIndex, int seriesIndex, Color color);

  Color getDataLabelStrokeColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor);

  double getDataLabelStrokeWidth(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double strokeWidth);
}

class _ChartSeriesRender with _CircularChartSegment, _LabelSegment {
  _ChartSeriesRender();

  @override
  Color getPointColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color color,
      double opacity) {
    return color.withOpacity(opacity);
  }

  @override
  double getPointOuterRadius(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double outerRadius) {
    return outerRadius;
  }

  @override
  double getPointInnerRadius(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double innerRadius) {
    return innerRadius;
  }

  @override
  bool getPointExplode(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      bool isExplode) {
    return isExplode;
  }

  @override
  Color getPointStrokeColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor) {
    return strokeColor;
  }

  @override
  double getPointStrokeWidth(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double strokeWidth) {
    return strokeWidth;
  }

  @override
  String getLabelContent(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      String content) {
    return content;
  }

  @override
  ChartTextStyle getDataLabelStyle(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      ChartTextStyle style,
      SfCircularChart chart) {
    final DataLabelSettings dataLabel = series.dataLabelSettings;
    final Color fontColor = dataLabel.textStyle.color != null
        ? dataLabel.textStyle.color
        : _getCircularDatalabelColor(point, series, chart);
    final ChartTextStyle textStyle = ChartTextStyle(
        color: fontColor,
        fontSize: dataLabel.textStyle.fontSize,
        fontFamily: dataLabel.textStyle.fontFamily,
        fontStyle: dataLabel.textStyle.fontStyle,
        fontWeight: dataLabel.textStyle.fontWeight);
    return textStyle;
  }

  @override
  Color getDataLabelColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color color) {
    return color;
  }

  @override
  Color getDataLabelStrokeColor(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      Color strokeColor) {
    return strokeColor ?? point.fill;
  }

  @override
  double getDataLabelStrokeWidth(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double strokeWidth) {
    return strokeWidth;
  }

  @override
  double getOpacity(
      CircularSeries<dynamic, dynamic> series,
      _ChartPoint<dynamic> point,
      int pointIndex,
      int seriesIndex,
      double opacity) {
    return opacity;
  }
}
