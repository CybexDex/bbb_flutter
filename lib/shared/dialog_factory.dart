import 'package:bbb_flutter/base/base_widget.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class DialogFactory {
  static CupertinoAlertDialog normalConfirmDialog(BuildContext context,
      {String title,
      String content,
      String cancel,
      String confirm,
      bool isForce = false,
      Function onConfirmPressed}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: isForce
          ? <Widget>[
              CupertinoDialogAction(
                  child: Text(I18n.of(context).confirm,
                      style: StyleFactory.dialogButtonFontStyle),
                  onPressed: onConfirmPressed)
            ]
          : <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(I18n.of(context).dialogCancelButton,
                    style: StyleFactory.dialogButtonFontStyle),
              ),
              CupertinoDialogAction(
                  child: Text(I18n.of(context).confirm,
                      style: StyleFactory.dialogButtonFontStyle),
                  onPressed: onConfirmPressed)
            ],
    );
  }

  static Widget unlockDialog(BuildContext context,
      {String title,
      String contentText,
      String value,
      String errorText,
      String cancel,
      String confirm,
      VoidCallback onConfirmPressed,
      TextEditingController controller}) {
    TextEditingController _textEditorController = controller;
    return BaseWidget<PnlViewModel>(
        model: PnlViewModel(
            api: locator.get(),
            um: locator.get(),
            mtm: locator.get(),
            refm: locator.get()),
        builder: (context, model, child) {
          return CupertinoAlertDialog(
            title: Text(I18n.of(context).dialogCheckPassword),
            content: Column(
              children: <Widget>[
                contentText != null ? Text(contentText) : Container(),
                value != null ? Text(value) : Container(),
                Container(
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                    child: TextField(
                      controller: _textEditorController,
                      enableInteractiveSelection: true,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 9, bottom: 9, left: 10, right: 16),
                          hintText: I18n.of(context).passwordHint,
                          labelText: null,
                          fillColor: Palette.subTitleColor.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.none, width: 0)),
                          errorText: model.shouldShowErrorMessage
                              ? I18n.of(context).passwordError
                              : ""),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
                child: Text(I18n.of(context).dialogCancelButton,
                    style: StyleFactory.dialogButtonFontStyle),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  bool result = await model.checkPassword(
                      name: locator.get<UserManager>().user.name,
                      password: _textEditorController.text);
                  if (result) {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  }
                },
                child: Text(I18n.of(context).confirm,
                    style: StyleFactory.dialogButtonFontStyle),
              )
            ],
          );
        });
  }

  static Widget addRefererDialog(BuildContext context,
      {String title,
      String contentText,
      String value,
      String errorText,
      String cancel,
      String confirm,
      VoidCallback onConfirmPressed,
      TextEditingController controller,
      TextEditingController controllerForPassword}) {
    TextEditingController _textEditorController = controller;
    return CupertinoAlertDialog(
      title: Text(I18n.of(context).inviteAddReferer),
      content: Column(
        children: <Widget>[
          contentText != null ? Text(contentText) : Container(),
          value != null ? Text(value) : Container(),
          Container(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
              child: TextField(
                controller: _textEditorController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 16),
                    hintText: I18n.of(context).inviteInputPinCode,
                    labelText: null,
                    fillColor: Palette.subTitleColor.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(style: BorderStyle.none, width: 0)),
                    errorText: ""),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop([false]);
          },
          child: Text(I18n.of(context).dialogCancelButton,
              style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (locator.get<UserManager>().user.isLocked) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return KeyboardAvoider(
                      child: DialogFactory.unlockDialog(context,
                          controller: controllerForPassword),
                      autoScroll: true,
                    );
                  }).then((value) {
                if (value) {
                  Navigator.of(context, rootNavigator: true)
                      .pop([true, _textEditorController.text]);
                }
              });
            } else {
              Navigator.of(context, rootNavigator: true)
                  .pop([true, _textEditorController.text]);
            }
          },
          child: Text(I18n.of(context).confirm,
              style: StyleFactory.dialogButtonFontStyle),
        )
      ],
    );
  }

  static CupertinoAlertDialog successDialogDetail(BuildContext context,
      {String value}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset("res/assets/icons/icSuccess.png"),
          Text(I18n.of(context).closeOut,
              style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
      content: Column(
        children: <Widget>[
          Text("此次平仓收益", style: StyleFactory.dialogContentStyle),
          Text(value, style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
    );
  }

  static CupertinoAlertDialog successDialog(BuildContext context,
      {String content}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset(R.resAssetsIconsIcSuccess),
          Text(content, style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
    );
  }

  static CupertinoAlertDialog failDialog(BuildContext context,
      {String content}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset(R.resAssetsIconsIcFail),
          Text(content, style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
    );
  }

  static Widget confirmDialog(BuildContext context,
      {TradeViewModel model, TextEditingController controller}) {
    return CupertinoAlertDialog(
      title: Text("买入确认"),
      content: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("预估价格"),
                Text(
                    "${((model.orderForm.totalAmount.amount - model.orderForm.fee.amount) / model.orderForm.investAmount).toStringAsFixed(4)} USDT"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("投资份数"),
                Text(model.orderForm.investAmount.toString() + "份"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("手续费"),
                Text("${model.orderForm.fee.amount.toStringAsFixed(4)} USDT"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("投资总额"),
                Text(
                    "${model.orderForm.totalAmount.amount.toStringAsFixed(4)} USDT"),
              ],
            ),
            Row(
              children: <Widget>[
                Image.asset(R.resAssetsIconsIcWarn),
                Text(
                  "由于价格波动，买入可能失败",
                  style: StyleFactory.errorMessageText,
                )
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
          child: Text(I18n.of(context).dialogCancelButton,
              style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text(I18n.of(context).confirm,
                style: StyleFactory.dialogButtonFontStyle),
            onPressed: () {
              if (locator.get<UserManager>().user.isLocked) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return KeyboardAvoider(
                        child: DialogFactory.unlockDialog(context,
                            controller: controller),
                        autoScroll: true,
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  }
                });
              } else {
                if (locator.get<UserManager>().user.testAccountResponseModel !=
                    null) {
                  CybexFlutterPlugin.setDefaultPrivKey(locator
                      .get<UserManager>()
                      .user
                      .testAccountResponseModel
                      .privateKey);
                }
                Navigator.of(context, rootNavigator: true).pop(true);
              }
            })
      ],
    );
  }

  static Widget closeOutConfirmDialog(BuildContext context,
      {String value, String pnl, TextEditingController controller}) {
    return CupertinoAlertDialog(
      title: Text(I18n.of(context).closeOut),
      content: Column(
        children: <Widget>[
          Text(I18n.of(context).dialogSellContent),
          SizedBox(height: 1),
          Text(value + AssetName.USDT),
          SizedBox(height: 1),
          Text(I18n.of(context).pnl),
          SizedBox(height: 1),
          Text(pnl + AssetName.USDT),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
          child: Text(I18n.of(context).dialogCancelButton,
              style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text(I18n.of(context).confirm,
                style: StyleFactory.dialogButtonFontStyle),
            onPressed: () async {
              if (locator.get<UserManager>().user.isLocked) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return KeyboardAvoider(
                        child: DialogFactory.unlockDialog(context,
                            controller: controller),
                        autoScroll: true,
                      );
                    }).then((value) {
                  if (value) {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  }
                });
              } else {
                if (locator.get<UserManager>().user.testAccountResponseModel !=
                    null) {
                  await CybexFlutterPlugin.setDefaultPrivKey(locator
                      .get<UserManager>()
                      .user
                      .testAccountResponseModel
                      .privateKey);
                }
                Navigator.of(context, rootNavigator: true).pop(true);
              }
            })
      ],
    );
  }

  static Widget addsDialog(BuildContext context,
      {String url, String img, Function onImageTap}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: onImageTap, child: Image.network(img, width: 270)),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              R.resAssetsIconsIcAddsCancel,
            ),
          ),
        ],
      ),
    );
  }
}
