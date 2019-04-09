import 'package:bbb_flutter/colors/palette.dart';
import 'package:flutter/material.dart';

class DecorationFactory {
  static const cornerShadowDecoration = BoxDecoration(
      color: Palette.pagePrimaryColor,
      borderRadius: StyleFactory.corner,
      boxShadow: [StyleFactory.shadow]
  );

  static const pageTopDecoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage("res/assets/images/mask.png"),
        fit: BoxFit.fill,
      )
  );
}

class WidgetFactory {
//  static buttonTopBottomPadding = Padding();
  static Padding buttonTopBottomPadding(Widget child) => Padding(padding: EdgeInsets.only(top: 14, bottom: 14), child: child);

  static const pageMargin = EdgeInsets.only(left: 20, right: 20);

  static RaisedButton button({String data, Color color, @required VoidCallback onPressed}) {
    return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        onPressed: onPressed,
        color: color,
        textColor: Colors.white,
        child: WidgetFactory.buttonTopBottomPadding(Text(data, style: StyleFactory.buttonTitleStyle)));
  }

  static Container pageTopContainer({double height = 130}) {
    return Container(
      height: height,
      decoration: DecorationFactory.pageTopDecoration,
    );
  }


}

class StyleFactory {
  static const shadow = BoxShadow(
      color: Color.fromRGBO(102, 102, 102, 0.1),
      offset: Offset(0, 4),
      spreadRadius: 2,
      blurRadius: 8
  );

  static const corner = BorderRadius.all(Radius.circular(10));

  static const title = TextStyle(
    color: Palette.buttonPrimaryColor,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 18.0
  );

  static const buttonTitleStyle = TextStyle(
      color: Palette.buttonPrimaryColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: 16.0
  );

  static const hintStyle = const TextStyle(
      color: Palette.hintTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );
}