import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CouponRulePage extends StatelessWidget {
  CouponRulePage({Key key, String titile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return WebviewScaffold(
    //   appCacheEnabled: false,
    //   clearCache: true,
    //   clearCookies: true,
    //   url: "https://nxapi.cybex.io/v1/webpage/coupon_rule.html",
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     iconTheme: IconThemeData(
    //       color: Palette.backButtonColor, //change your color here
    //     ),
    //     actions: <Widget>[
    //       IconButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         icon: Icon(Icons.ac_unit),
    //       )
    //     ],
    //     centerTitle: true,
    //     title: Text("使用规则", style: StyleNewFactory.black15),
    //     brightness: Brightness.light,
    //     elevation: 0,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://nxapi.cybex.io/v1/webpage/coupon_rule.html',
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
        );
      }),
    );
  }
}
