import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class DepositPage extends StatelessWidget {
  DepositPage({Key key}) : super(key: key);

  final GlobalKey _globalKey = GlobalKey();

  _capturePng() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result = await ImageGallerySaver.save(byteData.buffer.asUint8List());
  }

  Future<void> requestPermission(
      List<PermissionGroup> permissions, BuildContext context) async {
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);
    print(permissionRequestResult);
    if (Platform.isAndroid) {
      if (permissionRequestResult[permissions[0]] == PermissionStatus.granted) {
        _capturePng();
        showToast(context, false, I18n.of(context).savePhotoSuccess);
      } else {}
    } else {
      print(permissions[1]);
      if (permissionRequestResult[permissions[1]] == PermissionStatus.granted) {
        _capturePng();
        showToast(context, false, I18n.of(context).savePhotoSuccess);
      } else {
        showDialog(
            context: context,
            builder: (context) => DialogFactory.normalConfirmDialog(context,
                title: I18n.of(context).requestPermissionTitle,
                content: I18n.of(context).requestPermissionContent,
                onConfirmPressed: () => PermissionHandler().openAppSettings()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = locator<UserManager>();
    _bloc.getDepositAddress(name: _bloc.user.name, asset: "USDT");

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).topUp, style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
              margin: Dimen.pageMargin,
              child: Consumer<UserManager>(builder: (context, value, child) {
                if (value.user.deposit == null) {
                  return SpinKitWave(
                    color: Palette.redOrange,
                    size: 50,
                  );
                }
                return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                      children: <Widget>[
                        RepaintBoundary(
                          key: _globalKey,
                          child: QrImage(
                            backgroundColor: Colors.white,
                            data: value.user.deposit.address,
                            size: 155,
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                            child: Text("保存二维码", style: StyleFactory.hyperText),
                            onTap: () {
                              requestPermission([
                                PermissionGroup.storage,
                                PermissionGroup.photos
                              ], context);
                            }),
                        SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Palette.separatorColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0) //
                                      ),
                            ),
                            padding: EdgeInsets.only(
                                left: 20, top: 20, right: 20, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                Text(value.user.deposit.address),
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.bottomRight,
                                    child: Text("点击复制",
                                        style: StyleFactory.hyperText),
                                  ),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: value.user.deposit.address));
                                    showToast(context, false, "复制成功");
                                  },
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Palette.veryLightPinkTwo,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0) //
                                    ),
                          ),
                          child: Text("请勿向该地址转账非USDT资产",
                              style: StyleFactory.subTitleStyle),
                        )
                      ],
                    ));
              })),
        ));
  }
}
