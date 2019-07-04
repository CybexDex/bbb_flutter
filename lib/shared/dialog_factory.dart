import 'package:bbb_flutter/base/base_widget.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/logic/unlock_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class DialogFactory {
  static CupertinoAlertDialog logoutConfirmDialog(BuildContext context,
      {String title,
      String content,
      String cancel,
      String confirm,
      VoidCallback onConfirmPressed}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(cancel, style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text(confirm, style: StyleFactory.dialogButtonFontStyle),
            onPressed: onConfirmPressed)
      ],
    );
  }

  static Widget sellOrderDialog(BuildContext context,
      {String title,
      String contentText,
      String value,
      String errorText,
      String cancel,
      String confirm,
      VoidCallback onConfirmPressed}) {
    TextEditingController _textEditorController = TextEditingController();
    return BaseWidget<PnlViewModel>(
        model: PnlViewModel(
            api: locator.get(),
            um: locator.get(),
            mtm: locator.get(),
            refm: locator.get()),
        builder: (context, model, child) {
          return CupertinoAlertDialog(
            title: Text("验证密码"),
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
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 9, bottom: 9, left: 10, right: 16),
                          hintText: "请输入密码",
                          labelText: null,
                          fillColor: Palette.subTitleColor.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.none, width: 0)),
                          errorText:
                              model.shouldShowErrorMessage ? "密码错误" : ""),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("取消", style: StyleFactory.dialogButtonFontStyle),
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
                child: Text("确认", style: StyleFactory.dialogButtonFontStyle),
              )
            ],
          );
        });
  }

  static CupertinoAlertDialog successDialog(BuildContext context,
      {String value}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset("res/assets/icons/icSuccess.png"),
          Text("平仓成功", style: StyleFactory.dialogButtonFontStyle)
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

  static CupertinoAlertDialog failDialog(BuildContext context,
      {String content}) {
    return CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          Image.asset("res/assets/icons/icFail.png"),
          Text("平仓失败", style: StyleFactory.dialogButtonFontStyle)
        ],
      ),
    );
  }

  static Dialog customDialogTest() {
    return Dialog(
      child: Container(
        child: Text("test"),
      ),
    );
  }

  static Widget confirmDialog(BuildContext context, {TradeViewModel model}) {
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
                    "${(model.orderForm.totalAmount.amount - model.orderForm.fee.amount) / model.orderForm.investAmount} USDT"),
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
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text("取消", style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
            child: Text("确认", style: StyleFactory.dialogButtonFontStyle),
            onPressed: () {
              if (locator.get<UserManager>().user.isLocked) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogFactory.sellOrderDialog(context);
                    }).then((value) {
                  if (value) {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  }
                });
              }
            })
      ],
    );
  }
}
