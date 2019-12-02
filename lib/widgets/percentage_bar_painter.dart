import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/widgets.dart';

class PercentageBarPainter extends CustomPainter {
  final double percentage;
  final BuildContext context;
  PercentageBarPainter({@required this.percentage, @required this.context});
  @override
  void paint(Canvas canvas, Size size) {
    var downBarPainter = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..color = Palette.shamrockGreen;

    var upBarPainter = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..color = Palette.redOrange;
    var upTextPainter = TextPainter(
        text: new TextSpan(
            text: percentage.toStringAsFixed(0) +
                "%" +
                I18n.of(context).percentageUp,
            style: TextStyle(
                color: Palette.redOrange,
                fontSize: 11.0,
                fontWeight: FontWeight.normal)),
        textDirection: TextDirection.ltr)
      ..layout();

    var downTextPainter = TextPainter(
        text: new TextSpan(
            text: (100 - percentage.round()).toStringAsFixed(0) +
                "%" +
                I18n.of(context).percentageDown,
            style: TextStyle(
                color: Palette.shamrockGreen,
                fontSize: 11.0,
                fontWeight: FontWeight.normal)),
        textDirection: TextDirection.ltr)
      ..layout();

    upTextPainter.paint(canvas, Offset(0, 0));
    Path path = Path()
      ..moveTo(0, upTextPainter.height + 1)
      ..lineTo(size.width * (percentage / 100), upTextPainter.height + 1)
      ..lineTo(size.width * (percentage / 100) - 2, upTextPainter.height + 5)
      ..lineTo(0, upTextPainter.height + 5)
      ..close();
    Path downPath = Path()
      ..moveTo(size.width, downTextPainter.height + 1)
      ..lineTo(size.width * (percentage / 100) + 4, downTextPainter.height + 1)
      ..lineTo(size.width * (percentage / 100) + 2, downTextPainter.height + 5)
      ..lineTo(size.width, downTextPainter.height + 5)
      ..close();
    canvas.drawPath(path, upBarPainter);
    canvas.drawPath(downPath, downBarPainter);
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //         Rect.fromLTWH(0, size.height, size.width, 4), Radius.circular(0)),
    //     downBarPainter);
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //         Rect.fromLTWH(0, size.height, size.width * (percentage / 100), 4),
    //         Radius.circular(0)),
    //     upBarPainter);
    downTextPainter.paint(
        canvas, Offset(size.width - downTextPainter.width, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
