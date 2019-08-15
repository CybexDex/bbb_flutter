part of charts;

class _ChartAxis {
  _ChartAxis() {
    _innerPadding = 5;
    _axisPadding = 10;
    _axisClipRect = Rect.fromLTRB(0, 0, 0, 0);
    _verticalAxes = <ChartAxis>[];
    _horizontalAxes = <ChartAxis>[];
    _needsRepaint = true;
  }
  SfCartesianChart _chartWidget;
  final List<ChartAxis> _leftAxes = <ChartAxis>[];
  final List<ChartAxis> _rightAxes = <ChartAxis>[];
  final List<ChartAxis> _topAxes = <ChartAxis>[];
  final List<ChartAxis> _bottomAxes = <ChartAxis>[];
  List<_AxisSize> _leftAxesCount;
  List<_AxisSize> _bottomAxesCount;
  List<_AxisSize> _topAxesCount;
  List<_AxisSize> _rightAxesCount;
  double _bottomSize = 0;
  double _topSize = 0;
  double _leftSize = 0;
  double _rightSize = 0;
  num _innerPadding = 0;
  num _axisPadding = 0;
  Rect _axisClipRect;
  List<ChartAxis> _verticalAxes = <ChartAxis>[];
  List<ChartAxis> _horizontalAxes = <ChartAxis>[];
  List<ChartAxis> _axisCollections = <ChartAxis>[];

  /// Whether to repaint axis or not
  bool _needsRepaint;

  void _measureAxesBounds() {
    _bottomSize = 0;
    _topSize = 0;
    _leftSize = 0;
    _rightSize = 0;
    _leftAxesCount = <_AxisSize>[];
    _bottomAxesCount = <_AxisSize>[];
    _topAxesCount = <_AxisSize>[];
    _rightAxesCount = <_AxisSize>[];
    if (_verticalAxes.isNotEmpty) {
      for (int axisIndex = 0; axisIndex < _verticalAxes.length; axisIndex++) {
        final dynamic axis = _verticalAxes[axisIndex];
        axis._calculateRangeAndInterval(_chartWidget);
        _measureAxesSize(axis);
      }
      _calculateSeriesClipRect();
    }
    if (_horizontalAxes.isNotEmpty) {
      for (int axisIndex = 0; axisIndex < _horizontalAxes.length; axisIndex++) {
        final dynamic axis = _horizontalAxes[axisIndex];
        _calculateLabelRotationAngle(axis);
        axis._calculateRangeAndInterval(_chartWidget);
        _measureAxesSize(axis);
      }
    }
    _calculateAxesRect();
  }

  ///Calculate the axes total size
  void _measureAxesSize(ChartAxis axis) {
    num titleSize = 0;
    axis._totalSize = 0;
    if (axis.isVisible) {
      if (axis.title.text != null && axis.title.text.isNotEmpty) {
        titleSize = _measureText(axis.title.text, axis.title.textStyle).height +
            _axisPadding;
      }

      final int axisIndex = _getAxisIndex(axis);
      final double tickSize =
          (axisIndex == 0 && axis.tickPosition == TickPosition.inside)
              ? 0
              : math.max(
                      axis.majorTickLines.size,
                      axis.minorTicksPerInterval > 0
                          ? axis.minorTickLines.size
                          : 0) +
                  _innerPadding;
      final double labelSize =
          (axisIndex == 0 && axis.labelPosition == LabelPosition.inside)
              ? 0
              : ((axis._orientation == AxisOrientation.horizontal)
                      ? axis._maximumLabelSize.height
                      : axis._maximumLabelSize.width) +
                  _innerPadding;

      axis._totalSize = titleSize + tickSize + labelSize;
      if (axis._orientation == AxisOrientation.horizontal) {
        if (!axis.opposedPosition) {
          axis._totalSize +=
              _bottomAxes.isNotEmpty ? _axisPadding.toDouble() : 0;
          _bottomSize += axis._totalSize;
          _bottomAxesCount.add(_AxisSize(axis, axis._totalSize));
        } else {
          axis._totalSize += _topAxes.isNotEmpty ? _axisPadding.toDouble() : 0;
          _topSize += axis._totalSize;
          _topAxesCount.add(_AxisSize(axis, axis._totalSize));
        }
      } else if (axis._orientation == AxisOrientation.vertical) {
        if (!axis.opposedPosition) {
          axis._totalSize += _leftAxes.isNotEmpty ? _axisPadding.toDouble() : 0;
          _leftSize += axis._totalSize;
          _leftAxesCount.add(_AxisSize(axis, axis._totalSize));
        } else {
          axis._totalSize +=
              _rightAxes.isNotEmpty ? _axisPadding.toDouble() : 0;
          _rightSize += axis._totalSize;
          _rightAxesCount.add(_AxisSize(axis, axis._totalSize));
        }
      }
    }
  }

  int _getAxisIndex(ChartAxis axis) {
    int index;
    if (axis._orientation == AxisOrientation.horizontal) {
      if (!axis.opposedPosition) {
        _bottomAxes.add(axis);
        index = _bottomAxes.length;
      } else {
        _topAxes.add(axis);
        index = _topAxes.length;
      }
    } else if (axis._orientation == AxisOrientation.vertical) {
      if (!axis.opposedPosition) {
        _leftAxes.add(axis);
        index = _leftAxes.length;
      } else {
        _rightAxes.add(axis);
        index = _rightAxes.length;
      }
    }
    return index - 1;
  }

  void _calculateLabelRotationAngle(ChartAxis axis) {
    int angle = axis._labelRotation;
    if (angle < -360 || angle > 360) {
      angle %= 360;
    }
    if (angle.isNegative) {
      angle = angle + 360;
    }
    axis._labelRotation = angle;
  }

  // Calculate series clip rect size
  void _calculateSeriesClipRect() {
    final Rect containerRect = _chartWidget._chartState.containerRect;
    final num padding =
        _chartWidget.title.text != null && _chartWidget.title.text.isNotEmpty
            ? 10
            : 0;
    _chartWidget._chartAxis._axisClipRect = Rect.fromLTWH(
        containerRect.left + _leftSize,
        containerRect.top + _topSize + padding,
        containerRect.width - _leftSize - _rightSize,
        containerRect.height - _topSize - _bottomSize - padding);
  }

  // Calculate axes bounds based on all axes
  void _calculateAxesRect() {
    num axisSize, height, width, axesLength, axisIndex;
    _calculateSeriesClipRect();
    final Rect rect = _chartWidget._chartAxis._axisClipRect;

    /// Calculate the left axes rect
    if (_leftAxesCount.isNotEmpty) {
      axesLength = _leftAxesCount.length;
      for (axisIndex = 0; axisIndex < axesLength; axisIndex++) {
        width = _leftAxesCount[axisIndex].size;
        final ChartAxis axis = _leftAxesCount[axisIndex].axis;
        axisSize = (axisIndex == 0)
            ? rect.left
            : ((_leftAxesCount[axisIndex - 1].axis._bounds.left -
                        _leftAxesCount[axisIndex - 1].axis._bounds.width) -
                    (axis.labelPosition == LabelPosition.inside
                        ? (_innerPadding + axis._maximumLabelSize.width)
                        : 0)) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                _axisPadding;
        axis._bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
            width, rect.height - 2 * axis.plotOffset);
      }
    }

    /// Calculate the bottom axes rect
    if (_bottomAxesCount.isNotEmpty) {
      axesLength = _bottomAxesCount.length;
      for (axisIndex = 0; axisIndex < axesLength; axisIndex++) {
        height = _bottomAxesCount[axisIndex].size;
        final ChartAxis axis = _bottomAxesCount[axisIndex].axis;
        axisSize = (axisIndex == 0)
            ? rect.top + rect.height
            : _axisPadding +
                (_bottomAxesCount[axisIndex - 1].axis._bounds.top +
                    _bottomAxesCount[axisIndex - 1].axis._bounds.height) +
                (axis.labelPosition == LabelPosition.inside
                    ? (_innerPadding + axis._maximumLabelSize.height)
                    : 0) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0);

        axis._bounds = Rect.fromLTWH(rect.left + axis.plotOffset, axisSize,
            rect.width - 2 * axis.plotOffset, height);
      }
    }

    /// Calculate the right axes rect
    if (_rightAxesCount.isNotEmpty) {
      axesLength = _rightAxesCount.length;
      for (axisIndex = 0; axisIndex < axesLength; axisIndex++) {
        final ChartAxis axis = _rightAxesCount[axisIndex].axis;
        width = _rightAxesCount[axisIndex].size;
        axisSize = (axisIndex == 0)
            ? rect.left + rect.width
            : ((_rightAxesCount[axisIndex - 1].axis._bounds.left +
                        _rightAxesCount[axisIndex - 1].axis._bounds.width) +
                    (axis.labelPosition == LabelPosition.inside
                        ? axis._maximumLabelSize.width + _innerPadding
                        : 0)) +
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) +
                _axisPadding;
        axis._bounds = Rect.fromLTWH(axisSize, rect.top + axis.plotOffset,
            width, rect.height - 2 * axis.plotOffset);
      }
    }

    /// Calculate the top axes rect
    if (_topAxesCount.isNotEmpty) {
      axesLength = _topAxesCount.length;
      for (axisIndex = 0; axisIndex < axesLength; axisIndex++) {
        final ChartAxis axis = _topAxesCount[axisIndex].axis;
        height = _topAxesCount[axisIndex].size;
        axisSize = (axisIndex == 0)
            ? rect.top
            : (_topAxesCount[axisIndex - 1].axis._bounds.top -
                    _topAxesCount[axisIndex - 1].axis._bounds.height) -
                (axis.labelPosition == LabelPosition.inside
                    ? (_axisPadding + axis._maximumLabelSize.height)
                    : 0) -
                (axis.tickPosition == TickPosition.inside
                    ? math.max(
                        axis.majorTickLines.size,
                        axis.minorTicksPerInterval > 0
                            ? axis.minorTickLines.size
                            : 0)
                    : 0) -
                _axisPadding;
        axis._bounds = Rect.fromLTWH(rect.left + axis.plotOffset, axisSize,
            rect.width - 2 * axis.plotOffset, height);
      }
    }
  }

  // Calculate the visible axes
  void _calculateVisibleAxes() {
    _innerPadding = _chartWidget.borderWidth;
    _axisPadding = 5;
    _axisClipRect = Rect.fromLTRB(0, 0, 0, 0);
    _verticalAxes = <ChartAxis>[];
    _horizontalAxes = <ChartAxis>[];
    _chartWidget.primaryXAxis._name =
        (_chartWidget.primaryXAxis._name) ?? 'primaryXAxis';
    _chartWidget.primaryYAxis._name =
        _chartWidget.primaryYAxis._name ?? 'primaryYAxis';
    _axisCollections = <ChartAxis>[
      _chartWidget.primaryXAxis,
      _chartWidget.primaryYAxis
    ];
    final List<CartesianSeries<dynamic, dynamic>> visibleSeries =
        _chartWidget._chartSeries.visibleSeries;
    if (visibleSeries.isNotEmpty) {
      if (_chartWidget.axes.isNotEmpty) {
        _axisCollections.addAll(_chartWidget.axes);
      }
      for (int axisIndex = 0;
          axisIndex < _axisCollections.length;
          axisIndex++) {
        final ChartAxis axis = _axisCollections[axisIndex];
        if (axis is CategoryAxis) {
          axis._labels = <dynamic>[];
        }
        axis._series = <CartesianSeries<dynamic, dynamic>>[];
        for (int seriesIndex = 0;
            seriesIndex < visibleSeries.length;
            seriesIndex++) {
          final XyDataSeries<dynamic, dynamic> series =
              visibleSeries[seriesIndex];
          if ((axis._name != null && axis._name == series.xAxisName) ||
              (series.xAxisName == null &&
                  axis._name == _chartWidget.primaryXAxis._name) ||
              (series.xAxisName != null &&
                  axis._name != series.xAxisName &&
                  axis._name == _chartWidget.primaryXAxis._name)) {
            axis._orientation = _chartWidget._requireInvertedAxis
                ? AxisOrientation.vertical
                : AxisOrientation.horizontal;
            series._xAxis = axis;
            axis._series.add(series);
          } else if ((axis._name != null && series.yAxisName == axis._name) ||
              (series.yAxisName == null &&
                  axis._name == _chartWidget.primaryYAxis._name) ||
              (series.yAxisName != null &&
                  axis._name != series.yAxisName &&
                  axis._name == _chartWidget.primaryYAxis._name)) {
            axis._orientation = _chartWidget._requireInvertedAxis
                ? AxisOrientation.horizontal
                : AxisOrientation.vertical;
            series._yAxis = axis;
            axis._series.add(series);
          }
        }
        if (axis._orientation != null) {
          axis._orientation == AxisOrientation.vertical
              ? _verticalAxes.add(axis)
              : _horizontalAxes.add(axis);
        }
      }
    } else {
      _chartWidget.primaryXAxis._orientation = AxisOrientation.horizontal;
      _chartWidget.primaryYAxis._orientation = AxisOrientation.vertical;
      _horizontalAxes.add(_chartWidget.primaryXAxis);
      _verticalAxes.add(_chartWidget.primaryYAxis);
      if (_chartWidget.axes != null) {
        _axisCollections.addAll(_chartWidget.axes);
      }
    }
  }
}
