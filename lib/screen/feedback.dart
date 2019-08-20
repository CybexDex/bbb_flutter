import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedBackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text("小助手", style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: WebView(
            initialUrl:
                "https://v2.zopim.com/widget/livechat.html?api_calls=%5B%5D&hostname=support.cybex.io&key=SUWGxax4XVEoXhYgk3LJi8Wqw2tSeRma&lang=zh-cn&",
            javascriptMode: JavascriptMode.unrestricted));
  }
}
