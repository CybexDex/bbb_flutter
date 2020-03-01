import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../r.dart';

class EmptyOrder extends StatelessWidget {
  final bool _isLimit;
  EmptyOrder({Key key, bool isLimit})
      : _isLimit = isLimit,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          R.resAssetsIconsEmptyOrderLogo,
          width: 113,
          height: 118,
        ),
        Center(
          child: Text(
            _isLimit
                ? I18n.of(context).limitOrderEmpty
                : I18n.of(context).orderEmpty,
            style: StyleNewFactory.grey12Opacity60,
          ),
        )
      ],
    );
  }
}
