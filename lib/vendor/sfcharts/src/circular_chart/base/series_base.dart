part of charts;

class _CircularSeries {
  _CircularSeries();

  SfCircularChart chart;

  CircularSeries<dynamic, dynamic> currentSeries;

  num size;

  num sumOfGroup;

  _Region explodedRegion;

  _Region selectRegion;

  List<CircularSeries<dynamic, dynamic>> visibleSeries;

  void _findVisibleSeries() {
    visibleSeries = <CircularSeries<dynamic, dynamic>>[];
    for (CircularSeries<dynamic, dynamic> series in chart.series) {
      _setSeriesType(series);
      final dynamic xValue = series.xValueMapper;
      final dynamic yValue = series.yValueMapper;
      final dynamic sortField = series.sortFieldValueMapper;
      series._dataPoints = <_ChartPoint<dynamic>>[];
      for (int pointIndex = 0;
          pointIndex < series.dataSource.length;
          pointIndex++) {
        dynamic sortVal;
        if (xValue(pointIndex) != null) {
          if (series.sortFieldValueMapper != null) {
            sortVal = sortField(pointIndex);
          }
          series._dataPoints.add(
              _ChartPoint<dynamic>(xValue(pointIndex), yValue(pointIndex)));
          if (series.sortingOrder != SortingOrder.none && sortVal != null)
            series._dataPoints[series._dataPoints.length - 1].sortValue =
                sortVal;
        }
      }
      if (series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null) {
        _sortDataSource(series);
      }
      visibleSeries.add(series);
      break;
    }
  }

  void _processDataPoints() {
    for (CircularSeries<dynamic, dynamic> series in visibleSeries) {
      currentSeries = series;
      _setEmptyPoint();
      _findGroupPoints();
    }
  }

  /// Sort the datasource
  void _sortDataSource(CircularSeries<dynamic, dynamic> series) {
    series._dataPoints.sort(
        // ignore: missing_return
        (_ChartPoint<dynamic> firstPoint, _ChartPoint<dynamic> secondPoint) {
      if (series.sortingOrder == SortingOrder.ascending) {
        return (firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue.compareTo(secondPoint.sortValue)));
      } else if (series.sortingOrder == SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue.compareTo(firstPoint.sortValue)));
      }
    });
  }

  void _setEmptyPoint() {
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final int pointLength = currentSeries._dataPoints.length;
    for (int pointIndex = 0; pointIndex < pointLength; pointIndex++) {
      final _ChartPoint<dynamic> point = currentSeries._dataPoints[pointIndex];
      if (point.y == null) {
        switch (empty.mode) {
          case EmptyPointMode.average:
            final num previous = pointIndex - 1 >= 0
                ? currentSeries._dataPoints[pointIndex - 1].y == null
                    ? 0
                    : currentSeries._dataPoints[pointIndex - 1].y
                : 0;
            final num next = pointIndex + 1 <= pointLength - 1
                ? currentSeries._dataPoints[pointIndex + 1].y == null
                    ? 0
                    : currentSeries._dataPoints[pointIndex + 1].y
                : 0;
            point.y = (previous + next).abs() / 2;
            point.isVisible = true;
            point.isEmpty = true;
            break;
          case EmptyPointMode.zero:
            point.y = 0;
            point.isVisible = true;
            point.isEmpty = true;
            break;
          default:
            point.isEmpty = true;
            point.isVisible = false;
            break;
        }
      }
    }
  }

  void _findGroupPoints() {
    final num groupValue = currentSeries.groupTo;
    final CircularChartGroupMode mode = currentSeries.groupMode;
    bool isYtext;
    final dynamic textMapping = currentSeries.dataLabelMapper;
    _ChartPoint<dynamic> point;
    sumOfGroup = 0;
    currentSeries._renderPoints = <_ChartPoint<dynamic>>[];
    for (int i = 0; i < currentSeries._dataPoints.length; i++) {
      point = currentSeries._dataPoints[i];
      point.text = point.text == null
          ? textMapping != null
              ? textMapping(i) ?? point.y.toString()
              : point.y.toString()
          : point.text;
      isYtext = point.text == point.y.toString() ? true : false;
      if (point.isVisible) {
        if (mode == CircularChartGroupMode.point &&
            groupValue != null &&
            i >= groupValue) {
          sumOfGroup += point.y.abs();
        } else if (mode == CircularChartGroupMode.value &&
            groupValue != null &&
            point.y <= groupValue) {
          sumOfGroup += point.y.abs();
        } else {
          currentSeries._renderPoints.add(point);
        }
      }
    }
    if (sumOfGroup > 0) {
      currentSeries._renderPoints
          .add(_ChartPoint<dynamic>('Others', sumOfGroup));
      currentSeries._renderPoints[currentSeries._renderPoints.length - 1].text =
          isYtext == true ? 'Others : ' + sumOfGroup.toString() : 'Others';
    }
    _setPointStyle();
  }

  void _setPointStyle() {
    final dynamic pointColor = currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final List<Color> palette = chart.palette;
    int i = 0;
    for (_ChartPoint<dynamic> point in currentSeries._renderPoints) {
      point.fill = point.isEmpty && empty.color != null
          ? empty.color
          : pointColor(i) ?? palette[i % palette.length];
      point.color = point.fill;
      point.strokeColor = point.isEmpty && empty.borderColor != null
          ? empty.borderColor
          : currentSeries.borderColor;
      point.strokeWidth = point.isEmpty && empty.borderWidth != null
          ? empty.borderWidth
          : currentSeries.borderWidth;
      point.strokeColor =
          point.strokeWidth == 0 ? Colors.transparent : point.strokeColor;

      if (chart.legend.legendItemBuilder != null) {
        final List<_MeasureWidgetContext> legendToggles =
            chart._chartState.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            final _MeasureWidgetContext item = legendToggles[j];
            if (i == item.pointIndex) {
              point.isVisible = false;
              break;
            }
          }
        }
      } else {
        if (chart._chartState.legendToggleStates.isNotEmpty) {
          for (int j = 0;
              j < chart._chartState.legendToggleStates.length;
              j++) {
            final _LegendRenderContext legendRenderContext =
                chart._chartState.legendToggleStates[j];
            if (i == legendRenderContext.seriesIndex) {
              point.isVisible = false;
              break;
            }
          }
        }
      }
      i++;
    }
  }

  void _calculateAngleAndCenterPositions() {
    for (CircularSeries<dynamic, dynamic> series in visibleSeries) {
      currentSeries = series;
      _findSumOfPoints();
      _calculateAngle();
      _calculateRadius();
      _calculateOrigin();
      _calculateCenterPosition();
      _calculateStartAndEndAngle();
    }
  }

  void _calculateCenterPosition() {
    if (chart._needToMoveFromCenter) {
      final num radius = currentSeries._currentRadius;
      final num startAngle = currentSeries.startAngle;
      final num endAngle = currentSeries.endAngle;
      final Offset center = currentSeries._center;
      Offset startPoint = _degreeToPoint(startAngle - 90, radius, center);
      Offset endPoint = _degreeToPoint(endAngle - 90, radius, center);
      final Rect areaRect = chart._chartState.chartAreaRect;
      final Rect circularRect = Rect.fromLTWH(
          areaRect.left + (areaRect.width / 2) - radius,
          areaRect.top + (areaRect.height / 2) - radius,
          radius * 2,
          radius * 2);
      num startXDiff, endXDiff, startYDiff, endYDiff, xDiff, yDiff;
      Offset newPoint;
      final num _startAngle = currentSeries._start + 90;
      final num _endAngle = currentSeries._end + 90;
      if ((currentSeries._start - currentSeries._end).abs() < 360) {
        if ((_startAngle >= 270 && _startAngle <= 360) &&
            ((_endAngle > 270 && _endAngle <= 360) ||
                (_endAngle >= 0 && _endAngle <= 270))) {
          startXDiff = (startPoint.dx - areaRect.left).abs();
          newPoint = (_endAngle <= 360 && _endAngle >= 270)
              ? center
              : (_endAngle <= 90)
                  ? endPoint
                  : _degreeToPoint(90 - 90, radius, center);
          endXDiff =
              ((areaRect.left - newPoint.dx).abs() - areaRect.width).abs();
          startPoint = (_endAngle <= 360 && _endAngle >= 270)
              ? endPoint
              : _degreeToPoint(360 - 90, radius, center);
          startYDiff = (startPoint.dy - areaRect.top).abs();
          endPoint = (_endAngle <= 360 && _endAngle >= 270 ||
                  (_endAngle >= 0 && _endAngle < 90))
              ? center
              : (_endAngle >= 90 && _endAngle <= 180)
                  ? endPoint
                  : _degreeToPoint(180 - 90, radius, center);
          endYDiff = (endPoint.dy - (areaRect.top + areaRect.height)).abs();
        } else if ((_startAngle >= 0 && _startAngle < 90) &&
            (_endAngle > 0 && _endAngle <= 360)) {
          startYDiff = (startPoint.dy - areaRect.top).abs();
          newPoint = (_endAngle <= 90)
              ? center
              : _endAngle >= 180
                  ? _degreeToPoint(180 - 90, radius, center)
                  : endPoint;
          endYDiff = (newPoint.dy - (areaRect.top + areaRect.height)).abs();
          startPoint = (_endAngle >= 180) ? endPoint : center;
          startXDiff = (startPoint.dx - areaRect.left).abs();
          endPoint = (_endAngle >= 90)
              ? _degreeToPoint(90 - 90, radius, center)
              : endPoint;
          endXDiff =
              (areaRect.width - (endPoint.dx - areaRect.left).abs()).abs();
        } else if ((_startAngle >= 90 && _startAngle < 180) &&
            ((_endAngle > 90 && _endAngle <= 360) ||
                (_endAngle >= 0 && _endAngle <= 90))) {
          newPoint = _endAngle > 90 && _endAngle < 180
              ? center
              : _degreeToPoint(270 - 90, radius, center);
          startXDiff = (newPoint.dx - areaRect.left).abs();
          endXDiff =
              ((areaRect.left - startPoint.dx).abs() - areaRect.width).abs();
          startPoint = (_endAngle > 270 || (_endAngle <= 90 && _endAngle >= 0))
              ? _degreeToPoint(360 - 90, radius, center)
              : center;
          startYDiff = (areaRect.top - startPoint.dy).abs();
          endPoint = (_endAngle >= 180 || (_endAngle <= 90 && _endAngle >= 0))
              ? _degreeToPoint(180 - 90, radius, center)
              : endPoint;
          endYDiff = (endPoint.dy - (areaRect.top + areaRect.height)).abs();
        } else if ((_startAngle >= 180 && _startAngle <= 270) &&
            ((_endAngle >= 0 && _endAngle <= 180) ||
                (_endAngle > 180 && _endAngle <= 360))) {
          newPoint = (_endAngle > 270 || (_endAngle >= 0 && _endAngle <= 180))
              ? _degreeToPoint(270 - 90, radius, center)
              : endPoint;
          startXDiff = (newPoint.dx - areaRect.left).abs();
          newPoint = (_endAngle >= 0 && _endAngle <= 180)
              ? (_endAngle >= 90 && _endAngle <= 180)
                  ? _degreeToPoint(90 - 90, radius, center)
                  : endPoint
              : center;
          endXDiff =
              ((newPoint.dx - areaRect.left).abs() - areaRect.width).abs();
          newPoint = (_endAngle > 180 && _endAngle < 270)
              ? center
              : (_endAngle >= 270 && _endAngle <= 360)
                  ? endPoint
                  : _degreeToPoint(360 - 90, radius, center);
          startYDiff = (newPoint.dy - areaRect.top).abs();
          endYDiff = (startPoint.dy - (areaRect.top + areaRect.height)).abs();
        }
        xDiff = (startXDiff + endXDiff).abs();
        yDiff = (startYDiff + endYDiff).abs();
        if ((currentSeries._start - currentSeries._end).abs() == 180) {
          currentSeries._center = Offset(
              center.dx - (startXDiff / 2) + (endXDiff / 2),
              center.dy +
                  ((startYDiff - endYDiff).abs().round() >=
                          currentSeries._currentRadius
                      ? (startYDiff > endYDiff
                          ? -startYDiff / 1.3 + (endYDiff / 2)
                          : endYDiff / 1.3 - startYDiff / 2)
                      : (-(startYDiff / 2) + (endYDiff / 2))));
        } else {
          currentSeries._center = Offset(
              center.dx - (startXDiff / 2) + (endXDiff / 2),
              center.dy - (startYDiff / 2) + (endYDiff / 2));
        }

        final num totalRadius =
            min(circularRect.height, circularRect.width) / 2 +
                min(xDiff, yDiff) / 2;
        currentSeries._currentRadius = totalRadius;
      }
    }
  }

  void _calculateStartAndEndAngle() {
    int pointIndex = 0;
    num pointEndAngle;
    num pointStartAngle = currentSeries._start;
    final num innerRadius = currentSeries._currentInnerRadius;
    for (_ChartPoint<dynamic> point in currentSeries._renderPoints) {
      if (point.isVisible) {
        point.innerRadius =
            (currentSeries._seriesType == 'doughnut') ? innerRadius : 0.0;
        point.degree = (point.y.abs() / currentSeries._sumOfPoints) *
            currentSeries._totalAngle;
        pointEndAngle = pointStartAngle + point.degree;
        point.startAngle = pointStartAngle;
        point.endAngle = pointEndAngle;
        point.midAngle = (pointStartAngle + pointEndAngle) / 2;
        point.outerRadius = chart._chartSeries._calculatePointRadius(
            currentSeries.pointRadiusMapper,
            point,
            pointIndex,
            currentSeries._currentRadius);
        // point.isExplode = point.isExplode == null
        //     ? currentSeries.explode &&
        //         (currentSeries.explodeIndex == pointIndex ||
        //             currentSeries.explodeAll)
        //     : point.isExplode;
        if (_needExplode(pointIndex, currentSeries)) {
          point.center = chart._chartSeries._findExplodeCenter(
              point.midAngle, currentSeries, point.outerRadius);
        } else {
          point.center = currentSeries._center;
        }
        if (currentSeries.dataLabelSettings != null) {
          _findDataLabelPosition(point);
        }
        pointStartAngle = pointEndAngle;
      }
      pointIndex++;
    }
  }

  bool _needExplode(int pointIndex, CircularSeries<dynamic, dynamic> series) {
    bool isNeedExplode = false;
    final List<_Region> explodedRegions = chart._chartState.explodedRegions;
    if (series.explode) {
      if (chart._chartState.initialRender) {
        isNeedExplode = pointIndex == series.explodeIndex || series.explodeAll;
      } else {
        if (explodedRegions.isNotEmpty) {
          for (int i = 0; i < explodedRegions.length; i++) {
            if (explodedRegions[i].pointIndex == pointIndex) {
              isNeedExplode = true;
            }
          }
        }
      }
    }
    return isNeedExplode;
  }

  void _findSumOfPoints() {
    currentSeries._sumOfPoints = 0;
    for (_ChartPoint<dynamic> point in currentSeries._dataPoints) {
      if (point.isVisible) {
        currentSeries._sumOfPoints += point.y.abs();
      }
    }
  }

  void _calculateAngle() {
    currentSeries._start = currentSeries.startAngle < 0
        ? currentSeries.startAngle < -360
            ? (currentSeries.startAngle % 360) + 360
            : currentSeries.startAngle + 360
        : currentSeries.startAngle;
    currentSeries._end = currentSeries.endAngle < 0
        ? currentSeries.endAngle < -360
            ? (currentSeries.endAngle % 360) + 360
            : currentSeries.endAngle + 360
        : currentSeries.endAngle;
    currentSeries._start = currentSeries._start > 360
        ? currentSeries._start % 360
        : currentSeries._start;
    currentSeries._end = currentSeries._end > 360
        ? currentSeries._end % 360
        : currentSeries._end;
    currentSeries._start -= 90;
    currentSeries._end -= 90;
    currentSeries._end = currentSeries._start == currentSeries._end
        ? currentSeries._start + 360
        : currentSeries._end;
    currentSeries._totalAngle = currentSeries._start > currentSeries._end
        ? (currentSeries._start - 360).abs() + currentSeries._end
        : (currentSeries._start - currentSeries._end).abs();
    // currentSeries._totalAngle = currentSeries._totalAngle == 360
    //     ? currentSeries._totalAngle - 0.001
    //     : currentSeries._totalAngle;
  }

  void _calculateRadius() {
    final Rect chartAreaRect = chart._chartState.chartAreaRect;
    size = min(chartAreaRect.width, chartAreaRect.height);
    currentSeries._currentRadius =
        _percentToValue(currentSeries.radius, size / 2);
    currentSeries._currentInnerRadius = _percentToValue(
        currentSeries.innerRadius, currentSeries._currentRadius);
  }

  void _calculateOrigin() {
    final Rect chartAreaRect = chart._chartState.chartAreaRect;
    final Rect chartContainerRect = chart._chartState.chartContainerRect;
    currentSeries._center = Offset(
        _percentToValue(chart.centerX, chartAreaRect.width),
        _percentToValue(chart.centerY, chartAreaRect.height));
    currentSeries._center = Offset(
        currentSeries._center.dx +
            (chartContainerRect.width - chartAreaRect.width).abs() / 2,
        currentSeries._center.dy +
            (chartContainerRect.height - chartAreaRect.height).abs() / 2);
    chart._chartState.centerLocation = currentSeries._center;
  }

  Offset _findExplodeCenter(num midAngle,
      CircularSeries<dynamic, dynamic> series, num currentRadius) {
    final num explodeCenter =
        _percentToValue(series.explodeOffset, currentRadius);
    return _degreeToPoint(midAngle, explodeCenter, series._center);
  }

  num _calculatePointRadius(dynamic pointRadiusMapper,
      _ChartPoint<dynamic> point, int index, num radius) {
    final dynamic pointRadius = pointRadiusMapper;
    final dynamic value = pointRadius(index);
    return value != null ? _percentToValue(value, size / 2) : radius;
  }

  // void selectPoint(Region pointRegion) {
  //   int selectPointIndex;
  //   if (selectRegion != null) {
  //     visibleSeries[selectRegion.seriesIndex]
  //         ._renderPoints[selectRegion.pointIndex]
  //         .isSelected = false;
  //     selectPointIndex = selectRegion.pointIndex;
  //     selectRegion = null;
  //   }

  //   if (pointRegion != null) {
  //     final CircularSeries<dynamic, dynamic> series =
  //         visibleSeries[pointRegion.seriesIndex];
  //     final _ChartPoint<dynamic> point =
  //         series._renderPoints[pointRegion.pointIndex];
  //     if (point.isExplode == null || !point.isExplode) {
  //       if (selectPointIndex == null ||
  //           (selectPointIndex != null &&
  //               selectPointIndex != pointRegion.pointIndex)) {
  //         point.isSelected = true;
  //         selectRegion = pointRegion;
  //       }
  //       chart._chartState.seriesRepaintNotifier?.value++;
  //     }
  //   }
  // }

  void _seriesPointExplosion(_Region pointRegion) {
    bool existExplodedRegion = false;
    final CircularSeries<dynamic, dynamic> series =
        chart._chartSeries.visibleSeries[pointRegion.seriesIndex];
    if (series.explode) {
      if (chart._chartState.explodedRegions.isNotEmpty) {
        for (int i = 0; i < chart._chartState.explodedRegions.length; i++) {
          existExplodedRegion = pointRegion.pointIndex ==
              chart._chartState.explodedRegions[i].pointIndex;
          chart._chartState.explodedRegions.removeAt(i);
        }
      }
      if (!existExplodedRegion) {
        chart._chartState.explodedRegions.add(pointRegion);
      }
      chart._chartState._redraw();
    }
  }

  void _setSeriesType(CircularSeries<dynamic, dynamic> series) {
    if (series is PieSeries)
      series._seriesType = 'pie';
    else if (series is DoughnutSeries)
      series._seriesType = 'doughnut';
    else if (series is RadialBarSeries) series._seriesType = 'radialbar';
  }
}
