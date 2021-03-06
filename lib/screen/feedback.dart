import 'dart:io';

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
        showThemeToast(I18n.of(context).savePhotoSuccess);
      }
    } else {
      print(permissions[1]);
      if (permissionRequestResult[permissions[1]] == PermissionStatus.granted) {
        _capturePng();
        showThemeToast(I18n.of(context).savePhotoSuccess);
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
                  margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(60)),
                  height: ScreenUtil.getInstance().setWidth(150),
                  width: ScreenUtil.getInstance().setWidth(150),
                  child: showNetworkImageWrapper(
                      url:
                          locator.get<HomeViewModel>().imageConfigResponse.result.assistantBicode)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(20),
              ),
              Container(
                  margin: EdgeInsets.only(
                      right: ScreenUtil.getInstance().setWidth(20),
                      left: ScreenUtil.getInstance().setWidth(20)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    locator.get<HomeViewModel>().imageConfigResponse.result.assistantHint,
                    style: StyleNewFactory.black15,
                  )),
              Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20),
                    bottom: ScreenUtil.getInstance().setHeight(15),
                    top: ScreenUtil.getInstance().setHeight(15)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: WidgetFactory.button(
                            color: Palette.appYellowOrange,
                            data: "保存二维码",
                            topPadding: ScreenUtil.getInstance().setHeight(10),
                            bottomPadding: ScreenUtil.getInstance().setHeight(10),
                            onPressed: () {
                              requestPermission([Permission.storage, Permission.photos], context);
                            })),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        child: WidgetFactory.button(
                            color: Palette.appYellowOrange,
                            data: "复制微信号",
                            topPadding: ScreenUtil.getInstance().setHeight(10),
                            bottomPadding: ScreenUtil.getInstance().setHeight(10),
                            onPressed: () async {
                              Clipboard.setData(ClipboardData(
                                  text: locator
                                      .get<HomeViewModel>()
                                      .imageConfigResponse
                                      .result
                                      .assistantWechatId));
                              showThemeToast("复制成功");
                            })),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
