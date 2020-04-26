import 'package:bbb_flutter/shared/palette.dart';
import 'package:flutter/material.dart';

import 'dimen.dart';

class StyleFactory {
  static const shadow = BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4), spreadRadius: 0, blurRadius: 12);

  static const corner = BorderRadius.all(Radius.circular(Dimen.corner));

  static const dialogCorner = BorderRadius.all(Radius.circular(Dimen.dialogCorner));

  static var title = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var larSubtitle = TextStyle(
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeLabelFontSize);

  static var transferStyleTitle = TextStyle(
      color: Palette.descColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var hugeTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.hugLabelFontSize);

  static var buttonTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.buttonPrimaryColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.fontSize18);

  static var navButtonTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.actionButtonColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleButtonFontSize);

  static var smallButtonTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var hintStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.hintTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var addReduceStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.hintTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var subTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var smallCellTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var cellTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var orderFormValueStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeLabelFontSize);

  static var cellBoldTitleStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var loginFontStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var dialogContentStyle = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var dialogContentTitleStyle = TextStyle(
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var dialogButtonFontStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeButtonFontSize);

  static var hyperText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var pinCodeText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.sunYellow,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var errorMessageText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buySellValueText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.titleColor,
      fontSize: Dimen.veryLargeLabelFontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400);

  static var buySellExplainText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.subTitleColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var buyDownText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buyUpText = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buyUpTitle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var buyDownTitle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.titleFontSize);

  static var buyUpCellLabel = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var buyDownCellLabel = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.middleLabelFontSize);

  static var cellDescLabel = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.descColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var buyUpOrderInfo = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeLabelFontSize);

  static var buyDownOrderInfo = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.shamrockGreen,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.largeLabelFontSize);

  static var inviteAmountStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.redOrange,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.inviteAmountFontSize);

  static var investmentAmountStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.investmentAmountColor,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  static var clickToRewardStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.clickToTryColor,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var clickToTryStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Palette.orageTry,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.verySmallLabelFontSize);

  static var inviteBadgeFontStyle = TextStyle(
      color: Palette.invitePromotionBadgeColor,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      fontSize: Dimen.smallLabelFontSize);

  //Forum
  static var forumTitleFontStyle = TextStyle(
    fontFamily: 'PingFangSC',
    color: Palette.forumItemTitleColor,
    fontSize: Dimen.forumTitleFontSize,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 1,
  );

  static var forumContentFontStyle = TextStyle(
    fontFamily: 'PingFangSC',
    color: Palette.forumItemContentColor,
    fontSize: Dimen.forumContentFontSize,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static var forumItemLabelFontStyle = TextStyle(
    fontFamily: 'PingFangSC',
    color: Palette.forumItemContentColor.withOpacity(0.6),
    fontSize: Dimen.forumLableFontSize,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  //pnl broadcast style
  static var pnlBroadCastStyle = TextStyle(
    fontFamily: 'PingFangSC',
    color: Colors.white,
    fontSize: Dimen.smallLabelFontSize,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}
