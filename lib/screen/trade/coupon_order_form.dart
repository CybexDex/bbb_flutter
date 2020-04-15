import 'package:bbb_flutter/logic/coupon_order_view_model.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/coupon_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/data_picker.dart';
import 'package:bbb_flutter/widgets/istep.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

class CouponOrderForm extends StatefulWidget {
  final CouponOrderViewModel _model;

  CouponOrderForm({Key key, CouponOrderViewModel model})
      : _model = model,
        super(key: key);

  @override
  CouponOrderFormState createState() => CouponOrderFormState();
}

class CouponOrderFormState extends State<CouponOrderForm> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _cutLossController = TextEditingController();

  @override
  void initState() {
    _amountController.text = "1";
    _takeProfitController.text = "-";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget._model.buildCouponDropdown();
      widget._model.buildCouponList();
      widget._model.buildDropdownMenuItems(widget._model.contractIds);
      widget._model.buildPickerMenuItem(widget._model.contractIds);
      _cutLossController.text = widget._model.contract.strikeLevel.toStringAsFixed(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CouponOrderViewModel, UserManager, ContractResponse>(
        builder: (context, model, userModel, refData, child) {
      Contract refreshContract = model.contract;
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  children: <Widget>[
                    ChoiceChip(
                      label: Text(
                        I18n.of(context).marketOrder,
                        style: StyleNewFactory.white15,
                      ),
                      selected: true,
                      onSelected: (value) {},
                      backgroundColor: Palette.appDividerBackgroudGreyColor,
                      selectedColor: Palette.appYellowOrange,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      I18n.of(context).limitOrderPrice,
                      style: StyleNewFactory.grey15,
                    ),
                    SizedBox(
                      width: 240,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        height: 36,
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
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(I18n.of(context).forcePrice, style: StyleNewFactory.grey15),
                    SizedBox(
                      width: 240,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.separatorColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: GestureDetector(
                          onTap: model.contract == null
                              ? () {}
                              : () {
                                  final limitOrderViewModel =
                                      Provider.of<CouponOrderViewModel>(context);
                                  showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ChangeNotifierProvider<
                                                CouponOrderViewModel>.value(
                                              value: limitOrderViewModel,
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .copyWith()
                                                          .size
                                                          .height /
                                                      3,
                                                  child: Consumer<CouponOrderViewModel>(
                                                    builder: (context, model, child) {
                                                      return DataPickerWidget(
                                                        model: model,
                                                        isCoupon: false,
                                                      );
                                                    },
                                                  )),
                                            );
                                          })
                                      .then((value) => _cutLossController.text =
                                          model.contract.strikeLevel.toStringAsFixed(0));
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
                  height: 15,
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
                          width: 202,
                          child: IStep(
                            enabled: true,
                            isPrice: true,
                            text: _takeProfitController,
                            plusOnTap: () {
                              model.increaseTakeProfitPx();
                              _takeProfitController.text =
                                  model.orderForm.takeProfitPx.toStringAsFixed(0);
                            },
                            minusOnTap: () {
                              model.decreaseTakeProfitPx();
                              _takeProfitController.text = model.orderForm.takeProfitPx == null
                                  ? "-"
                                  : model.orderForm.takeProfitPx.toStringAsFixed(0);
                            },
                            onChange: (value) {
                              if (value.isNotEmpty &&
                                  (double.tryParse(value) == null || double.tryParse(value) < 0)) {
                                model.setTakeProfitInputCorrectness(false);
                              } else {
                                model.setTakeProfitInputCorrectness(true);
                                model.changeTakeProfitPx(
                                    profit: value.isEmpty ? null : double.parse(value));
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
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
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${I18n.of(context).cutLoss}", style: StyleNewFactory.grey15),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 202,
                          child: IStep(
                            enabled: true,
                            isPrice: true,
                            text: _cutLossController,
                            plusOnTap: () {
                              model.increaseCutLossPx();
                              _cutLossController.text = model.orderForm.cutoffPx.toStringAsFixed(0);
                            },
                            minusOnTap: () {
                              model.decreaseCutLossPx();
                              _cutLossController.text = model.orderForm.cutoffPx.toStringAsFixed(0);
                            },
                            onChange: (value) {
                              if (value.isNotEmpty &&
                                  (double.tryParse(value) == null || double.tryParse(value) < 0)) {
                                model.setCutLossInputCorectness(false);
                              } else {
                                model.setCutLossInputCorectness(true);
                                model.changeCutLossPx(
                                    cutLoss: value.isEmpty ? null : double.parse(value));
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            model.changeCutLossPx(cutLoss: null);
                            _cutLossController.text =
                                widget._model.contract.strikeLevel.toStringAsFixed(0);
                          },
                          child: Text(I18n.of(context).orderFormReset,
                              style: StyleFactory.cellDescLabel),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(I18n.of(context).coupon, style: StyleNewFactory.grey15),
                    SizedBox(
                      width: 240,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.separatorColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: GestureDetector(
                          onTap: model.selectedCoupon == null
                              ? () {}
                              : () {
                                  final couponOrderViewModel =
                                      Provider.of<CouponOrderViewModel>(context);
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ChangeNotifierProvider<CouponOrderViewModel>.value(
                                          value: couponOrderViewModel,
                                          child: Container(
                                              height:
                                                  MediaQuery.of(context).copyWith().size.height / 3,
                                              child: Consumer<CouponOrderViewModel>(
                                                builder: (context, model, child) {
                                                  return DataPickerWidget(
                                                    model: model,
                                                    isCoupon: true,
                                                  );
                                                },
                                              )),
                                        );
                                      });
                                },
                          child: custom.DropdownButton<Coupon>(
                              hint: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "暂无代金券",
                                    style: StyleNewFactory.grey14,
                                  )),
                              height: 0,
                              underline: Container(),
                              value: model.selectedCoupon,
                              isExpanded: true,
                              items: model.couponDropdownList,
                              onChanged: model.onChnageCouponDropdownSelection),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "${I18n.of(context).fee}(USDT): ",
                          style: StyleNewFactory.grey13,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${model.orderForm.fee.amount.toStringAsFixed(4)}",
                          style: StyleNewFactory.grey13,
                        )
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
                                if (refreshContract != null &&
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
                  height: 10,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Container(
                  height: 60,
                  width: 108,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [StyleFactory.shadow]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.selectedCoupon != null
                            ? "${model.selectedCoupon.amount.toStringAsFixed(0)}"
                            : "--",
                        style: StyleFactory.cellTitleStyle,
                      ),
                      SizedBox(height: 6),
                      Text("${I18n.of(context).balanceAvailable}", style: StyleNewFactory.grey13),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 108,
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
                        style: StyleFactory.cellTitleStyle,
                      ),
                      SizedBox(height: 6),
                      Text(I18n.of(context).perPrice, style: StyleNewFactory.grey13),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 108,
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
                        style: StyleFactory.cellTitleStyle,
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
}
