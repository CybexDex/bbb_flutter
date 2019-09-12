import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showToast(BuildContext context, bool isFaild, String content,
    {Function callback}) {
  showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        return isFaild
            ? DialogFactory.failDialog(context, content: content)
            : DialogFactory.successDialog(context, content: content);
      }).then((value) {
    if (callback != null) {
      callback();
    }
  });
}

showLoading(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animate1, animate2) {
      return Center(
        child: SpinKitWave(
          color: Palette.redOrange,
          size: 50,
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: "dd",
    barrierColor: Colors.white10,
    transitionDuration: const Duration(milliseconds: 10),
  );
}
