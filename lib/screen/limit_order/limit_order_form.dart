import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/Input_editor_formatter.dart';
import 'package:bbb_flutter/widgets/data_picker.dart';
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
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _cutLossController = TextEditingController();

  FocusNode _predictPriceFocusNode = FocusNode();

  @override
  void initState() {
    _amountController.text = "1";
    _takeProfitController.text = "-";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget._model.isMarket) {
        widget._model.buildDropdownMenuItems(widget._model.contractIds);
        widget._model.buildPickerMenuItem(widget._model.contractIds);
      }
      _cutLossController.text = widget._model.contract.strikeLevel.toStringAsFixed(0);
    });
    _predictPriceFocusNode.addListener(() {
      if (!_predictPriceFocusNode.hasFocus) {
        widget._model.changePredictPrice(double.tryParse(_predictPriceController.text));
        widget._model.saveOrder();
        widget._model.buildDropdownMenuItems(widget._model.contractIds);
        widget._model.buildPickerMenuItem(widget._model.contractIds);
        _amountController.text = "1";
        _takeProfitController.text = "-";
        _cutLossController.text = widget._model.contract.strikeLevel.toStringAsFixed(0);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LimitOrderViewModel, UserManager, ContractResponse>(
        builder: (context, model, userModel, refData, child) {
      if (model.isChangeSide) {
        _cutLossController.text = widget._model.contract?.strikeLevel?.toStringAsFixed(0) ?? "-";
        model.isChangeSide = false;
      }
      Contract refreshContract = model.contract;
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(30)),
            padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(15),
                right: ScreenUtil.getInstance().setWidth(15)),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                Row(
                  children: <Widget>[
                    ChoiceChip(
                      label: Text(
                        I18n.of(context).marketOrder,
                        style: model.isMarket ? StyleNewFactory.white15 : StyleNewFactory.grey15,
                      ),
                      selected: model.isMarket,
                      onSelected: (value) {
                        model.changeModel(value: true);
                        _amountController.text = "1";
                        _takeProfitController.text = "-";
                        _cutLossController.text =
                            widget._model.contract.strikeLevel.toStringAsFixed(0);
                      },
                      backgroundColor: Palette.appDividerBackgroudGreyColor,
                      selectedColor: Palette.appYellowOrange,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ChoiceChip(
                      label: Text(
                        I18n.of(context).limitOrder,
                        style: model.isMarket ? StyleNewFactory.grey15 : StyleNewFactory.white15,
                      ),
                      selected: !model.isMarket,
                      onSelected: (value) {
                        model.changeModel(value: false);
                        _amountController.text = "1";
                        _takeProfitController.text = "-";
                        _cutLossController.text = "-";
                        _predictPriceController.text = "";
                      },
                      backgroundColor: Palette.appDividerBackgroudGreyColor,
                      selectedColor: Palette.appYellowOrange,
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                model.isMarket
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            I18n.of(context).limitOrderPrice,
                            style: StyleNewFactory.grey15,
                          ),
                          SizedBox(
                            width: ScreenUtil.getInstance().setWidth(240),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 10),
                              height: ScreenUtil.getInstance().setHeight(35),
                              decoration: BoxDecoration(
                                  color: Palette.separatorColor,
                                  border: Border.all(color: Palette.separatorColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "以当前指数价交易",
                                style: StyleNewFactory.grey12,
                              ),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            I18n.of(context).limitOrderPrice,
                            style: StyleNewFactory.grey15,
                          ),
                          SizedBox(
                            width: ScreenUtil.getInstance().setWidth(240),
                            child: Container(
                              height: ScreenUtil.getInstance().setHeight(35),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Palette.separatorColor, width: 0.5),
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
                                  keyboardType:
                                      TextInputType.numberWithOptions(decimal: true, signed: false),
                                  decoration: InputDecoration(
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
                  height: ScreenUtil.getInstance().setHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      I18n.of(context).forcePrice,
                      style: StyleNewFactory.grey15,
                    ),
                    SizedBox(
                      width: ScreenUtil.getInstance().setWidth(240),
                      child: Container(
                        height: ScreenUtil.getInstance().setHeight(35),
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.separatorColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: GestureDetector(
                          onTap: () {
                            if (model.contract != null ||
                                (_predictPriceController.text.isNotEmpty)) {
                              _predictPriceFocusNode.unfocus();
                              _showBottomSelectionMenu(model);
                            }
                          },
                          child: custom.DropdownButton<Contract>(
                            hint: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: model.orderForm.predictPrice == null
                                  ? Text(
                                      "请先输入预计买入价格",
                                      style: StyleFactory.addReduceStyle,
                                    )
                                  : Text(
                                      "暂无合约",
                                      style: StyleFactory.addReduceStyle,
                                    ),
                            ),
                            height: 0,
                            underline: Container(),
                            value: model.orderForm.selectedItem,
                            isExpanded: true,
                            items: model.orderForm.dropdownMenuItems,
                            onChanged: model.onChnageDropdownSelection,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).takeProfit}",
                      style: StyleNewFactory.grey15,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil.getInstance().setWidth(202),
                          child: IStep(
                            enabled: model.isMarket ? true : model.contract != null,
                            isPrice: true,
                            text: _takeProfitController,
                            plusOnTap: (model.isMarket ? true : model.contract != null)
                                ? () {
                                    model.increaseTakeProfitPx();
                                    _takeProfitController.text =
                                        model.orderForm.takeProfitPx.toStringAsFixed(0);
                                  }
                                : () {},
                            minusOnTap: (model.isMarket ? true : model.contract != null)
                                ? () {
                                    model.decreaseTakeProfitPx();
                                    _takeProfitController.text =
                                        model.orderForm.takeProfitPx == null
                                            ? "-"
                                            : model.orderForm.takeProfitPx.toStringAsFixed(0);
                                  }
                                : () {},
                            onChange: (model.isMarket ? true : model.contract != null)
                                ? (value) {
                                    if (value.isNotEmpty &&
                                        (double.tryParse(value) == null ||
                                            double.tryParse(value) < 0)) {
                                      model.setTakeProfitInputCorrectness(false);
                                    } else {
                                      model.setTakeProfitInputCorrectness(true);
                                      model.changeTakeProfitPx(
                                          profit: value.isEmpty ? null : double.parse(value));
                                    }
                                  }
                                : (value) {},
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (model.isMarket ? true : model.contract != null)
                              ? () {
                                  model.changeTakeProfitPx(profit: null);
                                  _takeProfitController.text = "-";
                                }
                              : () {},
                          child:
                              Text(I18n.of(context).orderFormReset, style: StyleNewFactory.grey14),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).cutLoss}",
                      style: StyleNewFactory.grey15,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: ScreenUtil.getInstance().setWidth(202),
                          child: IStep(
                            enabled: (model.isMarket ? true : model.contract != null),
                            isPrice: true,
                            text: _cutLossController,
                            plusOnTap: (model.isMarket ? true : model.contract != null)
                                ? () {
                                    model.increaseCutLossPx();
                                    _cutLossController.text =
                                        model.orderForm.cutoffPx.toStringAsFixed(0);
                                  }
                                : () {},
                            minusOnTap: (model.isMarket ? true : model.contract != null)
                                ? () {
                                    model.decreaseCutLossPx();
                                    _cutLossController.text =
                                        model.orderForm.cutoffPx.toStringAsFixed(0);
                                  }
                                : () {},
                            onChange: (model.isMarket ? true : model.contract != null)
                                ? (value) {
                                    if (value.isNotEmpty &&
                                        (double.tryParse(value) == null ||
                                            double.tryParse(value) < 0)) {
                                      model.setCutLossInputCorectness(false);
                                    } else {
                                      model.setCutLossInputCorectness(true);
                                      model.changeCutLossPx(
                                          cutLoss: value.isEmpty ? null : double.parse(value));
                                    }
                                  }
                                : (value) {},
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (model.isMarket ? true : model.contract != null)
                              ? () {
                                  model.changeCutLossPx(cutLoss: null);
                                  _cutLossController.text =
                                      widget._model.contract.strikeLevel.toStringAsFixed(0);
                                }
                              : () {},
                          child:
                              Text(I18n.of(context).orderFormReset, style: StyleNewFactory.grey14),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      I18n.of(context).investAmount,
                      style: StyleNewFactory.grey15,
                    ),
                    SizedBox(
                      width: ScreenUtil.getInstance().setWidth(240),
                      child: IStep(
                        text: _amountController,
                        plusOnTap: () {
                          model.increaseInvest();
                          _amountController.text = model.orderForm.investAmount.toStringAsFixed(0);
                        },
                        minusOnTap: () {
                          model.decreaseInvest();

                          _amountController.text = model.orderForm.investAmount.toStringAsFixed(0);
                        },
                        onChange: (value) {
                          if (value.isNotEmpty && int.tryParse(value) == null ||
                              int.tryParse(value) < 0) {
                            model.setTotalAmountInputCorectness(false);
                          } else {
                            model.setTotalAmountInputCorectness(true);
                            model.changeInvest(amount: value.isEmpty ? 0 : int.parse(value));
                          }
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("${I18n.of(context).fee}(USDT): ", style: StyleNewFactory.grey13),
                        SizedBox(height: 6),
                        Text("${model.orderForm.fee.amount.toStringAsFixed(4)}",
                            style: StyleNewFactory.grey13)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("${I18n.of(context).interestRate}(USDT): ",
                            style: StyleNewFactory.grey13),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                            refreshContract != null
                                ? "${(locator.get<RefManager>().config.dailyInterest * (refreshContract.strikeLevel / 1000) * model.orderForm.investAmount).toStringAsFixed(4)} ${I18n.of(context).perDay}"
                                : "-- USDT",
                            style: StyleNewFactory.grey13)
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
                                        locator.get<RefManager>().config.maxOrderQuantity) {
                                  return Text(
                                    "${I18n.of(context).orderFormBuyLimitationError}${locator.get<RefManager>().config.maxOrderQuantity}",
                                    style: StyleFactory.smallButtonTitleStyle,
                                  );
                                } else if (!model.isInvestAmountInputCorrect) {
                                  return Text(I18n.of(context).orderFormInputPositiveNumberError,
                                      style: StyleFactory.smallButtonTitleStyle);
                                } else if (!model.isCutLossCorrect && model.orderForm.isUp) {
                                  return Text(I18n.of(context).orderFormBuyUpCutlossLowerStriklevel,
                                      style: StyleFactory.smallButtonTitleStyle);
                                } else if (!model.isCutLossCorrect && !model.orderForm.isUp) {
                                  return Text(
                                    I18n.of(context).orderFormBuyDownCutlossHigherStriklevel,
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
                SizedBox(
                  height: ScreenUtil.getInstance().setHeight(10),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(15),
                right: ScreenUtil.getInstance().setWidth(15)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil.getInstance().setHeight(60),
                  width: ScreenUtil.getInstance().setWidth(108),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [StyleFactory.shadow]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.usdtBalance != null
                            ? "${model.usdtBalance.quantity.toStringAsFixed(4)}"
                            : "--",
                        style: StyleNewFactory.black15,
                      ),
                      SizedBox(height: 6),
                      Text("${I18n.of(context).balanceAvailable}", style: StyleNewFactory.grey13),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(60),
                  width: ScreenUtil.getInstance().setWidth(108),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [StyleFactory.shadow]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.orderForm.totalAmount.amount > double.minPositive
                            ? "${(model.orderForm.totalAmount.amount / model.orderForm.investAmount).toStringAsFixed(4)}"
                            : "--",
                        style: StyleNewFactory.black15,
                      ),
                      SizedBox(height: 6),
                      Text(I18n.of(context).perPrice, style: StyleNewFactory.grey13),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(60),
                  width: ScreenUtil.getInstance().setWidth(108),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [StyleFactory.shadow]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        refreshContract != null ? "${model.actLevel.toStringAsFixed(1)}" : "--",
                        style: StyleNewFactory.black15,
                      ),
                      SizedBox(height: 6),
                      Text("${I18n.of(context).actLevel}", style: StyleNewFactory.grey13),
                    ],
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ],
      );
    });
  }

  _showBottomSelectionMenu(dynamic model) {
    final limitOrderViewModel = Provider.of<LimitOrderViewModel>(context);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider<LimitOrderViewModel>.value(
            value: limitOrderViewModel,
            child: Container(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: Consumer<LimitOrderViewModel>(
                  builder: (context, model, child) {
                    return DataPickerWidget(
                      model: model,
                      isCoupon: false,
                    );
                  },
                )),
          );
        }).then((value) => _cutLossController.text = model.contract.strikeLevel.toStringAsFixed(0));
  }
}
