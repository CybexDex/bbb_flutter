import 'package:bbb_flutter/colors/palette.dart';
import 'package:flutter/material.dart';

import 'dimen.dart';

class StyleFactory {
  static const shadow = BoxShadow(
      color: Color.fromRGBO(102, 102, 102, 0.1),
      offset: Offset(0, 4),
      spreadRadius: 2,
      blurRadius: 8
  );

  static const corner = BorderRadius.all(Radius.circular(Dimen.corner));

  static const title = TextStyle(
    color: Palette.titleColor,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: Dimen.titleFontSize
  );

  static const buttonTitleStyle = TextStyle(
      color: Palette.buttonPrimaryColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeButtonFontSize
  );

  static const hintStyle = TextStyle(
      color: Palette.hintTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle:  FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize
  );

  static const subTitleStyle = const TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle:  FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize
  );

  static const cellTitleStyle = const TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle:  FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize
  );
  
  static const loginFontStyle = TextStyle(
    color: Palette.subTitleColor,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: Dimen.smallLabelFontSize
  );
}