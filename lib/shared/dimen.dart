import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimen {
  static double titleFontSize = ScreenUtil.getInstance().setSp(18.0);
  static double verySmallLabelFontSize = ScreenUtil.getInstance().setSp(10.0);
  static double smallLabelFontSize = ScreenUtil.getInstance().setSp(12.0);
  static double middleLabelFontSize = ScreenUtil.getInstance().setSp(14.0);
  static double largeLabelFontSize = ScreenUtil.getInstance().setSp(16.0);
  static double veryLargeLabelFontSize = ScreenUtil.getInstance().setSp(20.0);
  static double hugLabelFontSize = ScreenUtil.getInstance().setSp(24.0);
  static double inviteAmountFontSize = ScreenUtil.getInstance().setSp(24.0);

  static double largeButtonFontSize = ScreenUtil.getInstance().setSp(16.0);
  static double middleButtonFontSize = ScreenUtil.getInstance().setSp(14.0);
  static double smallButtonFontSize = ScreenUtil.getInstance().setSp(12.0);

  static const double smallCorner = 2.0;
  static const double corner = 4.0;
  static const double dialogCorner = 10.0;
  static const double buttonTopPadding = 14.0;

  static const double buttonSize = 44.0;
  static const double smallButtonSize = 18.0;

  static const pageMargin = EdgeInsets.only(left: 20, right: 20, top: 0);
  static const smallButtonPadding = EdgeInsets.fromLTRB(6, 1, 6, 1);
}
