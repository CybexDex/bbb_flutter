import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/Input_editor_formatter.dart';
import 'package:bbb_flutter/widgets/istep.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;
import 'package:flutter/services.dart';

class LimitOrderFormWidget extends StatefulWidget {
  final LimitOrderViewModel _model;

  LimitOrderFormWidget({Key key, LimitOrderViewModel model})
      : _model = model,
        super(key: key);

  @override
  LimitOrderFormWidgetState createState() => LimitOrderFormWidgetState();
}

class LimitOrderFormWidgetState extends State<LimitOrderFormWidget> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _predictPriceController = TextEditingController();
  FocusNode _predictPriceFocusNode = FocusNode();

  @override
  void initState() {
    _amountController.text = "1";
    _predictPriceFocusNode.addListener(() {
      if (!_predictPriceFocusNode.hasFocus) {
        widget._model
            .changePredictPrice(double.tryParse(_predictPriceController.text));
        widget._model.saveOrder();
        widget._model.buildDropdownMenuItems(widget._model.contractIds);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LimitOrderViewModel, UserManager, ContractResponse>(
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
                      model.orderForm.totalAmount.amount > double.minPositive
                          ? "${(model.orderForm.totalAmount.amount / model.orderForm.investAmount).toStringAsFixed(4)}"
                          : "--",
                      style: StyleFactory.cellTitleStyle,
                    ),
                    SizedBox(height: 6),
                    Text(
                      I18n.of(context).perPrice,
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
                      refreshContract != null
                          ? "${model.actLevel.toStringAsFixed(1)}"
                          : "--",
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
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "限价单24小时有效",
                style: StyleNewFactory.yellowOrange12,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  I18n.of(context).limitOrderPrice,
                  style: StyleFactory.cellDescLabel,
                ),
                SizedBox(
                  width: 200,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Palette.separatorColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        inputFormatters: [
                          TestFormat(decimalRange: 4, integerRange: 10)
                          // WhitelistingTextInputFormatter(RegExp(r'^[0-9]{1,7}'))
                        ],
                        style: StyleNewFactory.grey14,
                        focusNode: _predictPriceFocusNode,
                        controller: _predictPriceController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(top: 4, bottom: 4),
                          border: InputBorder.none,
                          hintText: "输入价格",
                          hintStyle: StyleFactory.addReduceStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Offstage(
              offstage: model.orderForm.predictPrice == null ||
                  model.orderForm.predictPrice == model.ticker.value,
              child: Row(
                children: <Widget>[
                  Image.asset(R.resAssetsIconsIcWarn),
                  SizedBox(
                    width: 5,
                  ),
                  Builder(
                    builder: (context) {
                      if (model.ticker != null &&
                          model.orderForm.predictPrice != null &&
                          model.orderForm.predictPrice > model.ticker.value) {
                        return Text(
                          "当前价格上涨到${model.orderForm.predictPrice}触发限价单",
                          style: StyleFactory.smallButtonTitleStyle,
                        );
                      } else if (model.ticker != null &&
                          model.orderForm.predictPrice != null &&
                          model.orderForm.predictPrice < model.ticker.value) {
                        return Text(
                          "当前价格下降到${model.orderForm.predictPrice}触发限价单",
                          style: StyleFactory.smallButtonTitleStyle,
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  I18n.of(context).forcePrice,
                  style: StyleFactory.cellDescLabel,
                ),
                SizedBox(
                  width: 200,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Palette.separatorColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: custom.DropdownButton<Contract>(
                      hint: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: model.orderForm.predictPrice == null
                            ? Text(
                                "请先输入预计购买价格",
                                style: StyleFactory.addReduceStyle,
                              )
                            : Text(
                                "暂无合约",
                                style: StyleFactory.addReduceStyle,
                              ),
                      ),
                      height: 200,
                      underline: Container(),
                      value: model.orderForm.selectedItem,
                      isExpanded: true,
                      items: model.orderForm.dropdownMenuItems,
                      onChanged: model.onChnageDropdownSelection,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  I18n.of(context).investAmount,
                  style: StyleFactory.cellDescLabel,
                ),
                SizedBox(
                  width: 200,
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
              ],
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
                      refreshContract != null
                          ? "${(locator.get<RefManager>().config.dailyInterest * (refreshContract.strikeLevel / 1000) * model.orderForm.investAmount).toStringAsFixed(4)} ${I18n.of(context).perDay}"
                          : "-- USDT",
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
                            if (model.usdtBalance == null ||
                                model.orderForm.totalAmount.amount >
                                    model.usdtBalance.quantity) {
                              return Text(
                                I18n.of(context).orderFormBalanceNotEnoughError,
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (refreshContract != null &&
                                model.orderForm.investAmount >
                                    locator
                                        .get<RefManager>()
                                        .config
                                        .maxOrderQuantity) {
                              return Text(
                                "${I18n.of(context).orderFormBuyLimitationError}${locator.get<RefManager>().config.maxOrderQuantity}",
                                style: StyleFactory.smallButtonTitleStyle,
                              );
                            } else if (!model.isInvestAmountInputCorrect) {
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
