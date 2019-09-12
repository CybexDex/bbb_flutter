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
  _OrderFormWidgetState createState() => _OrderFormWidgetState();
}

class _OrderFormWidgetState extends State<OrderFormWidget> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _cutLossController = TextEditingController();

  @override
  void initState() {
    _takeProfitController.text = "-";
    _cutLossController.text = "-";
    _amountController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TradeViewModel, UserManager, RefContractResponseModel>(
        builder: (context, model, userModel, refData, child) {
      Contract refreshContract = model.contract;
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
                      model.usdtBalance != null
                          ? "${model.usdtBalance.quantity.toStringAsFixed(4)} USDT"
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
                      "${model.actLevel.toStringAsFixed(1)}",
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
                    Container(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            I18n.of(context).takeProfit + "(%)",
                            style: StyleFactory.cellDescLabel,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.changeTakeProfit(profit: null);
                              _takeProfitController.text =
                                  I18n.of(context).stepWidgetNotSetHint;
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
                          model.increaseTakeProfit();
                          _takeProfitController.text =
                              model.orderForm.takeProfit.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseTakeProfit();
                          _takeProfitController.text =
                              model.orderForm.takeProfit.toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.tryParse(value) < 0)) {
                            model.setTakeProfitInputCorrectness(false);
                          } else {
                            model.setTakeProfitInputCorrectness(true);
                            model.changeTakeProfit(
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
                            I18n.of(context).cutLoss + "(%)",
                            style: StyleFactory.cellDescLabel,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.changeCutLoss(cutLoss: null);
                              _cutLossController.text =
                                  I18n.of(context).stepWidgetNotSetHint;
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
                          model.increaseCutLoss();
                          _cutLossController.text =
                              model.orderForm.cutoff.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseCutLoss();
                          _cutLossController.text =
                              model.orderForm.cutoff.toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.tryParse(value) < 0)) {
                            model.setCutLossInputCorectness(false);
                          } else {
                            model.setCutLossInputCorectness(true);
                            model.changeCutLoss(
                                cutLoss: value.isEmpty
                                    ? null
                                    : double.parse(value) > 100
                                        ? 100
                                        : double.parse(value));
                            if (double.parse(value) > 100) {
                              _cutLossController.text = "100";
                            }
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
