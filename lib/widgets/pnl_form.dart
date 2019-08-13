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

            model.takeProfit = OrderCalculate.getTakeProfit(
                widget._order.takeProfitPx,
                widget._order.boughtPx,
                contract.strikeLevel,
                contract.conversionRate > 0);

            model.cutLoss = OrderCalculate.getCutLoss(
                widget._order.cutLossPx,
                widget._order.boughtPx,
                contract.strikeLevel,
                contract.conversionRate > 0);
            _cutLossController.text = model.cutLoss.toStringAsFixed(0);
            _takeProfitController.text = model.takeProfit.toStringAsFixed(0);
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
                            Text(
                              I18n.of(context).takeProfit,
                              style: StyleFactory.subTitleStyle,
                            ),
                            SizedBox(
                                width: 150,
                                child: Material(
                                  child: IStep(
                                    text: _takeProfitController,
                                    plusOnTap: () {
                                      model.increaseTakeProfit();
                                      if (model.takeProfit.round() == 0) {
                                        _takeProfitController.text = "不设置";
                                      } else {
                                        _takeProfitController.text =
                                            model.takeProfit.toStringAsFixed(0);
                                      }
                                    },
                                    minusOnTap: () {
                                      model.decreaseTakeProfit();
                                      if (model.takeProfit.round() == 0) {
                                        _takeProfitController.text = "不设置";
                                      } else {
                                        _takeProfitController.text =
                                            model.takeProfit.toStringAsFixed(0);
                                      }
                                    },
                                    onChange: (value) {
                                      model.changeTakeProfit(
                                          profit: value.isEmpty
                                              ? 0
                                              : double.parse(value));
                                      if (value == "0") {
                                        _takeProfitController.text = "不设置";
                                      }
                                    },
                                  ),
                                )

                                // child: IStep(
                                //     text: model.takeProfit.round() == 0
                                //         ? "不设置"
                                //         : "${model.takeProfit.round().toStringAsFixed(0)}%",
                                //     plusOnTap: () {
                                //       model.increaseTakeProfit();
                                //     },
                                //     minusOnTap: () {
                                //       model.decreaseTakeProfit();
                                //     }),
                                )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              I18n.of(context).cutLoss,
                              style: StyleFactory.subTitleStyle,
                            ),
                            SizedBox(
                                width: 150,
                                child: Material(
                                  child: IStep(
                                    text: _cutLossController,
                                    // text: model.orderForm.cutoff.round() == 0
                                    //     ? "不设置"
                                    //     : "${model.orderForm.cutoff.round().toStringAsFixed(0)}%",
                                    plusOnTap: () {
                                      model.increaseCutLoss();
                                      _cutLossController.text =
                                          model.cutLoss.toStringAsFixed(0);
                                    },
                                    minusOnTap: () {
                                      model.decreaseCutLoss();
                                      if (model.cutLoss.round() == 0) {
                                        _cutLossController.text = "不设置";
                                      } else {
                                        _cutLossController.text =
                                            model.cutLoss.toStringAsFixed(0);
                                      }
                                    },
                                    onChange: (value) {
                                      if (int.parse(value) <= 100) {
                                        model.changeCutLoss(
                                            cutLoss: value.isEmpty
                                                ? 0
                                                : double.parse(value));
                                      }
                                      if (value == "0") {
                                        _cutLossController.text = "不设置";
                                      } else if (int.parse(value) > 100) {
                                        _cutLossController.text = "100";
                                      }
                                    },
                                  ),
                                )
                                // child: IStep(
                                //   text: model.cutLoss.round() == 0
                                //       ? "不设置"
                                //       : "${model.cutLoss.round().toStringAsFixed(0)}%",
                                //   plusOnTap: () {
                                //     model.increaseCutLoss();
                                //   },
                                //   minusOnTap: () {
                                //     model.decreaseCutLoss();
                                //   },
                                // ),
                                )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 44,
                          child: WidgetFactory.button(
                              data: I18n.of(context).confirm,
                              color: Palette.redOrange,
                              onPressed: () async {
                                TextEditingController controller =
                                    TextEditingController();
                                if (locator.get<UserManager>().user.isLocked) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DialogFactory.unlockDialog(
                                            context,
                                            controller: controller);
                                      }).then((value) async {
                                    if (value) {
                                      callAmend(context, model);
                                    }
                                  });
                                } else {
                                  callAmend(context, model);
                                }
                              }),
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
}
