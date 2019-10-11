import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: "https://bbb2019.zendesk.com/hc/zh-cn",
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).helpCenter, style: StyleFactory.title),
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
        hidden: true);
  }
}
