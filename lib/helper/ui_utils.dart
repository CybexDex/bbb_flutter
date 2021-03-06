import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/pnl_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

Widget getPnlIcon(bool isN) {
  return isN
      ? SvgPicture.asset(
          R.resAssetsIconsIcMarketUp,
          width: 22,
          height: 16,
        )
      : SvgPicture.asset(
          R.resAssetsIconsIcMarketDown,
          width: 22,
          height: 16,
        );
}

openDialog(BuildContext context, OrderResponseModel model) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Builder(builder: (BuildContext context) {
        return PnlForm(model: model);
      });
    },
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
  ).then((v) {});
}

Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ).drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)),
    child: child,
  );
}

headerBuild(int month) {
  return Container(
    height: 30,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 16),
    color: Palette.appDividerBackgroudGreyColor,
    child: Text("$month月份"),
  );
}

showNetworkImageWrapper({String url, BoxFit fit = BoxFit.contain, double width, double height}) {
  if (url.contains(".svg")) {
    return SvgPicture.network(url, fit: fit);
  }
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    fadeInDuration: Duration.zero,
  );
}
