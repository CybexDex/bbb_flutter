import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CouponRulePage extends StatelessWidget {
  CouponRulePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return WebviewScaffold(
      url: "https://nxapi.cybex.io/v1/webpage/coupon_rule.html",
      appBar: AppBar(
        backgroundColor: Palette.appYellowOrange,
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
        centerTitle: true,
        title: Text("使用规则", style: StyleNewFactory.white15),
        brightness: Brightness.light,
        elevation: 0,
      ),
    );
  }
}
