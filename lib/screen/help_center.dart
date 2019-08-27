import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).helpCenter, style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: WebView(
            initialUrl: "https://bbb2019.zendesk.com/hc/zh-cn",
            javascriptMode: JavascriptMode.unrestricted));
  }
}
