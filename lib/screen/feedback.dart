import 'dart:io';

import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

class FeedBackScreen extends StatelessWidget {
  _capturePng() async {
    ByteData bytes = await rootBundle.load(R.resAssetsIconsWechat);

    final result = await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
    print(result);
  }

  Future<void> requestPermission(List<Permission> permissions, BuildContext context) async {
    final Map<Permission, PermissionStatus> permissionRequestResult = await permissions.request();
    print(permissionRequestResult);
    if (Platform.isAndroid) {
      if (permissionRequestResult[permissions[0]] == PermissionStatus.granted) {
        _capturePng();
        showToast(I18n.of(context).savePhotoSuccess, textPadding: EdgeInsets.all(20));
      }
    } else {
      print(permissions[1]);
      if (permissionRequestResult[permissions[1]] == PermissionStatus.granted) {
        _capturePng();
        showToast(I18n.of(context).savePhotoSuccess, textPadding: EdgeInsets.all(20));
      } else {
        showDialog(
            context: context,
            builder: (context) => DialogFactory.normalConfirmDialog(context,
                title: I18n.of(context).requestPermissionTitle,
                content: I18n.of(context).requestPermissionContent,
                onConfirmPressed: () => openAppSettings()));
      }
    }
  }

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
        body: Align(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 200,
                width: 200,
                child: Image.asset(R.resAssetsIconsWechat),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("您好，感谢支持！")),
              Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("新人福利添加客服微信，回复【奖励金】即可领取10U奖励金，可直接用于交易，盈利可提现哦～")),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 15, top: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: WidgetFactory.button(
                            color: Colors.lightBlueAccent,
                            data: "保存二维码",
                            onPressed: () {
                              requestPermission([Permission.storage, Permission.photos], context);
                            })),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        child: WidgetFactory.button(
                            color: Colors.lightBlueAccent,
                            data: "复制微信号",
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: "CybexServiceB"));
                              showToast("复制成功", textPadding: EdgeInsets.all(20));
                            })),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
