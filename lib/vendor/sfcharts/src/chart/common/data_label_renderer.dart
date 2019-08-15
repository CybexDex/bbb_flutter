part of charts;

void _calculateDataLabelPosition(
    XyDataSeries<dynamic, dynamic> series,
    _CartesianChartPoint<dynamic> currentPoint,
    int index,
    SfCartesianChart chart) {
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  EdgeInsets margin;
  Size textSize;
  const double padding = 10;
  final bool inverted = chart._requireInvertedAxis;
  DataLabelRenderArgs dataLabelArgs;
  ChartTextStyle dataLabelStyle;
  final Rect clipRect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
      Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
  margin = (dataLabel.margin == null)
      ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
      : dataLabel.margin;
  if (currentPoint != null &&
      currentPoint.isVisible &&
      currentPoint.isGap != true) {
    String label = currentPoint.dataLabelMapper ??
        _getLabelText(currentPoint, series, chart);
    final ChartTextStyle font =
        (dataLabel.textStyle == null) ? ChartTextStyle() : dataLabel.textStyle;
    currentPoint.label = label;
    dataLabelStyle = dataLabel.textStyle;
    if (chart.onDataLabelRender != null) {
      dataLabelArgs = DataLabelRenderArgs();
      dataLabelArgs.text = label;
      dataLabelArgs.textStyle = dataLabelStyle;
      dataLabelArgs.series = series;
      dataLabelArgs.pointIndex = index;
      chart.onDataLabelRender(dataLabelArgs);
      label = currentPoint.label = dataLabelArgs.text;
      dataLabelStyle = dataLabelArgs.textStyle;
    }
    if (label.isNotEmpty) {
      textSize = _measureText(label, font);
      _ChartLocation chartLocation;
      if (series._isRectSeries) {
        chartLocation = ((series._seriesType == 'bar' &&
                    chart.isTransposed != true) ||
                (series._seriesType == 'column' && chart.isTransposed == true))
            ? (series._yAxis.isInversed
                ? (currentPoint.yValue.isNegative
                    ? _ChartLocation(
                        currentPoint.region.centerRight.dx + textSize.width,
                        currentPoint.region.centerRight.dy)
                    : _ChartLocation(
                        currentPoint.region.centerLeft.dx + textSize.width,
                        currentPoint.region.centerLeft.dy - textSize.height))
                : (currentPoint.yValue.isNegative
                    ? _ChartLocation(
                        currentPoint.region.centerLeft.dx + textSize.width * 2,
                        currentPoint.region.centerLeft.dy)
                    : _ChartLocation(
                        currentPoint.region.centerRight.dx + textSize.width,
                        currentPoint.region.centerRight.dy)))
            : (series._yAxis.isInversed
                ? (currentPoint.yValue.isNegative
                    ? _ChartLocation(currentPoint.region.topCenter.dx,
                        currentPoint.region.topCenter.dy)
                    : _ChartLocation(currentPoint.region.bottomCenter.dx,
                        currentPoint.region.bottomCenter.dy))
                : (currentPoint.yValue.isNegative
                    ? _ChartLocation(currentPoint.region.bottomCenter.dx,
                        currentPoint.region.bottomCenter.dy)
                    : _ChartLocation(currentPoint.region.topCenter.dx,
                        currentPoint.region.topCenter.dy)));
      } else {
        chartLocation = currentPoint.markerPoint;
      }

      final double alignmentValue = (series._seriesType == 'bubble')
          ? textSize.height +
              (series.markerSettings.borderWidth * 2) +
              series.markerSettings.height +
              currentPoint.region.height
          : textSize.height +
              (series.markerSettings.borderWidth * 2) +
              series.markerSettings.height;
      if (series is BarSeries) {
        chartLocation.x = (dataLabel.position == CartesianLabelPosition.auto)
            ? chartLocation.x
            : _calculateAlignment(
                alignmentValue,
                chartLocation.x,
                dataLabel.alignment,
                chartLocation.x < 0 ? false : true,
                inverted);
      } else {
        chartLocation.y = (dataLabel.position == CartesianLabelPosition.auto)
            ? chartLocation.y
            : _calculateAlignment(
                alignmentValue,
                chartLocation.y,
                dataLabel.alignment,
                chartLocation.y < 0 ? false : true,
                inverted);
      }

      if (!series._isRectSeries) {
        chartLocation.y = _calculatePathPosition(
            chartLocation.y,
            dataLabel.position,
            textSize,
            series.markerSettings.borderWidth,
            series,
            index,
            inverted,
            chartLocation,
            chart,
            currentPoint);
      } else {
        bool result;
        bool minus;
        result = (currentPoint.yValue < 0) ? true : false;
        minus = (result != inverted) ? true : false;
        if (!chart._requireInvertedAxis) {
          chartLocation.y = _calculateRectPosition(
              chartLocation.y,
              currentPoint.region,
              minus,
              dataLabel.position,
              series,
              textSize,
              series.markerSettings.borderWidth,
              index,
              chartLocation,
              chart,
              inverted);
        } else {
          chartLocation.x = (dataLabel.position == CartesianLabelPosition.auto)
              ? chartLocation.x
              : _calculateRectPosition(
                  chartLocation.x,
                  currentPoint.region,
                  minus,
                  dataLabel.position,
                  series,
                  textSize,
                  series.markerSettings.borderWidth,
                  index,
                  chartLocation,
                  chart,
                  inverted);
        }
      }
      final Rect rect = _calculateRect(chartLocation, textSize);
      double xPosition = rect.left;
      double yPosition = rect.top;
      final double rectWidth = rect.width;
      final double rectHeight = rect.height;
      final double clipRectWidth = clipRect.right;
      final double clipRectHeight = clipRect.bottom;
      currentPoint.dataLabelRegion =
          Rect.fromLTWH(xPosition, yPosition, textSize.width, textSize.height);
      if (xPosition + rectWidth > clipRectWidth) {
        final int padding =
            dataLabel.position == CartesianLabelPosition.auto ? 5 : 0;
        if (series._seriesType == 'bar' ||
            (series._seriesType == 'column' && chart.isTransposed)) {
          xPosition = currentPoint.region.right - rectWidth - padding;
        } else {
          xPosition = clipRectWidth - rectWidth;
        }
      }
      if (yPosition + rectHeight > clipRectHeight) {
        yPosition = clipRectHeight - rectHeight / 2 - padding;
      }
      if (!((yPosition > clipRectWidth) ||
          (xPosition > clipRectHeight) ||
          (xPosition + rectWidth < 0) ||
          (yPosition + rectHeight < 0))) {
        currentPoint.dataLabelSaturationRegionInside =
            yPosition < clipRect.top ||
                    currentPoint.dataLabelSaturationRegionInside
                ? true
                : currentPoint.dataLabelSaturationRegionInside;
        xPosition = xPosition < clipRect.left ? clipRect.left : xPosition;
        yPosition = yPosition < clipRect.top ? clipRect.top : yPosition;
        xPosition -= (xPosition + rectWidth) > clipRectWidth
            ? (xPosition + rectWidth) - clipRectWidth
            : 0;
        yPosition -= (yPosition + rectHeight) > clipRectHeight
            ? (yPosition + rectHeight) - clipRectHeight
            : 0;
      }
      if ((series._seriesType == 'bar' ||
              (series._seriesType == 'column' && chart.isTransposed)) &&
          dataLabel.position == CartesianLabelPosition.auto &&
          rectWidth > 10) {
        xPosition = xPosition - 5;
      }

      if (dataLabel.color != null ||
          dataLabel.useSeriesColor ||
          (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
        Rect paddedRect;
        paddedRect = Rect.fromLTWH(xPosition, yPosition, rectWidth, rectHeight);

        final RRect rectRegion = RRect.fromRectAndCorners(paddedRect,
            topLeft: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            topRight: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            bottomLeft: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            bottomRight: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius));

        double left = xPosition;
        double width = textSize.width;
        double height = textSize.height;
        double top = yPosition;
        double bottom;

        if (!((top > clipRect.bottom) ||
            (left > clipRect.right) ||
            (left + rectRegion.width < 0) ||
            (top + rectRegion.height < 0))) {
          left = left <= clipRect.left ? clipRect.left + padding : left;
          top = top <= clipRect.top ? clipRect.top + padding : top;
          left -= (left + width) >= clipRect.right
              ? (left + width) - clipRect.right + padding
              : 0;
          top -= (top + height) >= clipRect.bottom
              ? (top + height) - clipRect.bottom + padding
              : 0;
        }
        if ((top - padding / 2 + height + padding) >= clipRect.bottom) {
          bottom = top - padding / 2 + height;
          top -= padding;
        } else {
          bottom = top - padding / 2 + height + padding;
        }
        final RRect fillRect = RRect.fromRectAndCorners(
            Rect.fromLTRB(left - padding / 2, top - padding / 2,
                left + width - padding / 2 + padding, bottom),
            topLeft: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            topRight: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            bottomLeft: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius),
            bottomRight: Radius.elliptical(
                dataLabel.borderRadius, dataLabel.borderRadius));
        //fillRect.bottom>clipRect.bottom
        currentPoint.labelLocation = _ChartLocation(
            fillRect.center.dx - textSize.width / 2,
            fillRect.center.dy - textSize.height / 2);
        currentPoint.dataLabelRegion = Rect.fromLTWH(
            currentPoint.labelLocation.x,
            currentPoint.labelLocation.y,
            textSize.width,
            textSize.height);
        if (margin == const EdgeInsets.all(0)) {
          currentPoint.labelFillRect = fillRect;
        } else {
          final Rect rect = Rect.fromLTRB(
              fillRect.left - margin.left,
              fillRect.top - margin.top,
              fillRect.right + margin.right,
              fillRect.bottom + margin.bottom);
          left = rect.left;
          top = rect.top;
          width = rect.width;
          height = rect.height;
          if (!((top > clipRect.bottom) ||
              (left > clipRect.right) ||
              (left + rectRegion.width < 0) ||
              (top + rectRegion.height < 0))) {
            left = left < clipRect.left ? clipRect.left : left;
            top = top < clipRect.top ? clipRect.top + padding : top;
            left -= (left + width) > clipRect.right
                ? (left + width) - clipRect.right + padding
                : 0;
            top -= (top + height) > clipRect.bottom
                ? (top + height) - clipRect.bottom + padding
                : 0;
          }
          currentPoint.labelLocation = _ChartLocation(
              left + rect.width / 2 - textSize.width / 2,
              top + rect.height / 2 - textSize.height / 2);
          currentPoint.dataLabelRegion = Rect.fromLTWH(
              currentPoint.labelLocation.x,
              currentPoint.labelLocation.y,
              textSize.width,
              textSize.height);
          currentPoint.labelFillRect = RRect.fromRectAndCorners(
              Rect.fromLTWH(left, top, width, height),
              topLeft: Radius.elliptical(
                  dataLabel.borderRadius, dataLabel.borderRadius),
              topRight: Radius.elliptical(
                  dataLabel.borderRadius, dataLabel.borderRadius),
              bottomLeft: Radius.elliptical(
                  dataLabel.borderRadius, dataLabel.borderRadius),
              bottomRight: Radius.elliptical(
                  dataLabel.borderRadius, dataLabel.borderRadius));
        }
      } else {
        yPosition = yPosition > clipRect.top
            ? yPosition
            : textSize.height / 2 + clipRect.top;
        currentPoint.labelLocation = _ChartLocation(xPosition, yPosition);
      }
    }
  }
}

/// Below method is for Rendering data label
void _drawDataLabel(
    Canvas canvas,
    CartesianSeries<dynamic, dynamic> series,
    SfCartesianChart chart,
    DataLabelSettings dataLabel,
    _CartesianChartPoint<dynamic> currentPoint,
    int index,
    Animation<double> dataLabelAnimation) {
  final double opacity =
      dataLabelAnimation != null ? dataLabelAnimation.value : 1;
  final String label = currentPoint.dataLabelMapper ?? currentPoint.label;
  if (label != null &&
      currentPoint != null &&
      currentPoint.isVisible &&
      currentPoint.isGap != true &&
      _isLabelWithinRange(series, currentPoint)) {
    final ChartTextStyle font =
        (dataLabel.textStyle == null) ? ChartTextStyle() : dataLabel.textStyle;
    final Color fontColor = font.color != null
        ? font.color
        : _getDataLabelSaturationColor(currentPoint, series, chart);
    Rect labelRect;
    if (currentPoint.labelFillRect != null) {
      labelRect = Rect.fromLTWH(
          currentPoint.labelFillRect.left,
          currentPoint.labelFillRect.top,
          currentPoint.labelFillRect.width,
          currentPoint.labelFillRect.height);
    } else {
      labelRect = Rect.fromLTWH(
          currentPoint.labelLocation.x,
          currentPoint.labelLocation.y,
          currentPoint.dataLabelRegion.width,
          currentPoint.dataLabelRegion.height);
    }
    final bool isDatalabelCollide =
        _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    if (label.isNotEmpty && isDatalabelCollide
        ? dataLabel.labelIntersectAction == LabelIntersectAction.none
        : true) {
      final ChartTextStyle textStyle = ChartTextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: font.fontSize,
          fontFamily: font.fontFamily,
          fontStyle: font.fontStyle,
          fontWeight: font.fontWeight);
      if (dataLabel.color != null ||
          dataLabel.useSeriesColor ||
          (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
        final RRect fillRect = currentPoint.labelFillRect;
        final Path path = Path();
        path.addRRect(fillRect);
        if (dataLabel.borderColor != null && dataLabel.borderWidth > 0) {
          final Paint strokePaint = Paint()
            ..color = dataLabel.borderColor.withOpacity(
                (opacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : opacity - (1 - dataLabel.opacity))
            ..strokeWidth = dataLabel.borderWidth
            ..style = PaintingStyle.stroke;
          dataLabel.borderWidth == 0
              ? strokePaint.color = Colors.transparent
              : strokePaint.color = strokePaint.color;
          canvas.drawPath(path, strokePaint);
        }
        if (dataLabel.color != null || dataLabel.useSeriesColor) {
          final Paint paint = Paint()
            ..color = (dataLabel.color ??
                    (currentPoint.pointColorMapper ?? series._seriesColor))
                .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : opacity - (1 - dataLabel.opacity))
            ..style = PaintingStyle.fill;
          canvas.drawPath(path, paint);
        }
      }
      series.drawDataLabel(index, canvas, label, currentPoint.labelLocation.x,
          currentPoint.labelLocation.y, dataLabel.angle, textStyle);
      if (opacity >= 1) {
        chart._chartState.renderDatalabelRegions.add(labelRect);
      }
    }
  }
}

bool _isLabelWithinRange(XyDataSeries<dynamic, dynamic> series,
        _CartesianChartPoint<dynamic> currentPoint) =>
    currentPoint.y >= series._yAxis._visibleRange.minimum &&
    currentPoint.y <= series._yAxis._visibleRange.maximum &&
    currentPoint.xValue >= series._xAxis._visibleRange.minimum &&
    currentPoint.xValue <= series._xAxis._visibleRange.maximum;

/// Calculating rect position for datalabel
double _calculateRectPosition(
    double labelLocation,
    Rect rect,
    bool isMinus,
    CartesianLabelPosition position,
    CartesianSeries<dynamic, dynamic> series,
    Size textSize,
    double borderWidth,
    int index,
    _ChartLocation point,
    SfCartesianChart chart,
    bool inverted) {
  const double padding = 5;
  final double textLength = !inverted ? textSize.height : textSize.width;
  final double extraSpace = borderWidth + textLength / 2 + padding;

  /// Locating the data label based on position
  switch (position) {
    case CartesianLabelPosition.bottom:
      labelLocation = !inverted
          ? isMinus
              ? (labelLocation - rect.height + extraSpace)
              : (labelLocation + rect.height - extraSpace)
          : isMinus
              ? (labelLocation - rect.width)
              : (labelLocation - rect.width + extraSpace);
      break;
    case CartesianLabelPosition.middle:
      labelLocation = labelLocation = !inverted
          ? (isMinus
              ? labelLocation - (rect.height / 2)
              : labelLocation + (rect.height / 2))
          : (isMinus
              ? labelLocation - (rect.width / 2)
              : labelLocation + (rect.width / 2));
      break;
    case CartesianLabelPosition.auto:
      labelLocation = _calculateRectActualPosition(
          labelLocation,
          rect,
          isMinus,
          series,
          textSize,
          index,
          point,
          inverted,
          borderWidth,
          chart,
          position);
      break;
    default:
      labelLocation = _calculateTopAndOuterPosition(
          textSize,
          labelLocation,
          rect,
          position,
          series,
          index,
          extraSpace,
          isMinus,
          point,
          inverted,
          borderWidth,
          chart);
      break;
  }
  return labelLocation;
}

double _calculateTopAndOuterPosition(
    Size textSize,
    double location,
    Rect rect,
    CartesianLabelPosition position,
    CartesianSeries<dynamic, dynamic> series,
    int index,
    double extraSpace,
    bool isMinus,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart) {
  final double padding = (position == CartesianLabelPosition.outer) ? 5 : 0;
  if ((isMinus && position == CartesianLabelPosition.top) ||
      (!isMinus && position == CartesianLabelPosition.outer)) {
    location = !inverted
        ? location - extraSpace + padding
        : location - extraSpace - textSize.width;
  } else {
    location =
        !inverted ? location + extraSpace - padding : location - extraSpace;
  }
  return location;
}

double _calculateRectActualPosition(
    double labelLocation,
    Rect rect,
    bool minus,
    CartesianSeries<dynamic, dynamic> series,
    Size textSize,
    int index,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart,
    CartesianLabelPosition position) {
  double location;
  Rect labelRect;
  bool isOverLap = true;
  int positions = 0;
  int finalPosition = 2;

  if (series._seriesType == 'column' ||
      series._seriesType == 'scatter' ||
      series._seriesType == 'spline' ||
      series._seriesType == 'stepline' ||
      series._seriesType == 'bubble' ||
      series._seriesType == 'line' ||
      series._seriesType == 'bar') {
    finalPosition = 4;
  }
  while (isOverLap && positions < finalPosition) {
    location = _calculateRectPosition(
        labelLocation,
        rect,
        minus,
        _getPosition(positions),
        series,
        textSize,
        borderWidth,
        index,
        point,
        chart,
        inverted);
    if (!inverted) {
      labelRect = _calculateRect(_ChartLocation(point.x, location), textSize);
      isOverLap = labelRect.top < 0 ||
          labelRect.top > chart._chartAxis._axisClipRect.height;
    } else {
      labelRect = _calculateRect(_ChartLocation(location, point.y), textSize);
      isOverLap = labelRect.left < 0 ||
          labelRect.left + labelRect.width >
              chart._chartAxis._axisClipRect.width;
    }
    series._dataPoints[index].dataLabelSaturationRegionInside =
        isOverLap || series._dataPoints[index].dataLabelSaturationRegionInside
            ? true
            : false;
    positions++;
  }
  return location;
}

CartesianLabelPosition _getPosition(int position) {
  CartesianLabelPosition dataLabelPosition;
  switch (position) {
    case 0:
      dataLabelPosition = CartesianLabelPosition.outer;
      break;
    case 1:
      dataLabelPosition = CartesianLabelPosition.top;
      break;
    case 2:
      dataLabelPosition = CartesianLabelPosition.bottom;
      break;
    case 3:
      dataLabelPosition = CartesianLabelPosition.middle;
      break;
    case 4:
      dataLabelPosition = CartesianLabelPosition.auto;
      break;
  }
  return dataLabelPosition;
}

double _calculatePathPosition(
    double labelLocation,
    CartesianLabelPosition position,
    Size size,
    double borderWidth,
    CartesianSeries<dynamic, dynamic> series,
    int index,
    bool inverted,
    _ChartLocation point,
    SfCartesianChart chart,
    _CartesianChartPoint<dynamic> currentPoint) {
  const double padding = 5;
  switch (position) {
    case CartesianLabelPosition.top:
    case CartesianLabelPosition.outer:
      labelLocation = (series._seriesType == 'bubble')
          ? labelLocation -
              (borderWidth * 2) -
              size.height -
              -currentPoint.region.height -
              series.markerSettings.height
          : labelLocation - borderWidth - size.height / 2 - padding;
      break;
    case CartesianLabelPosition.bottom:
      labelLocation = (series._seriesType == 'bubble')
          ? labelLocation +
              (borderWidth * 2) +
              size.height +
              currentPoint.region.height +
              series.markerSettings.height
          : labelLocation + borderWidth + size.height / 2 + padding;
      break;
    case CartesianLabelPosition.auto:
      labelLocation = _calculatePathActualPosition(
          labelLocation,
          series,
          series._dataPoints,
          size,
          index,
          inverted,
          borderWidth,
          point,
          chart,
          currentPoint);
      break;
    case CartesianLabelPosition.middle:
      break;
  }
  return labelLocation;
}

double _calculatePathActualPosition(
    double labelLocation,
    CartesianSeries<dynamic, dynamic> series,
    List<_CartesianChartPoint<dynamic>> dataPoints,
    Size size,
    int index,
    bool inverted,
    double borderWidth,
    _ChartLocation point,
    SfCartesianChart chart,
    _CartesianChartPoint<dynamic> currentPoint) {
  final List<_CartesianChartPoint<dynamic>> points = series._dataPoints;
  final num yValue = points[index].yValue;
  CartesianLabelPosition position;
  final _CartesianChartPoint<dynamic> nextPoint =
      points.length - 1 > index ? points[index + 1] : null;
  final _CartesianChartPoint<dynamic> previousPoint =
      index > 0 ? points[index - 1] : null;
  double yLocation;
  bool isOverLap = true;
  Rect labelRect;
  bool isBottom;
  int positionIndex;

  if (series._seriesType == 'bubble' || index == points.length - 1) {
    position = CartesianLabelPosition.top;
  } else {
    if (index == 0) {
      position = ((nextPoint != null) ||
              yValue > nextPoint.yValue ||
              (yValue < nextPoint.yValue && inverted))
          ? CartesianLabelPosition.top
          : CartesianLabelPosition.bottom;
    } else if (index == points.length - 1) {
      position = ((previousPoint == null) ||
              yValue > previousPoint.yValue ||
              (yValue < previousPoint.yValue && inverted))
          ? CartesianLabelPosition.top
          : CartesianLabelPosition.bottom;
    } else {
      if (!series.dataLabelSettings.isVisible && previousPoint != null) {
        position = CartesianLabelPosition.top;
      } else if (previousPoint != null) {
        position =
            (nextPoint.yValue > yValue || (previousPoint.yValue > yValue))
                ? CartesianLabelPosition.bottom
                : CartesianLabelPosition.top;
      } else {
        final num slope = (nextPoint.yValue - previousPoint.yValue) / 2;
        final num intersectY =
            (slope * index) + (nextPoint.yValue - (slope * (index + 1)));
        position = !inverted
            ? intersectY < yValue
                ? CartesianLabelPosition.top
                : CartesianLabelPosition.bottom
            : intersectY < yValue
                ? CartesianLabelPosition.bottom
                : CartesianLabelPosition.top;
      }
    }
  }
  isBottom = position == CartesianLabelPosition.bottom;
  final List<String> dataLabelPosition = List<String>(5);
  dataLabelPosition[0] = 'DataLabelPosition.Outer';
  dataLabelPosition[1] = 'DataLabelPosition.Top';
  dataLabelPosition[2] = 'DataLabelPosition.Bottom';
  dataLabelPosition[3] = 'DataLabelPosition.Middle';
  dataLabelPosition[4] = 'DataLabelPosition.Auto';
  positionIndex = dataLabelPosition.indexOf(position.toString()).toInt();
  if (isOverLap && positionIndex < 4) {
    yLocation = _calculatePathPosition(point.y.toDouble(), position, size,
        borderWidth, series, index, inverted, point, chart, currentPoint);
    labelRect = _calculateRect(_ChartLocation(point.x, yLocation), size);
    isOverLap = labelRect.top < 0 ||
        (labelRect.top + labelRect.height) >
            chart._chartAxis._axisClipRect.height;
    positionIndex = isBottom ? positionIndex - 1 : positionIndex + 1;
    isBottom = false;
  }

  return yLocation;
}

double _calculateAlignment(double value, double labelLocation,
    ChartAlignment alignment, bool isMinus, bool inverted) {
  switch (alignment) {
    case ChartAlignment.far:
      labelLocation = !inverted
          ? (isMinus ? labelLocation - value : labelLocation + value)
          : (isMinus ? labelLocation + value : labelLocation - value);
      break;
    case ChartAlignment.near:
      labelLocation = !inverted
          ? (isMinus ? labelLocation + value : labelLocation - value)
          : (isMinus ? labelLocation - value : labelLocation + value);
      break;
    case ChartAlignment.center:
      labelLocation = labelLocation;
      break;
  }
  return labelLocation;
}

Rect _calculateRect(_ChartLocation location, Size textSize) {
  return Rect.fromLTWH(location.x - (textSize.width / 2),
      location.y - (textSize.height / 2), textSize.width, textSize.height);
}

/// Following method returns the data label text
String _getLabelText(_CartesianChartPoint<dynamic> currentPoint,
    CartesianSeries<dynamic, dynamic> series, SfCartesianChart chart) {
  if (currentPoint.yValue is double) {
    final String str = currentPoint.yValue.toString();
    final List<dynamic> list = str.split('.');
    currentPoint.yValue = double.parse(currentPoint.yValue.toStringAsFixed(2));
    if (list[1] == '0' || list[1] == '00')
      currentPoint.yValue = currentPoint.yValue.round();
  }
  final dynamic yAxis = series._yAxis;
  final dynamic value = yAxis.numberFormat != null
      ? yAxis.numberFormat.format(currentPoint.yValue)
      : currentPoint.yValue;
  return yAxis.labelFormat != null
      ? yAxis.labelFormat.replaceAll(RegExp('{value}'), value.toString())
      : value.toString();
}
