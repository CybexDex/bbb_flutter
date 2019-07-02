import 'package:bbb_flutter/shared/ui_common.dart';

class IStep extends StatelessWidget {
  final GestureTapCallback minusOnTap;
  final GestureTapCallback plusOnTap;
  final String text;

  IStep({Key key, this.text, this.minusOnTap, this.plusOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Container(
                child: Image.asset(R.resAssetsIconsIcReduce),
              ),
              onTap: minusOnTap),
          Text(
            "$text",
            style: StyleFactory.smallCellTitleStyle,
          ),
          GestureDetector(
              child: Container(
                child: Image.asset(R.resAssetsIconsIcAdd),
              ),
              onTap: plusOnTap)
        ],
      ),
    );
  }
}
