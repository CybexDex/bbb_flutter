import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/material.dart';

import 'image_factory.dart';

class DecorationFactory {
  static const cornerShadowDecoration = BoxDecoration(
      color: Palette.pagePrimaryColor,
      borderRadius: StyleFactory.corner,
      boxShadow: [StyleFactory.shadow]
  );

  static const pageTopDecoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImageFactory.pageTopBg,
        fit: BoxFit.fill,
      )
  );

  static var dialogBackgroundDecoration = BoxDecoration(
    color: Palette.pagePrimaryColor.withOpacity(0.8),
    borderRadius: StyleFactory.dialogCorner,
    boxShadow: [StyleFactory.shadow]
  );
}

class BorderFactory {
  static const buttonBorder = BorderSide(color: Palette.redOrange, width: 0.5);
}