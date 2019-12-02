import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../r.dart';

class EmptyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: SvgPicture.asset(
        R.resAssetsIconsIcNoStoke,
        width: 113,
        height: 118,
      )),
    );
  }
}
