import 'dart:ui';

import 'package:bbb_flutter/shared/ui_common.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title, description, cancelText, confirmText;
  final VoidCallback onPressed;

  ConfirmationDialog(
      {@required this.title,
      @required this.description,
      @required this.cancelText,
      @required this.confirmText,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: StyleFactory.corner,
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
      child: Container(
        padding: EdgeInsets.only(top: 24, left: 37, right: 37),
        decoration: DecorationFactory.dialogBackgroundDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: StyleFactory.title),
            SizedBox(height: 11),
            Text(
              description,
              style: StyleFactory.dialogContentStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: <Widget>[GestureDetector()],
            )
          ],
        ),
      ),
    );
  }
}
