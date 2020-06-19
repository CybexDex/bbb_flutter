import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  int position = 0;
  double progress = 0;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> param = ModalRoute.of(context).settings.arguments;
    // return WebviewScaffold(
    //     url: param['needLogIn'] != null &&
    //             param['needLogIn'] &&
    //             locator.get<UserManager>().user.logined
    //         ? "${param['url']}${locator.get<UserManager>().user.name}"
    //         : param['url'],
    //     clearCache: true,
    //     ignoreSSLErrors: true,
    //     appBar: AppBar(
    //       iconTheme: IconThemeData(
    //         color: Palette.backButtonColor, //change your color here
    //       ),
    //       centerTitle: true,
    //       title: Text(param['title'], style: StyleFactory.title),
    //       backgroundColor: Colors.white,
    //       brightness: Brightness.light,
    //       elevation: 0,
    //       leading: GestureDetector(
    //         child: BackButtonIcon(),
    //         onTap: () {
    //           Navigator.of(context).pop();
    //           flutterWebViewPlugin.close();
    //         },
    //       ),
    //     ),
    //     withZoom: true,
    //     hidden: true,
    //     bottomNavigationBar: BottomAppBar(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[
    //           IconButton(
    //               icon: const Icon(Icons.arrow_back_ios),
    //               onPressed: () async {
    //                 if (await flutterWebViewPlugin.canGoBack()) {
    //                   flutterWebViewPlugin.goBack();
    //                 } else {
    //                   Navigator.of(context).pop();
    //                   flutterWebViewPlugin.close();
    //                 }
    //               }),
    //           IconButton(
    //             icon: const Icon(Icons.arrow_forward_ios),
    //             onPressed: () {
    //               flutterWebViewPlugin.goForward();
    //             },
    //           ),
    //           IconButton(
    //             icon: const Icon(Icons.autorenew),
    //             onPressed: () {
    //               flutterWebViewPlugin.reload();
    //             },
    //           ),
    //         ],
    //       ),
    //     ));

    // return Scaffold(
    //     appBar: AppBar(
    //       centerTitle: true,
    //       title: Text(param['title'], style: StyleFactory.title),
    //       backgroundColor: Colors.white,
    //       brightness: Brightness.light,
    //       elevation: 0,
    //       iconTheme: IconThemeData(
    //         color: Palette.backButtonColor, //change your color here
    //       ),
    //     ),
    //     body: IndexedStack(
    //       index: position,
    //       children: <Widget>[
    //         WebView(
    //           initialUrl: param['url'],
    //           javascriptMode: JavascriptMode.unrestricted,
    //           gestureNavigationEnabled: true,
    //           onPageStarted: (url) => {
    //             setState(() {
    //               position = 0;
    //             })
    //           },
    //           onWebResourceError: (error) {
    //             print("error------------------------");
    //           },
    //           onPageFinished: (url) {
    //             print("sdfsdfsdfsdf");
    //             setState(() {
    //               position = 0;
    //             });
    //           },
    //         ),
    //         SpinKitWave(
    //           color: Palette.appYellowOrange,
    //           size: 10,
    //         )
    //       ],
    //     ));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(param['title'], style: StyleFactory.title),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        Container(
            // padding: EdgeInsets.all(3),
            child: progress < 1.0
                ? SizedBox(
                    height: 1,
                    child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Palette.appYellowOrange)))
                : Container()),
        Expanded(
          child: Container(
            child: InAppWebView(
                initialUrl: param['needLogIn'] != null &&
                        param['needLogIn'] &&
                        locator.get<UserManager>().user.logined
                    ? "${param['url']}${locator.get<UserManager>().user.name}"
                    : param['url'],
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true, useShouldOverrideUrlLoading: true),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                  controller.clearCache();
                  print("onWebViewCreated");
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("onLoadStart $url");
                },
                shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                  print("shouldOverrideUrlLoading");
                  return ShouldOverrideUrlLoadingAction.ALLOW;
                },
                onLoadStop: (InAppWebViewController controller, String url) async {
                  print("onLoadStop $url");
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                },
                onUpdateVisitedHistory:
                    (InAppWebViewController controller, String url, bool androidIsReload) {
                  print("onUpdateVisitedHistory $url");
                }),
          ),
        ),
        BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (webView != null) {
                  webView.goBack();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                if (webView != null) {
                  webView.goForward();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                if (webView != null) {
                  webView.reload();
                }
              },
            ),
          ],
        )),
      ])),
    );
  }
}
