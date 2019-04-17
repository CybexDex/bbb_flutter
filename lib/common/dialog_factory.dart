import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogFactory {

  static CupertinoAlertDialog logoutConfirmDialog(BuildContext context,
      {String title, String content, String cancel, String confirm, VoidCallback onConfirmPressed}) {
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
            onPressed: onConfirmPressed
        )
      ],

    );
  }

  static CupertinoAlertDialog sellOrderDialog(BuildContext context,
  {String title, String contentText, String value, String errorText, String cancel, String confirm, VoidCallback onConfirmPressed}) {
    return CupertinoAlertDialog(
      title: Text(title),
      content:
        Column(
          children: <Widget>[
            Text(contentText),
            Text(value),
            Material(child:
            TextFormField(
              decoration: InputDecoration(
                fillColor: Palette.subTitleColor.withOpacity(0.1),
                filled: true,
                border: InputBorder.none,
                hintText: "请输入密",
              ),
            )),
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
}