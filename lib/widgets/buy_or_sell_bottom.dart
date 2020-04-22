import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class BuyOrSellBottom extends StatelessWidget {
  final double totalAmount;
  final Widget button;
  BuyOrSellBottom({Key key, this.totalAmount, this.button}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("${I18n.of(context).investPay}: ", style: StyleNewFactory.black15),
            Text(
              (totalAmount != null && totalAmount > double.minPositive)
                  ? totalAmount.toStringAsFixed(4) + " USDT"
                  : "-- USDT",
              style: StyleNewFactory.black15,
            ),
          ],
        ),
        Row(
          children: <Widget>[],
        ),
        Expanded(
          flex: 0,
          child: ButtonTheme(
            child: button,
          ),
        )
      ],
    ));
  }
}
