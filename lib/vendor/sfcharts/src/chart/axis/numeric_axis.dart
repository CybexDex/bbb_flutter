part of charts;

/// Renders the numeric axis.
class NumericAxis extends ChartAxis {
  NumericAxis(
      {String name,
      bool isVisible,
      AxisTitle title,
      AxisLine axisLine,
      ChartRangePadding rangePadding,
      AxisLabelIntersectAction labelIntersectAction,
      int labelRotation,
      this.labelFormat,
      this.numberFormat,
      LabelPosition labelPosition,
      TickPosition tickPosition,
      bool isInversed,
      bool opposedPosition,
      int minorTicksPerInterval,
      int maximumLabels,
      MajorTickLines majorTickLines,
      MinorTickLines minorTickLines,
      MajorGridLines majorGridLines,
      MinorGridLines minorGridLines,
      EdgeLabelPlacement edgeLabelPlacement,
      ChartTextStyle labelStyle,
      double plotOffset,
      double zoomFactor,
      double zoomPosition,
      InteractiveTooltip crosshairTooltip,
      this.minimum,
      this.maximum,
      double interval,
      this.visibleMinimum,
      this.visibleMaximum})
      : super(
            name: name,
            isVisible: isVisible,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            rangePadding: rangePadding,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            axisLine: axisLine,
            edgeLabelPlacement: edgeLabelPlacement,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            plotOffset: plotOffset,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            crosshairTooltip: crosshairTooltip,
            interval: interval);

  SfCartesianChart _chart;

  ///Formats the numeric axis labels. The labels can be customized by adding
  ///desired text as prefix or suffix.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelFormat: '{value}M'),
  ///        ));
  ///}
  ///```
  final String labelFormat;

  ///Formats the numeric axis labels with globalized label formats.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(numberFormat: NumberFormat.currencyCompact()),
  ///        ));
  ///}
  ///```
  final NumberFormat numberFormat;

  ///The minimum value of the axis. The axis will start from this value.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double minimum;

  ///The maximum value of the axis. The axis will end at this value.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(maximum: 200),
  ///        ));
  ///}
  ///```
  final double maximum;

  ///The minimum visible value of the axis. The axis will be rendered
  ///from this value initially.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double visibleMinimum;

  ///The minimum visible value of the axis. The axis will be
  ///rendered from this value initially.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(visibleMaximum: 200),
  ///        ));
  ///}
  ///```
  final double visibleMaximum;
  final int _axisPadding = 5;
  final int _innerPadding = 5;
  num _min;
  num _max;
  Size _axisSize;

  /// Find the series min and max values of an series
  void _findAxisMinMax(CartesianSeries<dynamic, dynamic> series) {
    for (_CartesianChartPoint<dynamic> point in series._dataPoints) {
      point.xValue = point.x;
      point.yValue = point.y;
      series._minimumX ??= point.xValue;
      series._maximumX ??= point.xValue;
      series._minimumY ??= point.yValue;
      series._maximumY ??= point.yValue;
      if (point.xValue != null) {
        series._minimumX = math.min(series._minimumX, point.xValue);
        series._maximumX = math.max(series._maximumX, point.xValue);
      }
      if (point.yValue != null) {
        series._minimumY = math.min(series._minimumY, point.yValue);
        series._maximumY = math.max(series._maximumY, point.yValue);
      }
    }
    series._minimumX ??= 0;
    series._minimumY ??= 0;
    series._maximumX ??= 5;
    series._maximumY ??= 5;
  }

  /// Calculate the range and interval
  void _calculateRangeAndInterval(SfCartesianChart chartWidget) {
    _chart = chartWidget;
    final Rect containerRect = _chart._chartState.containerRect;
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    _axisSize = Size(rect.width, rect.height);
    calculateRange();
    if (_actualRange != null) {
      applyRangePadding(_actualRange, _actualRange.interval);
    }
    generateVisibleLabels();
  }

  /// Finds the minimum and maximum ranges of an axis.
  @override
  void calculateRange() {
    _min = null;
    _max = null;
    List<CartesianSeries<dynamic, dynamic>> visibleSeries;
    CartesianSeries<dynamic, dynamic> series;
    double paddingInterval = 0;
    if (_orientation == AxisOrientation.horizontal) {
      visibleSeries = _series;
      for (int i = 0; i < visibleSeries.length; i++) {
        series = visibleSeries[i];

        if ((series._seriesType == 'column' && !_chart.isTransposed) ||
            (series._seriesType == 'bar' && _chart.isTransposed)) {
          paddingInterval =
              _calculateMinPointsDelta(this, visibleSeries, _chart) / 2;
        }

        _chart._requireInvertedAxis
            ? _findMinMax(series._minimumY, series._maximumY)
            : _findMinMax(series._minimumX - paddingInterval,
                series._maximumX + paddingInterval);
      }
    } else if (_orientation == AxisOrientation.vertical) {
      visibleSeries = _series;
      for (int i = 0; i < visibleSeries.length; i++) {
        series = visibleSeries[i];
        if ((series._seriesType == 'bar' && !_chart.isTransposed) ||
            (series._seriesType == 'column' && _chart.isTransposed)) {
          paddingInterval =
              _calculateMinPointsDelta(this, visibleSeries, _chart) / 2;
        }
        _chart._requireInvertedAxis
            ? _findMinMax(series._minimumX - paddingInterval,
                series._maximumX + paddingInterval)
            : _findMinMax(series._minimumY, series._maximumY);
      }
    }
    _getActualRange();
  }

  void _getActualRange() {
    _min ??= 0;
    _max ??= 5;
    _actualRange = _VisibleRange(minimum ?? _min, maximum ?? _max);

    ///Below condition is for checking the min, max value is equal
    if (_actualRange.minimum == _actualRange.maximum) {
      _actualRange.maximum += 1;
    }

    ///Below condition is for checking the axis min value is greater than max value, then swapping min max values
    else if (_actualRange.minimum > _actualRange.maximum) {
      _actualRange.minimum = _actualRange.minimum + _actualRange.maximum;
      _actualRange.maximum = _actualRange.minimum - _actualRange.maximum;
      _actualRange.minimum = _actualRange.minimum - _actualRange.maximum;
    }
    _actualRange.delta = _actualRange.maximum - _actualRange.minimum;

    _actualRange.interval = interval == null
        ? _calculateNumericNiceInterval(this, _actualRange.delta, _axisSize)
        : interval;
  }

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num interval) {
    final num start = range.minimum;
    final num end = range.maximum;
    ActualRangeChangedArgs rangeChangedArgs;
    if (!(minimum != null && maximum != null)) {
      final ChartRangePadding padding = _calculateRangePadding(this, _chart);
      if (padding == ChartRangePadding.additional ||
          padding == ChartRangePadding.round) {
        /// Get the additional range
        _findAdditionalRange(this, start, end, interval);
      } else if (padding == ChartRangePadding.normal) {
        /// Get the normal range
        _findNormalRange(this, start, end, interval);
      } else {
        _updateActualRange(this, start, end, interval);
      }
      range.delta = range.maximum - range.minimum;
    }

    calculateVisibleRange(_axisSize);

    /// Setting range as visible zoomRange
    if (visibleMinimum != null && visibleMaximum != null) {
      _visibleRange.minimum = visibleMinimum;
      _visibleRange.maximum = visibleMaximum;
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs();
      rangeChangedArgs.axis = this;
      rangeChangedArgs.axisName = _name;
      rangeChangedArgs.orientation = _orientation;
      rangeChangedArgs.actualMin = range.minimum;
      rangeChangedArgs.actualMax = range.maximum;
      rangeChangedArgs.actualInterval = range.interval;
      rangeChangedArgs.visibleMin = _visibleRange.minimum;
      rangeChangedArgs.visibleMax = _visibleRange.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange.interval;
      _chart.onActualRangeChanged(rangeChangedArgs);
      _visibleRange.minimum = rangeChangedArgs.visibleMin;
      _visibleRange.maximum = rangeChangedArgs.visibleMax;
      _visibleRange.interval = rangeChangedArgs.visibleInterval;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange.minimum;
    String text;
    final String minimum = tempInterval.toString();
    final num maximumVisibleRange = _visibleRange.maximum;
    num interval = _visibleRange.interval;
    interval = interval.toString().split('.').length >= 2
        ? interval.toString().split('.')[1].length == 1 &&
                interval.toString().split('.')[1] == '0'
            ? interval.floor()
            : interval
        : interval;
    _visibleLabels = <AxisLabel>[];
    for (; tempInterval <= maximumVisibleRange; tempInterval += interval) {
      num minimumVisibleRange = tempInterval;
      if (minimumVisibleRange <= maximumVisibleRange &&
          minimumVisibleRange >= _visibleRange.minimum) {
        final int fractionDigits = (minimum.split('.').length >= 2)
            ? minimum.split('.')[1].toString().length
            : (minimumVisibleRange.toString().split('.').length >= 2)
                ? minimumVisibleRange.toString().split('.')[1].toString().length
                : 0;
        minimumVisibleRange =
            num.tryParse(minimumVisibleRange.toStringAsFixed(fractionDigits));
        if (minimumVisibleRange is double) {
          final String str = minimumVisibleRange.toString();
          final List<dynamic> list = str.split('.');
          minimumVisibleRange =
              double.parse(minimumVisibleRange.toStringAsFixed(3));
          if (list[1] == '0' || list[1] == '00' || list[1] == '000')
            minimumVisibleRange = minimumVisibleRange.round();
        }
        text = minimumVisibleRange.toString();
        if (numberFormat != null) {
          text = numberFormat.format(minimumVisibleRange);
        }
        if (labelFormat != null) {
          text = labelFormat.replaceAll(RegExp('{value}'), text);
        }
        final Size labelSize = _measureText(text, labelStyle, labelRotation);
        _visibleLabels
            .add(AxisLabel(labelStyle, labelSize, text, minimumVisibleRange));
      }
    }

    /// Get the maximum label of width and height in axis.
    _calculateMaximumLabelSize(this, _chart);
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _visibleRange = _actualRange;
    _checkWithZoomState(this, _chart._chartState.zoomedAxisStates);
    if (_zoomFactor < 1 || _zoomPosition > 0) {
      _calculateZoomRange(this, availableSize);
      _visibleRange.interval = enableAutoIntervalOnZooming
          ? calculateInterval(_visibleRange, _axisSize)
          : _visibleRange.interval;
    }
  }

  /// Find the additional range
  void _findAdditionalRange(
      NumericAxis axis, num start, num end, num interval) {
    num minimum;
    num maximum;
    minimum = ((start / interval).floor()) * interval;
    maximum = ((end / interval).ceil()) * interval;
    if (axis.rangePadding == ChartRangePadding.additional) {
      minimum -= interval;
      maximum += interval;
    }

    /// Update the visible range to the axis.
    _updateActualRange(axis, minimum, maximum, interval);
  }

  /// Find the normal range
  void _findNormalRange(NumericAxis axis, num start, num end, num interval) {
    num remaining, minimum, maximum;
    num startValue = start;
    if (start < 0) {
      startValue = 0;
      minimum = start + (start / 20);
      remaining = interval + _getValueByPercentage(minimum, interval);
      if ((0.365 * interval) >= remaining) {
        minimum -= interval;
      }
      if (_getValueByPercentage(minimum, interval) < 0) {
        minimum =
            (minimum - interval) - _getValueByPercentage(minimum, interval);
      }
    } else {
      minimum = start < ((5.0 / 6.0) * end) ? 0 : (start - (end - start) / 2);
      if (minimum % interval > 0) {
        minimum -= minimum % interval;
      }
    }
    maximum = (end > 0)
        ? (end + (end - startValue) / 20)
        : (end - (end - startValue) / 20);
    remaining = interval - (maximum % interval);
    if ((0.365 * interval) >= remaining) {
      maximum += interval;
    }
    if (maximum % interval > 0) {
      maximum = (maximum + interval) - (maximum % interval);
    }
    if (minimum == 0) {
      interval =
          _calculateNumericNiceInterval(axis, maximum - minimum, _axisSize);
      maximum = (maximum / interval).ceil() * interval;
    }

    /// Update the visible range to the axis.
    _updateActualRange(axis, minimum, maximum, interval);
  }

  /// Update visible range
  void _updateActualRange(
      NumericAxis axis, num minimum, num maximum, num interval) {
    axis._actualRange.minimum = axis.minimum != null ? axis.minimum : minimum;
    axis._actualRange.maximum = axis.maximum != null ? axis.maximum : maximum;
    axis._actualRange.delta =
        axis._actualRange.maximum - axis._actualRange.minimum;
    axis._actualRange.interval =
        axis.interval != null ? axis.interval : interval;
  }

  /// Find min and max values
  void _findMinMax(num minVal, num maxVal) {
    if (_min == null || _min > minVal) {
      _min = minVal;
    }
    if (_max == null || _max < maxVal) {
      _max = maxVal;
    }
    if (_min == _max && _min != null && _max != null) {
      _max = _min + 1;
    }
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) {
    return _calculateNumericNiceInterval(this, _visibleRange.delta, _axisSize);
  }
}
