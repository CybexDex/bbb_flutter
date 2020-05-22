import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharePage extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      iconTheme: IconThemeData(
        color: Palette.backButtonColor, //change your color here
      ),
      centerTitle: true,
      title: Text(I18n.of(context).share, style: StyleFactory.title),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 0,
    );
    return Scaffold(
      appBar: appBar,
      body: RepaintBoundary(
        key: _globalKey,
        child: GestureDetector(
          onLongPress: () {
            showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text("保存到手机"),
                        onPressed: () {
                          requestPermission([Permission.storage, Permission.photos], context);
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(I18n.of(context).dialogCancelButton)),
                  );
                });
          },
          child: Stack(children: [
            Container(child: _getPoster()),
            Positioned(
              bottom: ScreenUtil.getInstance().setHeight(25),
              left: ScreenUtil.getInstance().setWidth(236),
              child: QrImage(
                gapless: false,
                backgroundColor: Colors.white,
                data: "https://bbb.cybex.io/?id=${locator.get<UserManager>().user.name}#/",
                size: ScreenUtil.getInstance().setWidth(90),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
  }

  Future<void> requestPermission(List<Permission> permissions, BuildContext context) async {
    final Map<Permission, PermissionStatus> permissionRequestResult = await permissions.request();
    if (Platform.isAndroid) {
      if (permissionRequestResult[permissions[0]] == PermissionStatus.granted) {
        _capturePng();
        showThemeToast("保存成功");
      }
    } else {
      if (permissionRequestResult[permissions[1]] == PermissionStatus.granted) {
        _capturePng();
        showThemeToast("保存成功");
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

  Widget _getPoster() {
    var random = Random();
    switch (random.nextInt(3)) {
      case 0:
        return showNetworkImageWrapper(
            url: locator.get<HomeViewModel>().shareImageList[0].url,
            fit: BoxFit.fitHeight,
            width: ScreenUtil.screenWidthDp,
            height: ScreenUtil.screenHeightDp);

      case 1:
        return showNetworkImageWrapper(
            url: locator.get<HomeViewModel>().shareImageList[1].url,
            fit: BoxFit.fitHeight,
            width: ScreenUtil.screenWidthDp,
            height: ScreenUtil.screenHeightDp);
      case 2:
        return showNetworkImageWrapper(
            url: locator.get<HomeViewModel>().shareImageList[2].url,
            fit: BoxFit.fitHeight,
            width: ScreenUtil.screenWidthDp,
            height: ScreenUtil.screenHeightDp);
      default:
        return showNetworkImageWrapper(
            url: locator.get<HomeViewModel>().shareImageList[0].url,
            fit: BoxFit.fitHeight,
            width: ScreenUtil.screenWidthDp,
            height: ScreenUtil.screenHeightDp);
    }
  }
}
