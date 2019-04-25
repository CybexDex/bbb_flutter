import 'package:bbb_flutter/colors/palette.dart';
import 'package:flutter/material.dart';

import 'dimen.dart';

class StyleFactory {
  static const shadow = BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      spreadRadius: 0,
      blurRadius: 12);

  static const corner = BorderRadius.all(Radius.circular(Dimen.corner));

  static var title = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var buttonTitleStyle = TextStyle(
      color: Palette.buttonPrimaryColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeButtonFontSize);

  static var navButtonTitleStyle = TextStyle(
      color: Palette.actionButtonColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleButtonFontSize);

  static var smallButtonTitleStyle = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var hintStyle = TextStyle(
      color: Palette.hintTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var subTitleStyle = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var smallCellTitleStyle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var cellTitleStyle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var cellBoldTitleStyle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var loginFontStyle = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);
}
