import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CouponRulePage extends StatelessWidget {
  CouponRulePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appCacheEnabled: false,
      clearCache: true,
      clearCookies: true,
      url: "https://nxapi.cybex.io/v1/webpage/coupon_rule.html",
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
        centerTitle: true,
        title: Text("使用规则", style: StyleNewFactory.black15),
        brightness: Brightness.light,
        elevation: 0,
      ),
    );
  }
}
