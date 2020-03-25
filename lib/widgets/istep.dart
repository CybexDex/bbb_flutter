import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/Input_editor_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IStep extends StatelessWidget {
  final GestureTapCallback minusOnTap;
  final GestureTapCallback plusOnTap;
  final TextEditingController text;
  final ValueChanged<String> onChange;
  final bool isPrice;

  IStep(
      {Key key,
      TextEditingController text,
      this.minusOnTap,
      this.plusOnTap,
      this.onChange,
      this.isPrice})
      : this.text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
          border: Border.all(color: Palette.separatorColor, width: 0.5),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                inputFormatters: [
                  (isPrice != null && isPrice)
                      ? TestFormat(integerRange: 10, decimalRange: 4)
                      : WhitelistingTextInputFormatter(RegExp(r'^[0-9]{1,7}'))
                ],
                controller: this.text,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                onChanged: onChange,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: (isPrice != null && isPrice)
                      ? I18n.of(context).inputPriceHint
                      : I18n.of(context).inputAmountHint,
                  hintStyle: StyleFactory.addReduceStyle,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  VerticalDivider(
                    color: Palette.separatorColor,
                    width: 1,
                  ),
                  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: SvgPicture.asset(
                          R.resAssetsIconsIcReduce2,
                          color: Palette.invitePromotionBadgeColor,
                        ),
                      ),
                      onTap: minusOnTap),
                  VerticalDivider(
                    color: Palette.separatorColor,
                    indent: 6,
                    endIndent: 6,
                    width: 1,
                  ),
                  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: SvgPicture.asset(
                          R.resAssetsIconsIcAdd2,
                          color: Palette.invitePromotionBadgeColor,
                        ),
                      ),
                      onTap: plusOnTap),
                ],
              )),
        ],
      ),
    );

    // return Container(
    //   height: 36,
    //   decoration: BoxDecoration(
    //       border: Border.all(color: Palette.separatorColor, width: 0.5),
    //       borderRadius: BorderRadius.circular(2)),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.only(left: 10),
    //         child: Text("$text", style: StyleFactory.addReduceStyle),
    //       ),
    //       Row(
    //         children: <Widget>[
    //           VerticalDivider(
    //             color: Palette.separatorColor,
    //             indent: 6,
    //             endIndent: 6,
    //             width: 0.5,
    //           ),
    //           GestureDetector(
    //               child: Container(
    //                 padding: EdgeInsets.only(left: 10, right: 10),
    //                 child: SvgPicture.asset(R.resAssetsIconsIcReduce2),
    //               ),
    //               onTap: minusOnTap),
    //           GestureDetector(
    //               child: Container(
    //                 padding: EdgeInsets.only(right: 10),
    //                 child: SvgPicture.asset(R.resAssetsIconsIcAdd2),
    //               ),
    //               onTap: plusOnTap)
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
