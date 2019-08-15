part of charts;

/// Customizes the selection options.
class SelectionSettings extends ChartSelectionBehavior {
  SelectionSettings(
      {bool enable,
      this.selectedColor,
      this.selectedBorderColor,
      this.selectedBorderWidth,
      this.unselectedColor,
      this.unselectedBorderColor,
      this.unselectedBorderWidth,
      double selectedOpacity,
      double unselectedOpacity})
      : enable = enable ?? false,
        selectedOpacity = selectedOpacity ?? 1.0,
        unselectedOpacity = unselectedOpacity ?? 0.5;

  ///Enables or disables the selection. By enabling this, each data point or series
  ///in the chart can be selected.
  ///
  ///Defaults to false
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    enable: true
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Color of the selected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color selectedColor;

  ///Border color of the selected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedBorderColor: Colors.red,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color selectedBorderColor;

  ///Border width of the selected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    selectedBorderWidth: 2
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double selectedBorderWidth;

  ///Color of the unselected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    unselectedColor: Colors.grey,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color unselectedColor;

  ///Border color of the unselected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    unselectedBorderColor: Colors.grey,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color unselectedBorderColor;

  ///Border width of the unselected data points or series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    unselectedBorderWidth: 2
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double unselectedBorderWidth;

  ///Opacity of the selected series or data point.
  ///
  ///Default to 1.0
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedOpacity: 0.5,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double selectedOpacity;

  ///Opacity of the unselected series or data point.
  ///
  ///Defaults to 0.5
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    unselectedOpacity: 0.4,
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///``
  final double unselectedOpacity;

  _SelectionRenderer _selectionRenderer;

  /// Specifies the index of the data point that needs to be selected initially while
  /// rendering a chart.
  void selectionIndex(int pointIndex, int seriesIndex,
      [SelectionType selectionType, bool multiSelect]) {
    _selectionRenderer?.selectionIndex(
        pointIndex, seriesIndex, selectionType, multiSelect);
  }

  void _selectedDataPointIndex(List<IndexesModel> selectedData) {
    _selectionRenderer?.selectedDataPointIndex(selectedData);
  }

  /// Gets the selected item color of a Cartesian series.
  @override
  Paint getSelectedItemFill(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> selectedSegments) {
    return paint;
  }

  /// Gets the unselected item color of a Cartesian series.
  @override
  Paint getUnselectedItemFill(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> unselectedSegments) {
    return paint;
  }

  /// Gets the selected item border color of a Cartesian series.
  @override
  Paint getSelectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> selectedSegments) {
    return paint;
  }

  /// Gets the unselected item border color of a Cartesian series.
  @override
  Paint getUnselectedItemBorder(Paint paint, int seriesIndex, int pointIndex,
      List<ChartSegment> unselectedSegments) {
    return paint;
  }

  /// Gets the selected item color of a circular series.
  @override
  Color getCircularSelectedItemFill(Color color, int seriesIndex,
      int pointIndex, List<_Region> selectedRegions) {
    return color;
  }

  /// Gets the unselected item color of a circular series.
  @override
  Color getCircularUnSelectedItemFill(Color color, int seriesIndex,
      int pointIndex, List<_Region> unselectedRegions) {
    return color;
  }

  /// Gets the selected item border color of a circular series.
  @override
  Color getCircularSelectedItemBorder(Color color, int seriesIndex,
      int pointIndex, List<_Region> selectedRegions) {
    return color;
  }

  /// Gets the unselected item border color of a circular series.
  @override
  Color getCircularUnSelectedItemBorder(Color color, int seriesIndex,
      int pointIndex, List<_Region> unselectedRegions) {
    return color;
  }

  /// Performs the double-tap action on the chart.
  @override
  void onDoubleTap(double xPos, double yPos) {
    _selectionRenderer.performSelection(Offset(xPos, yPos));
  }

  /// Performs the long press action on the chart.
  @override
  void onLongPress(double xPos, double yPos) {
    _selectionRenderer.performSelection(Offset(xPos, yPos));
  }

  /// Performs the touch-down action on the chart.
  @override
  void onTouchDown(double xPos, double yPos) {
    _selectionRenderer.performSelection(Offset(xPos, yPos));
  }

  /// Performs the touch-down action of circular series.
  @override
  void onCircularTouchDown(int pointIndex, int seriesIndex) {
    _selectionRenderer.performCircularSelection(pointIndex, seriesIndex);
  }

  /// Performs the double-tap action of circular series.
  @override
  void onCircularDoubleTap(int pointIndex, int seriesIndex) {
    _selectionRenderer.performCircularSelection(pointIndex, seriesIndex);
  }

  /// Performs the long press action of circular series.
  @override
  void onCircularLongPress(int pointIndex, int seriesIndex) {
    _selectionRenderer.performCircularSelection(pointIndex, seriesIndex);
  }
}
