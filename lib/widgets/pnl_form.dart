import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/istep.dart';

class PnlForm extends StatelessWidget {
  OrderResponseModel _order;
  Function _callback;
  PnlForm({Key key, OrderResponseModel model, Function() callback})
      : _order = model,
        _callback = callback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PnlViewModel>(
      model: PnlViewModel(
          api: locator.get(),
          um: locator.get(),
          mtm: locator.get(),
          refm: locator.get()),
      onModelReady: (model) {
        final contract = model.currentContract(_order);

        model.takeProfit = OrderCalculate.getTakeProfit(
            _order.takeProfitPx,
            _order.underlyingSpotPx,
            contract.strikeLevel,
            contract.conversionRate > 0);

        model.cutLoss = OrderCalculate.getCutLoss(
            _order.cutLossPx,
            _order.underlyingSpotPx,
            contract.strikeLevel,
            contract.conversionRate > 0);
      },
      builder: (context, model, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: DecorationFactory.dialogChooseDecoration,
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
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
                          width: 76,
                          child: IStep(
                              text: "${model.takeProfit.toStringAsFixed(0)}%",
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
                      height: 20,
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
                            text: "${model.cutLoss.toStringAsFixed(0)}%",
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
                                    return DialogFactory.unlockDialog(context,
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
    );
  }

  callAmend(
    BuildContext context,
    PnlViewModel model,
  ) async {
    try {
      showLoading(context);
      await model.amend(_order, false);
      Navigator.of(context).pop();
      showToast(context, false, I18n.of(context).successToast);
      Future.delayed(Duration(seconds: 2), () {
        _callback();
      });
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
    }
  }
}
