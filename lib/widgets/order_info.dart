import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/widgets/pnl_form.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatelessWidget {
  final OrderResponseModel _model;
  OrderInfo({Key key, OrderResponseModel model})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    RefContractResponseModel refData = locator<RefManager>().lastData;
    Contract currentContract =
        getCorrespondContract(orderResponse: _model, refContract: refData);
    double takeprofit = _model.takeProfitPx == 0
        ? null
        : OrderCalculate.getTakeProfit(_model.takeProfitPx, _model.boughtPx,
            currentContract.strikeLevel, currentContract.conversionRate > 0);
    double cutLoss = _model.cutLossPx == currentContract.strikeLevel
        ? null
        : OrderCalculate.getCutLoss(_model.cutLossPx, _model.boughtPx,
            currentContract.strikeLevel, currentContract.conversionRate > 0);
    double invest = OrderCalculate.calculateInvest(
        orderQtyContract: _model.qtyContract,
        orderBoughtContractPx: _model.boughtContractPx);

    return Consumer<TickerData>(builder: (context, ticker, child) {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: getUpOrDownIcon(
                        orderResponse: _model, refContract: currentContract),
                  ),
                  Text(
                    _model.contractId,
                    style: StyleFactory.cellTitleStyle,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "${I18n.of(context).actLevel}${currentContract.conversionRate > 0 ? (_model.boughtPx / (_model.boughtPx - currentContract.strikeLevel)).toStringAsFixed(1) : (_model.boughtPx / (currentContract.strikeLevel - _model.boughtPx)).toStringAsFixed(1)}",
                    style: StyleFactory.cellDescLabel,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat("MM/dd HH:mm").format(
                                DateTime.parse(_model.createTime).toLocal()),
                            style: StyleFactory.transferStyleTitle,
                          ))),
                ],
              ),
            ),
            Expanded(flex: 5, child: SizedBox()),
            Divider(color: Palette.separatorColor),
            Expanded(
                flex: 115,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          I18n.of(context).openPositionPrice,
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _model.boughtPx.toStringAsFixed(4),
                          style: StyleFactory.cellTitleStyle,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Text(
                          I18n.of(context).forceClosePrice,
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _model.forceClosePx.toStringAsFixed(4),
                          style: StyleFactory.cellTitleStyle,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${I18n.of(context).invest}/${I18n.of(context).investAmountOrderInfo}",
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          "${invest.toStringAsFixed(4)}/${_model.qtyContract.toStringAsFixed(0)}",
                          style: StyleFactory.cellTitleStyle,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Text(
                          I18n.of(context).fee,
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _model.commission.toStringAsFixed(4),
                          style: StyleFactory.cellTitleStyle,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(I18n.of(context).accruedInterest,
                            style: StyleFactory.cellDescLabel),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _model.accruedInterest.toStringAsFixed(4),
                          style: StyleFactory.cellTitleStyle,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Text(
                          "${I18n.of(context).takeProfit}/${I18n.of(context).cutLoss}",
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "${takeprofit == null ? I18n.of(context).stepWidgetNotSetHint : (takeprofit.round().toStringAsFixed(0) + "%")} / ${cutLoss == null ? I18n.of(context).stepWidgetNotSetHint : (cutLoss.round().toStringAsFixed(0) + "%")}",
                              style: StyleFactory.cellTitleStyle,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Image.asset(R.resAssetsIconsIcRevise)),
                              onTap: () {
                                openDialog(globalKey.currentContext);
                              },
                            )
                          ],
                        )
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            // Expanded(
            //     flex: 65,
            //     child: Row(
            //       children: <Widget>[
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: <Widget>[
            //             Text(
            //               I18n.of(context).forcePrice,
            //               style: StyleFactory.cellDescLabel,
            //             ),
            //             SizedBox(
            //               height: 1,
            //             ),
            //             Text(
            //               _model.forceClosePx.toStringAsFixed(4),
            //               style: StyleFactory.cellTitleStyle,
            //             ),
            //           ],
            //         ),
            //         Column(
            //           children: <Widget>[
            //             Text(
            //               I18n.of(context).fee,
            //               style: StyleFactory.cellDescLabel,
            //             ),
            //             SizedBox(
            //               height: 1,
            //             ),
            //             Text(
            //               _model.commission.toStringAsFixed(4),
            //               style: StyleFactory.cellTitleStyle,
            //             )
            //           ],
            //         ),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: <Widget>[
            //             Text(
            //               "${I18n.of(context).takeProfit}/${I18n.of(context).cutLoss}",
            //               style: StyleFactory.cellDescLabel,
            //             ),
            //             SizedBox(
            //               height: 1,
            //             ),
            //             Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Padding(
            //                   padding: EdgeInsets.only(right: 10),
            //                   child: Text(
            //                     "${takeprofit == null ? I18n.of(context).stepWidgetNotSetHint : (takeprofit.round().toStringAsFixed(0) + "%")} / ${cutLoss == null ? I18n.of(context).stepWidgetNotSetHint : (cutLoss.round().toStringAsFixed(0) + "%")}",
            //                     style: StyleFactory.cellTitleStyle,
            //                   ),
            //                 ),
            //                 GestureDetector(
            //                   child: Image.asset(R.resAssetsIconsIcRevise),
            //                   onTap: () {
            //                     openDialog(context);
            //                   },
            //                 )
            //               ],
            //             )
            //           ],
            //         )
            //       ],
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     )),
            Divider(color: Palette.separatorColor),
            Expanded(
                flex: 60,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          I18n.of(context).futureProfit,
                          style: StyleFactory.cellDescLabel,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              (_model.pnl +
                                          _model.commission +
                                          _model.accruedInterest)
                                      .toStringAsFixed(4) +
                                  "(" +
                                  (100 *
                                          ((_model.pnl +
                                                  _model.commission +
                                                  _model.accruedInterest) /
                                              invest))
                                      .toStringAsFixed(1) +
                                  "%)",
                              style: (_model.pnl +
                                          _model.commission +
                                          _model.accruedInterest) >
                                      0
                                  ? StyleFactory.buyUpOrderInfo
                                  : StyleFactory.buyDownOrderInfo,
                            ),
                            Text(
                              " USDT",
                              style: StyleFactory.cellTitleStyle,
                            )
                          ],
                        )
                      ],
                    ),
                    WidgetFactory.button(
                        data: I18n.of(context).closeOut,
                        color: Palette.redOrange,
                        topPadding: 5,
                        bottomPadding: 5,
                        onPressed: () async {
                          TextEditingController controller =
                              TextEditingController();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DialogFactory.closeOutConfirmDialog(
                                    context,
                                    value: (_model.pnl +
                                            _model.commission +
                                            _model.accruedInterest)
                                        .toStringAsFixed(4),
                                    pnl: _model.pnl.toStringAsFixed(4),
                                    controller: controller);
                              }).then((value) async {
                            if (value != null && value) {
                              callAmend(context);
                            }
                          });
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
            Expanded(flex: 5, child: SizedBox())
          ],
        ),
      );
    });
  }

  Widget getUpOrDownIcon(
      {OrderResponseModel orderResponse, Contract refContract}) {
    if (refContract.contractId == orderResponse.contractId) {
      if (refContract.conversionRate > 0) {
        return Image.asset(R.resAssetsIconsIcUpRed14, width: 14, height: 14);
      } else {
        return Image.asset(R.resAssetsIconsIcDownGreen14);
      }
    }
    return null;
  }

  Contract getCorrespondContract(
      {OrderResponseModel orderResponse,
      RefContractResponseModel refContract}) {
    if (refContract == null) {
      return null;
    }
    for (Contract refContractResponseContract in refContract.contract) {
      if (orderResponse.contractId == refContractResponseContract.contractId) {
        return refContractResponseContract;
      }
    }

    return null;
  }

  openDialog(BuildContext context) {
    Function callback = () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    };
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(builder: (BuildContext context) {
          return PnlForm(model: _model, callback: callback);
        });
      },
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    ).then((v) {
//
    });
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ).drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)),
      child: child,
    );
  }

  callAmend(BuildContext context) async {
    PnlViewModel pnlViewModel = PnlViewModel(
        api: locator.get(),
        um: locator.get(),
        mtm: locator.get(),
        refm: locator.get());
    try {
      showLoading(context);
      PostOrderResponseModel postOrderResponseModel =
          await pnlViewModel.amend(_model, true);
      Navigator.of(context).pop();
      if (postOrderResponseModel.status == "Failed") {
        showNotification(context, true, postOrderResponseModel.errorMesage);
      } else {
        showNotification(context, false,
            I18n.of(context).closeOut + I18n.of(context).successToast);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showNotification(context, true,
          I18n.of(context).closeOut + I18n.of(context).failToast);
    }
  }
}
