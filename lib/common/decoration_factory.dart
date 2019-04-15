import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/style_factory.dart';
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