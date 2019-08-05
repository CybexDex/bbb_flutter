import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'istep.dart';

class OrderFormWidget extends StatelessWidget {
  final Contract _contract;
  OrderFormWidget({Key key, Contract contract})
      : _contract = contract,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<TradeViewModel, UserManager, RefContractResponseModel>(
        builder: (context, model, userModel, refData, child) {
      Contract refreshContract = model.contract;
      Position usdt = userModel.fetchPositionFrom(AssetName.NXUSDT);

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      I18n.of(context).balanceAvailable,
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 6),
                    Text(
                      usdt != null
                          ? "${usdt.quantity.toStringAsFixed(4)} USDT"
                          : "-- USDT",
                      style: StyleFactory.cellTitleStyle,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      I18n.of(context).forcePrice,
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${refreshContract.strikeLevel.toStringAsFixed(0)} USDT",
                      style: StyleFactory.cellTitleStyle,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).actLevel}",
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${model.actLevel.toStringAsFixed(4)}",
                      style: StyleFactory.cellTitleStyle,
                    )
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 15),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).fee}",
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${model.orderForm.fee.amount.toStringAsFixed(4)} USDT",
                      style: StyleFactory.cellTitleStyle,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).interestRate}",
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "${(refreshContract.dailyInterest * (refreshContract.strikeLevel / 1000) * model.orderForm.investAmount).toStringAsFixed(4)} USDT${I18n.of(context).perDay}",
                      style: StyleFactory.cellTitleStyle,
                    )
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(height: 0.5, color: Palette.separatorColor),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      I18n.of(context).takeProfit,
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 160,
                      child: IStep(
                          text:
                              "${model.orderForm.takeProfit.round().toStringAsFixed(0)}%",
                          plusOnTap: () {
                            model.increaseTakeProfit();
                          },
                          minusOnTap: () {
                            model.decreaseTakeProfit();
                          }),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      I18n.of(context).cutLoss,
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 160,
                      child: IStep(
                        text: model.orderForm.cutoff.round() == 0
                            ? "不设置"
                            : "${model.orderForm.cutoff.round().toStringAsFixed(0)}%",
                        plusOnTap: () {
                          model.increaseCutLoss();
                        },
                        minusOnTap: () {
                          model.decreaseCutLoss();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  I18n.of(context).investAmount,
                  style: StyleFactory.cellDescLabel,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 160,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Palette.separatorColor, width: 0.5),
                            borderRadius: BorderRadius.circular(2)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    print(value);
                                    model.changeInvest(
                                        amount: value.isEmpty
                                            ? 0
                                            : int.parse(value));
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(top: 4, bottom: 4),
                                    border: InputBorder.none,
                                    hintText: I18n.of(context).investmentHint,
                                    hintStyle: StyleFactory.addReduceStyle,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    VerticalDivider(
                                      color: Palette.separatorColor,
                                      indent: 6,
                                      endIndent: 6,
                                      width: 0.5,
                                    ),
                                    Text("份",
                                        style:
                                            StyleFactory.investmentAmountStyle),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )
                    // SliderTheme(
                    //     data: SliderTheme.of(context).copyWith(
                    //       activeTrackColor: Palette.redOrange,
                    //       inactiveTrackColor: Palette.subTitleColor,
                    //       thumbColor: Palette.redOrange,
                    //       thumbShape:
                    //           RoundSliderThumbShape(enabledThumbRadius: 4),
                    //     ),
                    //     child: SizedBox(
                    //         child: Slider(
                    //       min: 0,
                    //       max: 100,
                    //       onChanged: (value) {
                    //         model.changeInvest(amount: value.toInt());
                    //         print(value);
                    //       },
                    //       value: model.orderForm.investAmount.toDouble(),
                    //     ))),
                    // Text(
                    //   "${model.orderForm.investAmount} 份",
                    //   style: StyleFactory.subTitleStyle,
                    // )
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Offstage(
                offstage: model.isSatisfied ||
                    model.orderForm.totalAmount.amount <= double.minPositive,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(R.resAssetsIconsIcWarn),
                        SizedBox(
                          width: 5,
                        ),
                        Builder(
                          builder: (context) {
                            if (model.orderForm.investAmount >
                                refreshContract.availableInventory) {
                              return Text(
                                "剩余份数不足",
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (usdt == null ||
                                model.orderForm.totalAmount.amount >
                                    usdt.quantity) {
                              return Text(
                                "余额不足",
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (model.orderForm.investAmount >
                                refreshContract.maxOrderQty) {
                              return Text(
                                "单笔购买上限${refreshContract.maxOrderQty}",
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
          ],
        ),
      );
    });
  }
}
