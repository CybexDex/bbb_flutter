import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static CupertinoAlertDialog sellOrderDialog(BuildContext context,
      {String title,
      String contentText,
      String value,
      String errorText,
      String cancel,
      String confirm,
      VoidCallback onConfirmPressed}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        children: <Widget>[
          Text(contentText),
          Text(value),
          Container(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 16),
                    hintText: "请输入密码",
                    labelText: null,
                    fillColor: Palette.subTitleColor.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(style: BorderStyle.none, width: 0)),
                    errorText: "密码错误"),
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
          child: Text(cancel, style: StyleFactory.dialogButtonFontStyle),
        ),
        CupertinoDialogAction(
          onPressed: onConfirmPressed,
          child: Text(confirm, style: StyleFactory.dialogButtonFontStyle),
        )
      ],
    );
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
}
