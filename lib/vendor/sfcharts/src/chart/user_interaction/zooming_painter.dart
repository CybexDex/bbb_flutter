part of charts;

///Below class is for drawing zoomRct
class _ZoomRectPainter extends CustomPainter {
  _ZoomRectPainter({this.isRepaint, this.chart, ValueNotifier<int> notifier})
      : super(repaint: notifier);
  final bool isRepaint;
  SfCartesianChart chart;
  Paint strokePaint, fillPaint;

  @override
  void paint(Canvas canvas, Size size) {
    chart.zoomPanBehavior.onPaint(canvas);
  }

  void drawRect(Canvas canvas) {
    final Color fillColor = chart.zoomPanBehavior.selectionRectColor;
    strokePaint = Paint()
      ..color = chart.zoomPanBehavior.selectionRectBorderColor ??
          chart._chartTheme.selectionRectStrokeColor
      ..strokeWidth = chart.zoomPanBehavior.selectionRectBorderWidth
      ..style = PaintingStyle.stroke;
    chart.zoomPanBehavior.selectionRectBorderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;
    fillPaint = Paint()
      ..color = fillColor != null
          ? Color.fromRGBO(fillColor.red, fillColor.green, fillColor.blue, 0.3)
          : chart._chartTheme.selectionRectFillColor
      ..style = PaintingStyle.fill;
    strokePaint.isAntiAlias = false;
    if (chart.zoomPanBehavior._rectPath != null) {
      canvas.drawPath(
          _dashPath(
            chart.zoomPanBehavior._rectPath,
            dashArray: _CircularIntervalList<double>(<double>[5, 5]),
          ),
          strokePaint);
      canvas.drawRect(chart.zoomPanBehavior._zoomingRect, fillPaint);
      final Rect zoomRect = chart.zoomPanBehavior._zoomingRect;

      _CrosshairPainter crosshairPainter, _crosshairPainter;

      /// To show the interactive tooltip on selection zooming
      if (zoomRect.width != 0) {
        chart.crosshairBehavior._position =
            Offset(zoomRect.bottomRight.dx, zoomRect.bottomRight.dy);
        crosshairPainter = chart.crosshairBehavior._crosshairPainter =
            _CrosshairPainter(
                chart: chart,
                valueNotifier: chart._chartState.crosshairRepaintNotifier);
        crosshairPainter.drawCrosshair(canvas);
        chart.crosshairBehavior._position =
            Offset(zoomRect.topLeft.dx, zoomRect.topLeft.dy);
        _crosshairPainter = chart.crosshairBehavior._crosshairPainter =
            _CrosshairPainter(
                chart: chart,
                valueNotifier: chart._chartState.crosshairRepaintNotifier);
        _crosshairPainter.drawCrosshair(canvas);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => isRepaint;
}
