import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'istep.dart';

class OrderFormWidget extends StatefulWidget {
  final Contract _contract;

  OrderFormWidget({Key key, Contract contract})
      : _contract = contract,
        super(key: key);

  @override
  OrderFormWidgetState createState() => OrderFormWidgetState();
}

class OrderFormWidgetState extends State<OrderFormWidget> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _cutLossController = TextEditingController();

  @override
  void initState() {
    print("sss");
    _takeProfitController.text = "-";
    _cutLossController.text = widget._contract.strikeLevel.toStringAsFixed(0);
    _amountController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TradeViewModel, UserManager, RefContractResponseModel>(
        builder: (context, model, userModel, refData, child) {
      Contract refreshContract = model.contract;
      return Container(
        padding: EdgeInsets.only(top: 10, right: 15, left: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      model.usdtBalance != null
                          ? "${model.usdtBalance.quantity.toStringAsFixed(4)}"
                          : "--",
                      style: StyleFactory.cellTitleStyle,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${I18n.of(context).balanceAvailable}(USDT)",
                      style: StyleFactory.cellDescLabel,
                    ),
                  ],
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: Palette.separatorColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${refreshContract.strikeLevel.toStringAsFixed(0)}",
                      style: StyleFactory.cellTitleStyle,
                    ),
                    SizedBox(height: 6),
                    Text(
                      I18n.of(context).forcePrice,
                      style: StyleFactory.cellDescLabel,
                    ),
                  ],
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: Palette.separatorColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${model.actLevel.toStringAsFixed(1)}",
                      style: StyleFactory.cellTitleStyle,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${I18n.of(context).actLevel}",
                      style: StyleFactory.cellDescLabel,
                    ),
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 10),
            Divider(height: 0.5, color: Palette.separatorColor),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            I18n.of(context).takeProfit,
                            style: StyleFactory.cellDescLabel,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.changeTakeProfitPx(profit: null);
                              _takeProfitController.text = "-";
                            },
                            child: Text(I18n.of(context).orderFormReset,
                                style: StyleFactory.cellDescLabel),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 160,
                      child: IStep(
                        text: _takeProfitController,
                        plusOnTap: () {
                          model.increaseTakeProfitPx();
                          _takeProfitController.text =
                              model.orderForm.takeProfitPx.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseTakeProfitPx();
                          _takeProfitController.text =
                              model.orderForm.takeProfitPx == null
                                  ? "-"
                                  : model.orderForm.takeProfitPx
                                      .toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.tryParse(value) < 0)) {
                            model.setTakeProfitInputCorrectness(false);
                          } else {
                            model.setTakeProfitInputCorrectness(true);
                            model.changeTakeProfitPx(
                                profit:
                                    value.isEmpty ? null : double.parse(value));
                          }
                        },
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            I18n.of(context).cutLoss,
                            style: StyleFactory.cellDescLabel,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.changeCutLossPx(cutLoss: null);
                              _cutLossController.text = widget
                                  ._contract.strikeLevel
                                  .toStringAsFixed(0);
                            },
                            child: Text(I18n.of(context).orderFormReset,
                                style: StyleFactory.cellDescLabel),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 160,
                      child: IStep(
                        text: _cutLossController,
                        plusOnTap: () {
                          model.increaseCutLossPx();
                          _cutLossController.text =
                              model.orderForm.cutoffPx.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseCutLossPx();
                          _cutLossController.text =
                              model.orderForm.cutoffPx.toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.tryParse(value) < 0)) {
                            model.setCutLossInputCorectness(false);
                          } else {
                            model.setCutLossInputCorectness(true);
                            model.changeCutLossPx(
                                cutLoss: value.isEmpty
                                    ? null
                                    // : double.parse(value) >
                                    //         model.currentTicker.value
                                    //     ? model.currentTicker.value
                                    : double.parse(value));
                            // if (double.parse(value) >
                            //     widget._contract.strikeLevel) {
                            //   _cutLossController.text = widget
                            //       ._contract.strikeLevel
                            //       .toStringAsFixed(0);
                            // }
                          }
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
                      child: IStep(
                        text: _amountController,
                        plusOnTap: () {
                          model.increaseInvest();
                          _amountController.text =
                              model.orderForm.investAmount.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseInvest();

                          _amountController.text =
                              model.orderForm.investAmount.toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty && int.tryParse(value) == null ||
                              int.tryParse(value) < 0) {
                            model.setTotalAmountInputCorectness(false);
                          } else {
                            model.setTotalAmountInputCorectness(true);
                            model.changeInvest(
                                amount: value.isEmpty ? 0 : int.parse(value));
                          }
                        },
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
            SizedBox(
              height: 9,
            ),
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).fee}(USDT): ",
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "${model.orderForm.fee.amount.toStringAsFixed(4)}",
                      style: StyleFactory.cellTitleStyle,
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).interestRate}(USDT): ",
                      style: StyleFactory.cellDescLabel,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "${(refreshContract.dailyInterest * (refreshContract.strikeLevel / 1000) * model.orderForm.investAmount).toStringAsFixed(4)} ${I18n.of(context).perDay}",
                      style: StyleFactory.cellTitleStyle,
                    )
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
                                I18n.of(context).orderFormSupplyNotEnoughError,
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (model.usdtBalance == null ||
                                model.orderForm.totalAmount.amount >
                                    model.usdtBalance.quantity) {
                              return Text(
                                I18n.of(context).orderFormBalanceNotEnoughError,
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (model.orderForm.investAmount >
                                refreshContract.maxOrderQty) {
                              return Text(
                                "${I18n.of(context).orderFormBuyLimitationError}${refreshContract.maxOrderQty}",
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (!model.isCutLossInputCorrect ||
                                !model.isInvestAmountInputCorrect ||
                                !model.isTakeProfitInputCorrect) {
                              return Text(
                                  I18n.of(context)
                                      .orderFormInputPositiveNumberError,
                                  style: StyleFactory.smallButtonTitleStyle);
                            } else if (!model.isCutLossCorrect &&
                                model.orderForm.isUp) {
                              return Text(
                                  I18n.of(context)
                                      .orderFormBuyUpCutlossLowerStriklevel,
                                  style: StyleFactory.smallButtonTitleStyle);
                            } else if (!model.isCutLossCorrect &&
                                !model.orderForm.isUp) {
                              return Text(
                                I18n.of(context)
                                    .orderFormBuyDownCutlossHigherStriklevel,
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }
}
