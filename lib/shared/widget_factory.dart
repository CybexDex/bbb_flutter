import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'decoration_factory.dart';
import 'dimen.dart';

class WidgetFactory {
//  static buttonTopBottomPadding = Padding();
  static Padding buttonTopBottomPadding(Widget child,
          {double topPadding, double bottomPadding}) =>
      Padding(
          padding: EdgeInsets.only(
              top: topPadding != null ? topPadding : Dimen.buttonTopPadding,
              bottom: bottomPadding != null
                  ? bottomPadding
                  : Dimen.buttonTopPadding),
          child: child);

  static RaisedButton button(
      {String data,
      Color color,
      @required VoidCallback onPressed,
      double topPadding,
      double bottomPadding}) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimen.corner)),
        onPressed: onPressed,
        color: color,
        textColor: Colors.white,
        child: WidgetFactory.buttonTopBottomPadding(
            Text(data, style: StyleFactory.buttonTitleStyle),
            topPadding: topPadding,
            bottomPadding: bottomPadding));
  }

  static Widget smallButton({String data, @required VoidCallback onPressed}) {
    return GestureDetector(
      child: Container(
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
          side: BorderFactory.buttonBorder,
          borderRadius: BorderRadius.circular(Dimen.smallCorner),
        )),
        child: Text(
          data,
          style: StyleFactory.smallButtonTitleStyle,
          textAlign: TextAlign.center,
        ),
        padding: Dimen.smallButtonPadding,
      ),
      onTap: onPressed,
    );
  }

  static Container pageTopContainer({double height = 130}) {
    return Container(
      height: height,
      decoration: DecorationFactory.pageTopDecoration,
    );
  }
}
