import 'package:bbb_flutter/shared/ui_common.dart';

class BuyOrSellBottom extends StatelessWidget {
  final String totalAmount;
  final String feeAmount;
  final String balanceAmount;
  final Widget button;

  BuyOrSellBottom(
      {Key key,
      this.totalAmount,
      this.feeAmount,
      this.balanceAmount,
      this.button})
      : super(key: key);

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
                  totalAmount != null ? totalAmount : "--",
                  style: StyleFactory.buySellValueText,
                ),
                SizedBox(width: 8),
                Text(
                  'USDT',
                  style: StyleFactory.cellTitleStyle,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  feeAmount != null ? "包含手续费$feeAmount USDT" : "包含手续费-- USDT",
                  style: StyleFactory.buySellExplainText,
                ),
                Text(
                  balanceAmount != null
                      ? "/ 余额$balanceAmount USDT"
                      : "/ 余额-- USDT",
                  style: StyleFactory.buySellExplainText,
                )
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
