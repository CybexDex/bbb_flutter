import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/revise_px_widget.dart';
import 'package:bbb_flutter/widgets/revise_widget.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController _takeProfitPxController = TextEditingController();
  TextEditingController _cutLossPxController = TextEditingController();

  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

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
            model.cutLossPx = widget._order.cutLossPx;
            model.takeProfitPx = widget._order.takeProfitPx;

            double invest = OrderCalculate.calculateInvest(
                orderQtyContract: widget._order.qtyContract,
                orderBoughtContractPx: widget._order.boughtContractPx);

            model.pnlPercent = (100 *
                    ((widget._order.pnl +
                            widget._order.commission +
                            widget._order.accruedInterest) /
                        invest))
                .abs();

            _cutLossController.text = model.cutLoss == null
                ? I18n.of(context).stepWidgetNotSetHint
                : model.cutLoss.round().toStringAsFixed(0);
            _takeProfitController.text = model.takeProfit == null
                ? I18n.of(context).stepWidgetNotSetHint
                : model.takeProfit.round().toStringAsFixed(0);

            _cutLossPxController.text = model.cutLossPx == contract.strikeLevel
                ? I18n.of(context).stepWidgetNotSetHint
                : model.cutLossPx.round().toStringAsFixed(0);
            _takeProfitPxController.text = model.takeProfitPx == 0
                ? I18n.of(context).stepWidgetNotSetHint
                : model.takeProfitPx.round().toStringAsFixed(0);
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Image.asset(R.resAssetsIconsIcMaskClose),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          width: 250,
                          child: Material(
                            child: Container(
                              color: Colors.white,
                              child: CupertinoSegmentedControl(
                                children: {
                                  0: Container(
                                    height: 35,
                                    child: Text(
                                      I18n.of(context).pnlAmendByPrice,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: currentSegment == 0
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  1: Container(
                                    height: 35,
                                    child: Text(
                                      I18n.of(context).pnlAmendByPercentage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: currentSegment == 1
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                },
                                onValueChanged: onValueChanged,
                                groupValue: currentSegment,
                                selectedColor:
                                    Palette.invitePromotionBadgeColor,
                                borderColor: Palette.separatorColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Palette.separatorColor,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        currentSegment == 0
                            ? RevisePxWidget(
                                order: widget._order,
                                pnlViewModel: model,
                                takeProfitPxController: _takeProfitPxController,
                                takeProfitController: _takeProfitController,
                                cutLossController: _cutLossController,
                                cutLossPxController: _cutLossPxController)
                            : ReviseWidget(
                                order: widget._order,
                                pnlViewModel: model,
                                takeProfitController: _takeProfitController,
                                takeProfitPxController: _takeProfitPxController,
                                cutLossController: _cutLossController,
                                cutLossPxController: _cutLossPxController,
                              ),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 44,
                          child: WidgetFactory.button(
                              data: I18n.of(context).confirm,
                              color: (model.isCutLossInputCorrect &&
                                      model.isTakeProfitInputCorrect &&
                                      model.isCutLossCorrect)
                                  ? Palette.redOrange
                                  : Palette.subTitleColor,
                              onPressed: (model.isCutLossInputCorrect &&
                                      model.isTakeProfitInputCorrect &&
                                      model.isCutLossCorrect)
                                  ? () {
                                      onClickConfirm(model: model);
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

  onClickConfirm({PnlViewModel model}) {
    bool isPercentShouldShowDialog = (model.takeProfit != null &&
            ((model.pnlPercent > model.takeProfit &&
                    widget._order.pnl +
                            widget._order.commission +
                            widget._order.accruedInterest >
                        0) ||
                model.takeProfit < 0)) ||
        (model.cutLoss != null &&
            ((model.pnlPercent > model.cutLoss &&
                    widget._order.pnl +
                            widget._order.commission +
                            widget._order.accruedInterest <
                        0) ||
                (model.cutLoss < 0)));
    if ((isPercentShouldShowDialog)) {
      showDialog(
          context: context,
          builder: (context) {
            return DialogFactory.normalConfirmDialog(context,
                title: I18n.of(context).remider,
                content: I18n.of(context).triggerCloseContent,
                onConfirmPressed: () {
              Navigator.of(context).pop(true);
            });
          }).then((onValue) {
        if (onValue) {
          _onClickSubmit(context: context, model: model);
        }
      });
    } else {
      _onClickSubmit(context: context, model: model);
    }
  }

  callAmend(
    BuildContext context,
    PnlViewModel model,
  ) async {
    try {
      showLoading(context);
      PostOrderResponseModel postOrderResponseModel =
          await model.amend(widget._order, false, currentSegment == 0);
      Navigator.of(context).pop();
      if (postOrderResponseModel.status == "Failed") {
        showNotification(context, true, postOrderResponseModel.errorMesage);
      } else {
        showNotification(context, false, I18n.of(context).successToast,
            callback: widget._callback);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showNotification(context, true, I18n.of(context).failToast);
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
