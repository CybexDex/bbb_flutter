import 'package:bbb_flutter/shared/ui_common.dart';

class EmptyRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(R.resAssetsIconsIcEmpty),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(I18n.of(context).recordEmpty,
                    style: StyleFactory.hintStyle))
          ],
        ),
      ),
    );
  }
}
