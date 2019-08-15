part of charts;

/// Renders the xy series.
abstract class XyDataSeries<T, D> extends CartesianSeries<T, D> {
  XyDataSeries(
      {ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String name,
      @required List<T> dataSource,
      String xAxisName,
      String yAxisName,
      ChartValueMapper<T, Color> pointColorMapper,
      String legendItemText,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      LinearGradient gradient,
      ChartValueMapper<T, num> sizeValueMapper,
      double width,
      MarkerSettings markerSettings,
      bool isVisible,
      bool enableTooltip,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      double animationDuration,
      List<double> dashArray,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      double opacity,
      List<ChartSegment> segments,
      Color color,
      SortingOrder sortingOrder})
      : super(
            isVisible: isVisible,
            legendItemText: legendItemText,
            xAxisName: xAxisName,
            dashArray: dashArray,
            segments: segments,
            isVisibleInLegend: isVisibleInLegend,
            borderColor: borderColor,
            borderWidth: borderWidth,
            yAxisName: yAxisName,
            color: color,
            name: name,
            width: width,
            xValueMapper: (int index) => xValueMapper(dataSource[index], index),
            yValueMapper: (int index) => yValueMapper(dataSource[index], index),
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource[index], index)
                : null,
            pointColorMapper: pointColorMapper != null
                ? (int index) => pointColorMapper(dataSource[index], index)
                : null,
            dataLabelMapper: dataLabelMapper != null
                ? (int index) => dataLabelMapper(dataSource[index], index)
                : null,
            sizeValueMapper: sizeValueMapper != null
                ? (int index) => sizeValueMapper(dataSource[index], index)
                : null,
            dataSource: dataSource,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            gradient: gradient,
            markerSettings: markerSettings);

  /// Stores the series type
  String _seriesType;

  /// Holds the collection of cartesian data points
  List<_CartesianChartPoint<dynamic>> _dataPoints;

  /// Whether to check the series is rect series or not
  bool _isRectSeries;
}

/// Returns the widget.
typedef DataLabelTemplateBuilder<T> = Widget Function(
    T data, _CartesianChartPoint<dynamic> point, int pointIndex,
    {int seriesIndex, CartesianSeries<dynamic, dynamic> series});

class _CartesianChartPoint<D> {
  _CartesianChartPoint(this.x, this.y,
      [this.dataLabelMapper, this.pointColorMapper, this.bubbleSize]) {
    x = x;
    y = y;
    sortValue = sortValue;
    markerPoint = markerPoint;
    isEmpty = isEmpty;
    isGap = isGap;
    isVisible = isVisible;
    bubbleSize = bubbleSize;
    pointColorMapper = pointColorMapper;
    dataLabelMapper = dataLabelMapper;
  }

  D x;
  D y;
  D xValue;
  D yValue;
  D sortValue;
  _ChartLocation markerPoint;
  double bubbleSize;
  bool isEmpty;
  bool isGap = false;
  bool isDrop = false;
  bool isVisible = true;
  Color pointColorMapper;
  String dataLabelMapper;
  Rect region;
  Rect trackerRectRegion;
  String label;
  RRect labelFillRect;
  _ChartLocation labelLocation;
  bool dataLabelSaturationRegionInside = false;

  ///Stores the data label region
  Rect dataLabelRegion;
}

class _ChartLocation {
  _ChartLocation(this.x, this.y);
  num x;
  num y;
}

/// To calculate dash array path for series
Path _dashPath(
  Path source, {
  @required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

/// A circular array for dash offsets and lengths.
class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}
