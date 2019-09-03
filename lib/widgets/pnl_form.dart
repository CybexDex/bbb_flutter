import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/istep.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class PnlForm extends StatefulWidget {
  final OrderResponseModel _order;
  final Function _callback;
  PnlForm({Key key, OrderResponseModel model, Function() callback})
      : _order = model,
        _callback = callback,
        super(key: key);

  @override
  _PnlFormState createState() => _PnlFormState();
}

class _PnlFormState extends State<PnlForm> {
  TextEditingController _takeProfitController = TextEditingController();
  TextEditingController _cutLossController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: KeyboardAvoider(
        autoScroll: true,
        child: BaseWidget<PnlViewModel>(
          model: PnlViewModel(
              api: locator.get(),
              um: locator.get(),
              mtm: locator.get(),
              refm: locator.get()),
          onModelReady: (model) {
            final contract = model.currentContract(widget._order);

            model.takeProfit = widget._order.takeProfitPx == 0
                ? null
                : OrderCalculate.getTakeProfit(
                    widget._order.takeProfitPx,
                    widget._order.boughtPx,
                    contract.strikeLevel,
                    contract.conversionRate > 0);

            model.cutLoss = widget._order.cutLossPx == contract.strikeLevel
                ? null
                : OrderCalculate.getCutLoss(
                    widget._order.cutLossPx,
                    widget._order.boughtPx,
                    contract.strikeLevel,
                    contract.conversionRate > 0);

            double invest = OrderCalculate.calculateInvest(
                orderQtyContract: widget._order.qtyContract,
                orderBoughtContractPx: widget._order.boughtContractPx);

            model.pnlPercent = (100 *
                    ((widget._order.pnl + widget._order.commission) / invest))
                .abs();

            _cutLossController.text = model.cutLoss == null
                ? I18n.of(context).stepWidgetNotSetHint
                : model.cutLoss.round().toStringAsFixed(0);
            _takeProfitController.text = model.takeProfit == null
                ? I18n.of(context).stepWidgetNotSetHint
                : model.takeProfit.round().toStringAsFixed(0);
          },
          builder: (context, model, child) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: DecorationFactory.dialogChooseDecoration,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Image.asset(R.resAssetsIconsIcMaskClose),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "${I18n.of(context).takeProfit}(%)",
                                  style: StyleFactory.subTitleStyle,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.setTakeProfitInputCorrectness(true);
                                    model.changeTakeProfit(profit: null);
                                    _takeProfitController.text =
                                        I18n.of(context).stepWidgetNotSetHint;
                                  },
                                  child: Text(
                                    I18n.of(context).orderFormReset,
                                    style: StyleFactory.subTitleStyle,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                                width: 150,
                                child: Material(
                                  child: IStep(
                                    text: _takeProfitController,
                                    plusOnTap: () {
                                      model.increaseTakeProfit();
                                      model.setTakeProfitInputCorrectness(true);
                                      _takeProfitController.text =
                                          model.takeProfit.toStringAsFixed(0);
                                    },
                                    minusOnTap: () {
                                      model.decreaseTakeProfit();
                                      model.setTakeProfitInputCorrectness(true);
                                      _takeProfitController.text =
                                          model.takeProfit.toStringAsFixed(0);
                                    },
                                    onChange: (value) {
                                      if (value.isNotEmpty &&
                                          (double.tryParse(value) == null ||
                                              double.tryParse(value) < 0)) {
                                        model.setTakeProfitInputCorrectness(
                                            false);
                                      } else {
                                        model.setTakeProfitInputCorrectness(
                                            true);
                                        model.changeTakeProfit(
                                            profit: value.isEmpty
                                                ? null
                                                : double.parse(value));
                                      }
                                    },
                                  ),
                                ))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "${I18n.of(context).cutLoss}(%)",
                                  style: StyleFactory.subTitleStyle,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.setCutLossInputCorectness(true);
                                    model.changeCutLoss(cutLoss: null);
                                    _cutLossController.text =
                                        I18n.of(context).stepWidgetNotSetHint;
                                  },
                                  child: Text(
                                    I18n.of(context).orderFormReset,
                                    style: StyleFactory.subTitleStyle,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                                width: 150,
                                child: Material(
                                  child: IStep(
                                    text: _cutLossController,
                                    plusOnTap: () {
                                      model.increaseCutLoss();
                                      model.setCutLossInputCorectness(true);
                                      _cutLossController.text =
                                          model.cutLoss.toStringAsFixed(0);
                                    },
                                    minusOnTap: () {
                                      model.decreaseCutLoss();
                                      model.setCutLossInputCorectness(true);
                                      _cutLossController.text =
                                          model.cutLoss.toStringAsFixed(0);
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
                                ))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Offstage(
                            offstage: model.isCutLossInputCorrect &&
                                model.isTakeProfitInputCorrect,
                            child: Column(
                              children: <Widget>[
                                Text(
                                    I18n.of(context)
                                        .orderFormInputPositiveNumberError,
                                    style: StyleFactory.smallButtonTitleStyle),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            )),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 44,
                          child: WidgetFactory.button(
                              data: I18n.of(context).confirm,
                              color: (model.isCutLossInputCorrect &&
                                      model.isTakeProfitInputCorrect)
                                  ? Palette.redOrange
                                  : Palette.subTitleColor,
                              onPressed: (model.isCutLossInputCorrect &&
                                      model.isTakeProfitInputCorrect)
                                  ? () async {
                                      if ((model.takeProfit != null &&
                                              model.pnlPercent >
                                                  model.takeProfit &&
                                              widget._order.pnl > 0) ||
                                          (model.cutLoss != null &&
                                              model.pnlPercent >
                                                  model.cutLoss &&
                                              widget._order.pnl < 0)) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DialogFactory
                                                  .normalConfirmDialog(context,
                                                      title: I18n.of(context)
                                                          .remider,
                                                      content: I18n.of(context)
                                                          .triggerCloseContent,
                                                      onConfirmPressed: () {
                                                _onClickSubmit(
                                                    context: context,
                                                    model: model);
                                              });
                                            });
                                      } else {
                                        _onClickSubmit(
                                            context: context, model: model);
                                      }
                                    }
                                  : () {}),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  callAmend(
    BuildContext context,
    PnlViewModel model,
  ) async {
    try {
      showLoading(context);
      PostOrderResponseModel postOrderResponseModel =
          await model.amend(widget._order, false);
      Navigator.of(context).pop();
      if (postOrderResponseModel.status == "Failed") {
        showToast(context, true, postOrderResponseModel.reason);
      } else {
        showToast(context, false, I18n.of(context).successToast,
            callback: widget._callback);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
    }
  }

  _onClickSubmit({BuildContext context, PnlViewModel model}) {
    TextEditingController controller = TextEditingController();
    if (locator.get<UserManager>().user.isLocked) {
      showDialog(
          context: context,
          builder: (context) {
            return DialogFactory.unlockDialog(context, controller: controller);
          }).then((value) async {
        if (value) {
          callAmend(context, model);
        }
      });
    } else {
      callAmend(context, model);
    }
  }
}
