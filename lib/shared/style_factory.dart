import 'package:bbb_flutter/shared/palette.dart';
import 'package:flutter/material.dart';

import 'dimen.dart';

class StyleFactory {
  static const shadow = BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      spreadRadius: 0,
      blurRadius: 12);

  static const corner = BorderRadius.all(Radius.circular(Dimen.corner));

  static const dialogCorner =
      BorderRadius.all(Radius.circular(Dimen.dialogCorner));

  static var title = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var hugeTitleStyle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.hugLabelFontSize);

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

  static var dialogContentStyle = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var dialogButtonFontStyle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeButtonFontSize);

  static var hyperText = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var pinCodeText = TextStyle(
      color: Palette.sunYellow,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var errorMessageText = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var buySellValueText = TextStyle(
      color: Palette.titleColor,
      fontSize: Dimen.veryLargeLabelFontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400);

  static var buySellExplainText = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var buyDownText = TextStyle(
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buyUpText = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buyUpTitle = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var buyDownTitle = TextStyle(
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var buyUpCellLabel = TextStyle(
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var buyDownCellLabel = TextStyle(
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var cellDescLabel = TextStyle(
      color: Palette.descColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);
}
