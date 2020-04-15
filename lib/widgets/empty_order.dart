import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../r.dart';

class EmptyOrder extends StatelessWidget {
  final String _message;
  EmptyOrder({Key key, String message})
      : _message = message,
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
            _message,
            style: StyleNewFactory.grey12Opacity60,
          ),
        )
      ],
    );
  }
}
