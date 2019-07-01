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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  totalAmount > double.minPositive
                      ? totalAmount.toStringAsFixed(4) + " USDT"
                      : "-- USDT",
                  style: StyleFactory.buySellValueText,
                ),
                SizedBox(width: 8),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "${I18n.of(context).investPay}",
                  style: StyleFactory.buySellExplainText,
                ),
              ],
            )
          ],
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
