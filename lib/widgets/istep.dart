import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IStep extends StatelessWidget {
  final GestureTapCallback minusOnTap;
  final GestureTapCallback plusOnTap;
  final String text;

  IStep({Key key, this.text, this.minusOnTap, this.plusOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
          border: Border.all(color: Palette.separatorColor, width: 0.5),
          borderRadius: BorderRadius.circular(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("$text", style: StyleFactory.addReduceStyle),
          ),
          Row(
            children: <Widget>[
              VerticalDivider(
                color: Palette.separatorColor,
                indent: 6,
                endIndent: 6,
                width: 0.5,
              ),
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SvgPicture.asset(R.resAssetsIconsIcReduce2),
                  ),
                  onTap: minusOnTap),
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(R.resAssetsIconsIcAdd2),
                  ),
                  onTap: plusOnTap)
            ],
          )
        ],
      ),
    );
  }
}
