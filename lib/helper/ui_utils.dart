import 'package:bbb_flutter/shared/ui_common.dart';

Widget getPnlIcon(bool isN) {
  return isN
      ? Image.asset(R.resAssetsIconsIcUpRed14)
      : Image.asset(R.resAssetsIconsIcDownGreen14);
}
