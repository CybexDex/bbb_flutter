import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';

class DecorationFactory {
  static const cornerShadowDecoration = BoxDecoration(
      color: Palette.pagePrimaryColor,
      borderRadius: StyleFactory.corner,
      boxShadow: [StyleFactory.shadow]);

  static final pageTopDecoration = BoxDecoration(
      image: DecorationImage(
    image: AssetImage(R.resAssetsIconsMask),
    fit: BoxFit.fill,
  ));

  static var dialogBackgroundDecoration = BoxDecoration(
      color: Palette.pagePrimaryColor.withOpacity(0.8),
      borderRadius: StyleFactory.dialogCorner,
      boxShadow: [StyleFactory.shadow]);

  static var dialogChooseDecoration = BoxDecoration(
      color: Palette.pagePrimaryColor, borderRadius: StyleFactory.dialogCorner);
}

class BorderFactory {
  static const buttonBorder = BorderSide(color: Palette.redOrange, width: 0.5);
}
