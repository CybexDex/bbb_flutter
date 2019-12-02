import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/pnl_form.dart';

Widget getPnlIcon(bool isN) {
  return isN
      ? Image.asset(R.resAssetsIconsIcUpRed14)
      : Image.asset(R.resAssetsIconsIcDownGreen14);
}

openDialog(BuildContext context, OrderResponseModel model) {
  Function callback = () {
    Navigator.of(context).pop();
  };
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Builder(builder: (BuildContext context) {
        return PnlForm(model: model, callback: callback);
      });
    },
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  ).then((v) {});
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return SlideTransition(
    position: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ).drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)),
    child: child,
  );
}
