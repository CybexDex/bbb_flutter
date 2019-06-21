import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

import 'istep.dart';

class OrderFormWidget extends StatelessWidget {
  const OrderFormWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TradeViewModel>(builder: (context, model, child) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).perPrice,
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  "",
                  style: StyleFactory.smallCellTitleStyle,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).restAmount,
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  " 份",
                  style: StyleFactory.smallCellTitleStyle,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).investAmount,
                  style: StyleFactory.subTitleStyle,
                ),
                SizedBox(
                  width: 76,
                  child: IStep(
                    text: model.orderForm.investAmount.toString(),
                    minusOnTap: () {
                      model.decreaseInvest();
                    },
                    plusOnTap: () {
                      model.increaseInvest();
                    },
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).takeProfit,
                  style: StyleFactory.subTitleStyle,
                ),
                SizedBox(
                  width: 76,
                  child: IStep(
                      text: "${model.orderForm.takeProfit}%",
                      plusOnTap: () {
                        model.increaseTakeProfit();
                      },
                      minusOnTap: () {
                        model.decreaseTakeProfit();
                      }),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   children: <Widget>[
            //     Text(
            //       "${I18n.of(context).takeProfit}${I18n.of(context).gain}",
            //       style: StyleFactory.subTitleStyle,
            //     ),
            //     Text(
            //       "4 USDT",
            //       style: StyleFactory.smallCellTitleStyle,
            //     )
            //   ],
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).cutLoss,
                  style: StyleFactory.subTitleStyle,
                ),
                SizedBox(
                  width: 76,
                  child: IStep(
                    text: "${model.orderForm.cutoff}%",
                    plusOnTap: () {
                      model.increaseCutLoss();
                    },
                    minusOnTap: () {
                      model.decreaseCutLoss();
                    },
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
