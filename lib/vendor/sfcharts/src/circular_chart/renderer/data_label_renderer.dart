part of charts;

void _renderDataLabel(CircularSeries<dynamic, dynamic> series, Canvas canvas,
    SfCircularChart chart, int seriesIndex) {
  _ChartPoint<dynamic> point;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  Offset labelLocation;
  chart = chart;
  final bool smartLabel = series.enableSmartLabels;
  const int labelPadding = 2;
  String label;
  DataLabelRenderArgs dataLabelArgs;
  ChartTextStyle dataLabelStyle;
  final List<Rect> renderDatalabelRegions = <Rect>[];
  for (int pointIndex = 0;
      pointIndex < series._renderPoints.length;
      pointIndex++) {
    point = series._renderPoints[pointIndex];
    if (point.isVisible) {
      label = point.text;
      label = series._renderer
          .getLabelContent(series, point, pointIndex, seriesIndex, label);
      dataLabelStyle = dataLabel.textStyle;
      if (chart.onDataLabelRender != null) {
        dataLabelArgs = DataLabelRenderArgs();
        dataLabelArgs.text = label;
        dataLabelArgs.textStyle = dataLabelStyle;
        dataLabelArgs.series = series;
        dataLabelArgs.pointIndex = pointIndex;
        chart.onDataLabelRender(dataLabelArgs);
        label = dataLabelArgs.text;
        dataLabelStyle = dataLabelArgs.textStyle;
      }
      dataLabelStyle = chart.onDataLabelRender == null
          ? series._renderer.getDataLabelStyle(
              series, point, pointIndex, seriesIndex, dataLabelStyle, chart)
          : dataLabelStyle;
      final Size textSize = _measureTextSize(label, dataLabelStyle);
      if (series._seriesType == 'radialbar') {
        labelLocation = _degreeToPoint(point.startAngle,
            (point.innerRadius + point.outerRadius) / 2, point.center);
        labelLocation = Offset(labelLocation.dx - textSize.width - 5,
            labelLocation.dy - textSize.height / 2);
        point.labelRect = Rect.fromLTWH(
            labelLocation.dx - labelPadding,
            labelLocation.dy - labelPadding,
            textSize.width + (2 * labelPadding),
            textSize.height + (2 * labelPadding));
        _drawLabel(
            point.labelRect,
            labelLocation,
            label,
            null,
            canvas,
            series,
            point,
            pointIndex,
            seriesIndex,
            chart,
            dataLabelStyle,
            renderDatalabelRegions);
      } else {
        if (dataLabel.labelPosition == LabelPosition.inside) {
          labelLocation = _degreeToPoint(point.midAngle,
              (point.innerRadius + point.outerRadius) / 2, point.center);
          labelLocation = Offset(labelLocation.dx - (textSize.width / 2),
              labelLocation.dy - (textSize.height / 2));
          point.labelRect = Rect.fromLTWH(
              labelLocation.dx - labelPadding,
              labelLocation.dy - labelPadding,
              textSize.width + (2 * labelPadding),
              textSize.height + (2 * labelPadding));
          final bool isDataLabelCollide =
              _isCollide(point.labelRect, renderDatalabelRegions);
          if (smartLabel && isDataLabelCollide) {
            point.saturationRegionOutside = true;
            point.renderPosition = LabelPosition.outside;
            dataLabelStyle.color = dataLabel.textStyle.color ??
                _getSaturationColor(dataLabel.color ??
                    (dataLabel.useSeriesColor
                        ? point.fill
                        : (chart.backgroundColor ??
                            (chart._chartTheme.brightness == Brightness.light
                                ? Colors.white
                                : Colors.black))));
            _renderOutsideDataLabel(
                canvas,
                label,
                point,
                textSize,
                pointIndex,
                series,
                smartLabel,
                seriesIndex,
                chart,
                dataLabelStyle,
                renderDatalabelRegions);
          } else {
            point.renderPosition = LabelPosition.inside;
            dataLabelStyle.color = dataLabel.textStyle.color ??
                _getSaturationColor(dataLabel.color ?? point.fill);
            if (isDataLabelCollide
                ? (dataLabel.labelIntersectAction == LabelIntersectAction.hide)
                    ? false
                    : true
                : true) {
              _drawLabel(
                  point.labelRect,
                  labelLocation,
                  label,
                  null,
                  canvas,
                  series,
                  point,
                  pointIndex,
                  seriesIndex,
                  chart,
                  dataLabelStyle,
                  renderDatalabelRegions);
            }
          }
        } else {
          point.renderPosition = LabelPosition.outside;
          _renderOutsideDataLabel(
              canvas,
              label,
              point,
              textSize,
              pointIndex,
              series,
              smartLabel,
              seriesIndex,
              chart,
              dataLabelStyle,
              renderDatalabelRegions);
        }
      }
    }
  }
}

void _renderOutsideDataLabel(
    Canvas canvas,
    String label,
    _ChartPoint<dynamic> point,
    Size textSize,
    int pointIndex,
    CircularSeries<dynamic, dynamic> series,
    bool smartLabel,
    int seriesIndex,
    SfCircularChart chart,
    ChartTextStyle textStyle,
    List<Rect> renderDatalabelRegions) {
  Path connectorPath;
  Rect rect;
  Offset labelLocation;
  final EdgeInsets margin = series.dataLabelSettings.margin;
  final double marginLeft = margin.left;
  final double marginTop = margin.left;
  final double marginRight = margin.left;
  final double marginBottom = margin.left;
  const int lineLength = 10;
  final ConnectorLineSettings connector =
      series.dataLabelSettings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength =
      _percentToValue(connector.length, point.outerRadius);
  final Offset startPoint =
      _degreeToPoint(point.midAngle, point.outerRadius, point.center);
  final Offset endPoint = _degreeToPoint(
      point.midAngle, point.outerRadius + connectorLength, point.center);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  switch (point.dataLabelPosition) {
    case Position.right:
      connector.type == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx + lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx + lineLength, endPoint.dy);
      rect = Rect.fromLTWH(
          endPoint.dx + lineLength,
          endPoint.dy - (textSize.height / 2) - marginTop,
          textSize.width + marginLeft + marginRight,
          textSize.height + marginTop + marginBottom);
      break;
    case Position.left:
      connector.type == ConnectorType.line
          ? connectorPath.lineTo(endPoint.dx - lineLength, endPoint.dy)
          : connectorPath.quadraticBezierTo(
              endPoint.dx, endPoint.dy, endPoint.dx - lineLength, endPoint.dy);
      rect = Rect.fromLTWH(
          endPoint.dx - lineLength - marginRight - textSize.width - marginLeft,
          endPoint.dy - (textSize.height / 2) - marginTop,
          textSize.width + marginLeft + marginRight,
          textSize.height + marginTop + marginBottom);

      break;
  }

  point.labelRect = rect;
  labelLocation = Offset(
      rect.left + marginLeft, rect.top + rect.height / 2 - textSize.height / 2);
  final Rect containerRect = chart._chartState.chartAreaRect;
  if (series.dataLabelSettings.builder == null) {
    if (series.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.hide) {
      if (!_isCollide(rect, renderDatalabelRegions) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        _drawLabel(
            rect,
            labelLocation,
            label,
            connectorPath,
            canvas,
            series,
            point,
            pointIndex,
            seriesIndex,
            chart,
            textStyle,
            renderDatalabelRegions);
      }
    } else {
      _drawLabel(
          rect,
          labelLocation,
          label,
          connectorPath,
          canvas,
          series,
          point,
          pointIndex,
          seriesIndex,
          chart,
          textStyle,
          renderDatalabelRegions);
    }
  } else {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ?? point.fill
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }
}

void _drawLabel(
    Rect labelRect,
    Offset location,
    String label,
    Path connectorPath,
    Canvas canvas,
    CircularSeries<dynamic, dynamic> series,
    _ChartPoint<dynamic> point,
    int pointIndex,
    int seriesIndex,
    SfCircularChart chart,
    ChartTextStyle textStyle,
    List<Rect> renderDataLabelRegions) {
  Paint rectPaint;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  final ConnectorLineSettings connector = dataLabel.connectorLineSettings;
  if (connectorPath != null) {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ?? point.fill
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = series._renderer.getDataLabelStrokeWidth(
        series, point, pointIndex, seriesIndex, dataLabel.borderWidth);
    final Color labelFill = series._renderer.getDataLabelColor(
        series,
        point,
        pointIndex,
        seriesIndex,
        (dataLabel.color != null
            ? dataLabel.color
            : (dataLabel.useSeriesColor ? point.fill : dataLabel.color)));
    final Color strokeColor = series._renderer.getDataLabelStrokeColor(
        series,
        point,
        pointIndex,
        seriesIndex,
        dataLabel.borderColor.withOpacity(dataLabel.opacity));
    if (strokeWidth != null && strokeWidth > 0) {
      rectPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      _drawLabelRect(
          rectPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    if (labelFill != null) {
      _drawLabelRect(
          Paint()
            ..color = labelFill.withOpacity(dataLabel.opacity)
            ..style = PaintingStyle.fill,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    _drawText(canvas, label, location, textStyle, dataLabel.angle);
    renderDataLabelRegions.add(labelRect);
  }
}

void _drawLabelRect(
    Paint paint, Rect labelRect, double borderRadius, Canvas canvas) {
  canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)), paint);
}

// List<dynamic> isCurrentLabelCollideWithPreviousLabel(_ChartPoint<dynamic> point,
//     int pointIndex, List<_ChartPoint<dynamic>> points) {
//   bool isSamePosition;
//   Rect prevRect, currentRect;
//   final List<dynamic> collideDetails = <dynamic>[];
//   final _ChartPoint<dynamic> previousPoint =
//       pointIndex - 1 >= 0 ? points[pointIndex - 1] : null;
//   if (previousPoint != null) {
//     prevRect = previousPoint.labelRect;
//     currentRect = point.labelRect;
//     isSamePosition = point.dataLabelPosition == previousPoint.dataLabelPosition;
//     if (isSamePosition &&
//         point.dataLabelPosition == Position.right &&
//         (currentRect.top <= prevRect.top + prevRect.height) &&
//         (currentRect.left <= prevRect.left + prevRect.width)) {
//       collideDetails.add(true);
//       collideDetails
//           .add(((currentRect.top) - (prevRect.top + prevRect.height)).abs());
//       collideDetails
//           .add(((currentRect.left) - (prevRect.left + prevRect.width)).abs());
//     } else if (isSamePosition &&
//         point.dataLabelPosition == Position.left &&
//         (currentRect.top + currentRect.height >= prevRect.top &&
//             currentRect.left + currentRect.width >= prevRect.left)) {
//       collideDetails.add(true);
//       collideDetails
//           .add(((currentRect.top + currentRect.height) - prevRect.top).abs());
//       collideDetails
//           .add(((currentRect.left + currentRect.width) - prevRect.left).abs());
//     } else {
//       collideDetails.add(false);
//     }
//   } else {
//     collideDetails.add(false);
//   }
//   return collideDetails;
// }

void _findDataLabelPosition(_ChartPoint<dynamic> point) {
  if ((point.midAngle >= -90 && point.midAngle < 0) ||
      (point.midAngle >= 0 && point.midAngle < 90) ||
      (point.midAngle >= 270)) {
    point.dataLabelPosition = Position.right;
  } else {
    point.dataLabelPosition = Position.left;
  }
}
