import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';

AppBar homePageAppBar(BuildContext context) {
  return AppBar(
    actions: <Widget>[
      GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 20),
          child: Center(
              child: SvgPicture.asset(
            R.resAssetsIconsIcService,
            width: 24,
            height: 20,
          )),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(RoutePaths.Feedback);
        },
      )
    ],
    iconTheme: IconThemeData(
      color: Palette.backButtonColor, //change your color here
    ),
    centerTitle: true,
    title: Text("BBB",
        style: TextStyle(
          color: Palette.appBlack,
          fontSize: ScreenUtil.getInstance().setSp(22),
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.normal,
          letterSpacing: 2.4,
        )),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
