import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class DepositPage extends StatefulWidget {
  DepositPage({Key key}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final GlobalKey _globalKey = GlobalKey();

  _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
  }

  Future<void> requestPermission(List<Permission> permissions, BuildContext context) async {
    final Map<Permission, PermissionStatus> permissionRequestResult = await permissions.request();
    print(permissionRequestResult);
    if (Platform.isAndroid) {
      if (permissionRequestResult[permissions[0]] == PermissionStatus.granted) {
        _capturePng();
        showNotification(context, false, I18n.of(context).savePhotoSuccess);
      }
    } else {
      print(permissions[1]);
      if (permissionRequestResult[permissions[1]] == PermissionStatus.granted) {
        _capturePng();
        showNotification(context, false, I18n.of(context).savePhotoSuccess);
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
  void initState() {
    super.initState();
    TextEditingController controller = TextEditingController();
    var _bloc = locator<UserManager>();

    Future.delayed(Duration(seconds: 1), () {
      showUnlockAndBiometricDialog(
          context: context,
          passwordEditor: controller,
          callback: () =>
              _bloc.getDepositAddress(name: _bloc.user.name, asset: AssetName.USDTERC20));
    });

    // if (locator.get<UserManager>().user.isLocked) {
    //   Future.delayed(Duration.zero, () {
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return DialogFactory.unlockDialog(context, controller: controller);
    //         }).then((value) async {
    //       if (value) {
    //         _bloc.getDepositAddress(name: _bloc.user.name, asset: AssetName.USDTERC20);
    //       }
    //     });
    //   });
    // } else {
    //   _bloc.getDepositAddress(name: _bloc.user.name, asset: AssetName.USDTERC20);
    // }
  }

  @override
  Widget build(BuildContext context) {
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
                if (value.user.isLocked) {
                  return Container();
                }
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
                              requestPermission([Permission.storage, Permission.photos], context);
                            }),
                        SizedBox(height: 20),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Palette.separatorColor),
                              borderRadius: BorderRadius.all(Radius.circular(5.0) //
                                  ),
                            ),
                            padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                Text(value.user.deposit.address),
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.bottomRight,
                                    child: Text("点击复制", style: StyleFactory.hyperText),
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: value.user.deposit.address));
                                    showNotification(context, false, "复制成功");
                                  },
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Palette.veryLightPinkTwo,
                            borderRadius: BorderRadius.all(Radius.circular(4.0) //
                                ),
                          ),
                          child: Text(I18n.of(context).depositParagraph,
                              style: StyleFactory.subTitleStyle),
                        )
                      ],
                    ));
              })),
        ));
  }
}
