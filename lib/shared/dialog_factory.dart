import 'package:animated_widgets/animated_widgets.dart';
import 'package:bbb_flutter/base/base_widget.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/logic/coupon_order_view_model.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:bbb_flutter/widgets/shake_animation.dart';
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
      content: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            content,
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(height: 1.5),
          )),
      actions: isForce
          ? <Widget>[
              CupertinoDialogAction(
                  child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
                  onPressed: onConfirmPressed)
            ]
          : <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
                child: Text(I18n.of(context).dialogCancelButton,
                    style: StyleFactory.dialogButtonFontStyle),
              ),
              CupertinoDialogAction(
                  child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
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
      ValueChanged<PnlViewModel> onConfirmPressed,
      TextEditingController controller}) {
    TextEditingController _textEditorController = controller;
    return BaseWidget<PnlViewModel>(
        model: PnlViewModel(
            api: locator.get(), um: locator.get(), mtm: locator.get(), refm: locator.get()),
        builder: (context, model, child) {
          return CupertinoAlertDialog(
            title: Text(I18n.of(context).dialogCheckPassword),
            content: Column(
              children: <Widget>[
                contentText != null
                    ? Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          contentText,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(height: 1.5),
                        ))
                    : Container(),
                value != null ? Text(value) : Container(),
                ShakeAnimation(
                  enabled: model.shouldShowErrorMessage,
                  duration: Duration(milliseconds: 1500),
                  shakeAngle: Rotation.deg(x: 20),
                  curve: Curves.ease,
                  child: Container(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      child: TextField(
                        controller: _textEditorController,
                        enableInteractiveSelection: true,
                        obscureText: model.isObscure,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 16),
                          hintText: I18n.of(context).passwordHint,
                          labelText: null,
                          fillColor: Palette.subTitleColor.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none, width: 0)),
                          errorText:
                              model.shouldShowErrorMessage ? I18n.of(context).passwordError : "",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              model.changeObscure();
                            },
                            child: Icon(
                              model.isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Palette.appGrey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
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
                  if (!locator.get<UserManager>().hasRegisterPush) {
                    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
                    int timeout = expir + 5 * 60;

                    locator.get<BBBAPI>().registerPush(
                        regId: locator.get<RefManager>().pushRegId,
                        accountName: locator.get<UserManager>().user.account.name,
                        timeout: timeout);
                  }
                  if (onConfirmPressed != null) {
                    onConfirmPressed(model);
                    return;
                  }
                  bool result = await model.checkPassword(
                      name: locator.get<UserManager>().user.name,
                      password: _textEditorController.text);

                  if (result) {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  }
                },
                child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
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
                    contentPadding: EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 16),
                    hintText: I18n.of(context).inviteInputPinCode,
                    labelText: null,
                    fillColor: Palette.subTitleColor.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none, width: 0)),
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
          child:
              Text(I18n.of(context).dialogCancelButton, style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (locator.get<UserManager>().user.isLocked) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return KeyboardAvoider(
                      child: DialogFactory.unlockDialog(context, controller: controllerForPassword),
                      autoScroll: true,
                    );
                  }).then((value) {
                if (value) {
                  Navigator.of(context, rootNavigator: true)
                      .pop([true, _textEditorController.text]);
                }
              });
            } else {
              Navigator.of(context, rootNavigator: true).pop([true, _textEditorController.text]);
            }
          },
          child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
        )
      ],
    );
  }

  static CupertinoAlertDialog successDialogDetail(BuildContext context, {String value}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset("res/assets/icons/icSuccess.png"),
          Text(I18n.of(context).closeOut, style: StyleFactory.dialogButtonFontStyle)
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

  static CupertinoAlertDialog successDialog(BuildContext context, {String content}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset(R.resAssetsIconsIcSuccess),
          Text(content, style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
    );
  }

  static CupertinoAlertDialog failDialog(BuildContext context, {String content}) {
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
      {dynamic model, TextEditingController controller, VoidCallback onConfirmed}) {
    return CupertinoAlertDialog(
      title: Text("买入确认"),
      content: model is CouponOrderViewModel
          ? Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("预估价格"),
                      Text("${model.amountPerContract.toStringAsFixed(4)} USDT"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("投资份数"),
                      Text(model.couponAmount.toStringAsFixed(0) + "份"),
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
                          "${(model.amountPerContract * model.couponAmount + model.orderForm.fee.amount).toStringAsFixed(4)} USDT"),
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
            )
          : Container(
              child: Column(
                children: <Widget>[
                  (!model.isMarket)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(I18n.of(context).limitOrderPrice),
                            Text("${model.orderForm.predictPrice} USDT"),
                          ],
                        )
                      : Container(),
                  (!model.isMarket)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(I18n.of(context).forceClosePrice),
                            Text("${model.orderForm.selectedItem.strikeLevel} USDT"),
                          ],
                        )
                      : Container(),
                  (!model.isMarket)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(I18n.of(context).actLevel),
                            Text("${model.actLevel.toStringAsFixed(1)}"),
                          ],
                        )
                      : Container(),
                  (model.isMarket)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("预估价格"),
                            Text(
                                "${((model.orderForm.totalAmount.amount - model.orderForm.fee.amount) / model.orderForm.investAmount).toStringAsFixed(4)} USDT"),
                          ],
                        )
                      : Container(),
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
                      Text("${model.orderForm.totalAmount.amount.toStringAsFixed(4)} USDT"),
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
          child:
              Text(I18n.of(context).dialogCancelButton, style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
            onPressed: () {
              if (onConfirmed != null) {
                onConfirmed();
              } else {
                if (locator.get<UserManager>().user.isLocked) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return KeyboardAvoider(
                          child: DialogFactory.unlockDialog(context, controller: controller),
                          autoScroll: true,
                        );
                      }).then((value) {
                    if (value) {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    }
                  });
                } else {
                  if (locator.get<UserManager>().user.testAccountResponseModel != null) {
                    CybexFlutterPlugin.setDefaultPrivKey(
                        locator.get<UserManager>().user.testAccountResponseModel.privkey);
                  }
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              }
            })
      ],
    );
  }

  static Widget closeOutConfirmDialog(BuildContext context,
      {String value, String pnl, TextEditingController controller, VoidCallback callback}) {
    return CupertinoAlertDialog(
      title: Text(I18n.of(context).closeOut,
          style: TextStyle(
            color: Palette.titleColor,
            fontSize: ScreenUtil.getInstance().setSp(16),
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          )),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              I18n.of(context).dialogSellContent,
              style: StyleFactory.dialogContentStyle,
            ),
            SizedBox(height: 5),
            Text(value + AssetName.USDT, style: StyleFactory.dialogContentTitleStyle),
            SizedBox(height: 8),
            pnl != null
                ? Text(I18n.of(context).pnl, style: StyleFactory.dialogContentStyle)
                : Container(),
            SizedBox(height: 5),
            pnl != null
                ? Text(
                    pnl + AssetName.USDT,
                    style: StyleFactory.dialogContentTitleStyle,
                  )
                : Container(),
          ],
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
          child:
              Text(I18n.of(context).dialogCancelButton, style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text(I18n.of(context).confirm, style: StyleFactory.dialogButtonFontStyle),
            onPressed: () async {
              if (callback != null) {
                callback();
              } else {
                if (locator.get<UserManager>().user.isLocked) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return KeyboardAvoider(
                          child: DialogFactory.unlockDialog(context, controller: controller),
                          autoScroll: true,
                        );
                      }).then((value) {
                    if (value) {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    }
                  });
                } else {
                  if (locator.get<UserManager>().user.testAccountResponseModel != null) {
                    await CybexFlutterPlugin.setDefaultPrivKey(
                        locator.get<UserManager>().user.testAccountResponseModel.privkey);
                  }
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              }
            })
      ],
    );
  }

  static Widget addsDialog(BuildContext context, {String url, String img, Function onImageTap}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: onImageTap,
            child: showNetworkImageWrapper(url: img, width: 270),
          ),
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
