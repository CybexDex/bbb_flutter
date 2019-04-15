import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:flutter/material.dart';

import 'decoration_factory.dart';
import 'dimen.dart';

class WidgetFactory {
//  static buttonTopBottomPadding = Padding();
  static Padding buttonTopBottomPadding(Widget child) => Padding(
      padding: EdgeInsets.only(
          top: Dimen.buttonTopPadding, bottom: Dimen.buttonTopPadding),
      child: child);

  static RaisedButton button(
      {String data, Color color, @required VoidCallback onPressed}) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimen.corner)),
        onPressed: onPressed,
        color: color,
        textColor: Colors.white,
        child: WidgetFactory.buttonTopBottomPadding(
            Text(data, style: StyleFactory.buttonTitleStyle)));
  }

  static Widget smallButton(
      {String data, @required VoidCallback onPressed}) {
    return ButtonTheme(height: Dimen.smallButtonSize, minWidth: 0, child: RaisedButton(
        elevation: 0,
        padding: Dimen.smallButtonPadding,
        shape: RoundedRectangleBorder(
          side: BorderFactory.buttonBorder,
          borderRadius: BorderRadius.circular(Dimen.smallCorner),),
        onPressed: onPressed,
        color: Colors.white,
        textColor: Palette.redOrange,
        child: Text(data, style: StyleFactory.smallButtonTitleStyle)));
  }

  static Container pageTopContainer({double height = 130}) {
    return Container(
      height: height,
      decoration: DecorationFactory.pageTopDecoration,
    );
  }
}
