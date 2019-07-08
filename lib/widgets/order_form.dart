import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

import 'istep.dart';

class OrderFormWidget extends StatelessWidget {
  final Contract _contract;
  const OrderFormWidget({Key key, Contract contract})
      : _contract = contract,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<TradeViewModel, UserManager, RefContractResponseModel>(
        builder: (context, model, userModel, refData, child) {
      Contract refreshContract =
          refData.contract.where((c) => c == _contract).last;
      Position usdt = userModel.fetchPositionFrom(AssetName.NXUSDT);

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).balanceAvailable,
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  usdt != null
                      ? "${usdt.quantity.toStringAsFixed(4)} USDT"
                      : "-- USDT",
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
                  I18n.of(context).forcePrice,
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  "${refreshContract.strikeLevel.toStringAsFixed(0)} USDT",
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
            Offstage(
                offstage: model.isSatisfied,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset("res/assets/icons/icWarn.png"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "剩余份数不足，余额不足，单笔购买上限${refreshContract.maxOrderQty}",
                          style: StyleFactory.smallButtonTitleStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).takeProfit,
                  style: StyleFactory.subTitleStyle,
                ),
                SizedBox(
                  width: 76,
                  child: IStep(
                      text: "${model.orderForm.takeProfit.toStringAsFixed(0)}%",
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
            Row(
              children: <Widget>[
                Text(
                  I18n.of(context).cutLoss,
                  style: StyleFactory.subTitleStyle,
                ),
                SizedBox(
                  width: 76,
                  child: IStep(
                    text: "${model.orderForm.cutoff.toStringAsFixed(0)}%",
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
            Row(
              children: <Widget>[
                Text(
                  "${I18n.of(context).fee}",
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  "${model.orderForm.fee.amount.toStringAsFixed(4)} USDT",
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
                  "${I18n.of(context).interestRate}",
                  style: StyleFactory.subTitleStyle,
                ),
                Text(
                  "${(refreshContract.dailyInterest * model.orderForm.investAmount).toStringAsFixed(4)} USDT${I18n.of(context).perDay}",
                  style: StyleFactory.smallCellTitleStyle,
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
