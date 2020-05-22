import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> param = ModalRoute.of(context).settings.arguments;
    print(param);
    return WebviewScaffold(
        url: param['needLogIn'] != null &&
                param['needLogIn'] &&
                locator.get<UserManager>().user.logined
            ? "${param['url']}${locator.get<UserManager>().user.name}"
            : param['url'],
        clearCache: true,
        ignoreSSLErrors: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(param['title'], style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          leading: GestureDetector(
            child: BackButtonIcon(),
            onTap: () {
              Navigator.of(context).pop();
              flutterWebViewPlugin.close();
            },
          ),
        ),
        withZoom: true,
        hidden: true,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    if (await flutterWebViewPlugin.canGoBack()) {
                      flutterWebViewPlugin.goBack();
                    } else {
                      Navigator.of(context).pop();
                      flutterWebViewPlugin.close();
                    }
                  }),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  flutterWebViewPlugin.goForward();
                },
              ),
              IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: () {
                  flutterWebViewPlugin.reload();
                },
              ),
            ],
          ),
        ));
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text(param['title'], style: StyleFactory.title),
    //     backgroundColor: Colors.white,
    //     brightness: Brightness.light,
    //     elevation: 0,
    //     iconTheme: IconThemeData(
    //       color: Palette.backButtonColor, //change your color here
    //     ),
    //   ),
    //   body: Builder(builder: (BuildContext context) {
    //     return WebView(
    //       initialUrl: param['url'],
    //       javascriptMode: JavascriptMode.unrestricted,
    //       gestureNavigationEnabled: true,
    //     );
    //   }),
    // );
  }
}
