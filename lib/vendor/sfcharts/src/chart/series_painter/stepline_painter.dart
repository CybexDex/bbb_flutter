part of charts;

class _StepLineChartPainter extends CustomPainter {
  _StepLineChartPainter({
    this.chart,
    this.series,
    this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    this.chartElementAnimation,
    ValueNotifier<num> notifier,
  }) : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final XyDataSeries<dynamic, dynamic> series;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    double animationFactor;
    Rect clipRect;

    /// Clip rect will be added for series.
    if (series._visible) {
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      if (series.animationDuration > 0) {
        _performLinearAnimation(series, canvas, animationFactor);
      }

      /// draw the step line series.
      series._draw(canvas);
      clipRect = _calculatePlotOffset(
          Rect.fromLTWH(
              chart._chartAxis._axisClipRect.left - series.markerSettings.width,
              chart._chartAxis._axisClipRect.top - series.markerSettings.height,
              chart._chartAxis._axisClipRect.right +
                  series.markerSettings.width,
              chart._chartAxis._axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(series._xAxis.plotOffset, series._yAxis.plotOffset));
    }
    canvas.restore();

    if (series._visible && (animationFactor > chart._seriesDurationFactor)) {
      canvas.clipRect(clipRect);
      _renderSeriesElements(canvas, series, chartElementAnimation);
    }
  }

  @override
  bool shouldRepaint(_StepLineChartPainter oldDelegate) => isRepaint;
}
