import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatelessWidget {
  final OrderResponseModel _model;
  final bool _isAll;
  OrderInfo({Key key, OrderResponseModel model, bool isAll})
      : _model = model,
        _isAll = isAll,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double takeprofit = _model.takeProfitPx == 0
        ? null
        : OrderCalculate.getTakeProfit(_model.takeProfitPx, _model.boughtPx,
            _model.strikePx, _model.contractId.contains("N"));
    double cutLoss = _model.cutLossPx == _model.strikePx
        ? null
        : OrderCalculate.getCutLoss(_model.cutLossPx, _model.boughtPx,
            _model.strikePx, _model.contractId.contains("N"));
    double invest = OrderCalculate.calculateInvest(
        orderQtyContract: _model.qtyContract,
        orderBoughtContractPx: _model.boughtContractPx);

    return Consumer<TickerData>(builder: (context, ticker, child) {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 40,
              child: Container(
                color: Color(0xfff6f6f6),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Text(_model.contractId,
                          style: StyleNewFactory.grey12),
                    ),
                    getUpOrDownIcon(orderResponse: _model),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                        "${I18n.of(context).actLevel}${_model.contractId.contains("N") ? (_model.boughtPx / (_model.boughtPx - _model.strikePx)).toStringAsFixed(1) : (_model.boughtPx / (_model.strikePx - _model.boughtPx)).toStringAsFixed(1)}",
                        style: StyleNewFactory.grey12),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                DateFormat("MM/dd HH:mm").format(
                                    DateTime.parse(_model.createTime)
                                        .toLocal()),
                                style: StyleNewFactory.grey12))),
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 150,
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 23,
                            child: Container(),
                          ),
                          Text(I18n.of(context).openPositionPrice,
                              style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            _model.boughtPx.toStringAsFixed(4),
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(flex: 15, child: Container()),
                          Text(I18n.of(context).forceClosePrice,
                              style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            _model.forceClosePx.toStringAsFixed(4),
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            flex: 23,
                            child: Container(),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 23,
                            child: Container(),
                          ),
                          Text(
                              "${I18n.of(context).invest}/${I18n.of(context).investAmountOrderInfo}",
                              style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            "${invest.toStringAsFixed(4)}/${_model.qtyContract.toStringAsFixed(0)}",
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            child: Container(),
                            flex: 15,
                          ),
                          Text(I18n.of(context).fee,
                              style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            _model.commission.toStringAsFixed(4),
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            flex: 23,
                            child: Container(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 23,
                            child: Container(),
                          ),
                          Text(I18n.of(context).accruedInterest,
                              style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            _model.accruedInterest.toStringAsFixed(4),
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            child: Container(),
                            flex: 15,
                          ),
                          Text(
                            "${I18n.of(context).takeProfit}/${I18n.of(context).cutLoss}",
                            style: StyleNewFactory.grey12Opacity60,
                          ),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            "${takeprofit == null ? I18n.of(context).stepWidgetNotSetHint : (takeprofit.round().toStringAsFixed(0) + "%")} / ${cutLoss == null ? I18n.of(context).stepWidgetNotSetHint : (cutLoss.round().toStringAsFixed(0) + "%")}",
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            flex: 23,
                            child: Container(),
                          ),
                        ],
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
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
            _isAll
                ? Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(color: Palette.separatorColor))
                : Container(
                    color: Color(0xfff6f6f6),
                    height: 7,
                  ),

            _isAll
                ? Expanded(
                    flex: 50,
                    child: Container(
                      padding: EdgeInsets.only(right: 15, left: 15),
                      child: Row(
                        children: <Widget>[
                          Text(I18n.of(context).futureProfit,
                              style: StyleNewFactory.grey14),
                          Row(
                            children: <Widget>[
                              Text(
                                (_model.pnl).toStringAsFixed(4) +
                                    "(" +
                                    (100 * ((_model.pnl) / invest))
                                        .toStringAsFixed(1) +
                                    "%)",
                                style: (_model.pnl) > 0
                                    ? StyleFactory.buyUpOrderInfo
                                    : StyleFactory.buyDownOrderInfo,
                              ),
                              Text(
                                " USDT",
                                style: StyleFactory.cellTitleStyle,
                              )
                              // WidgetFactory.button(
                              //     data: I18n.of(context).closeOut,
                              //     color: Palette.redOrange,
                              //     topPadding: 5,
                              //     bottomPadding: 5,
                              //     onPressed: () async {
                              //       TextEditingController controller =
                              //           TextEditingController();
                              //       showDialog(
                              //           barrierDismissible: false,
                              //           context: context,
                              //           builder: (context) {
                              //             return DialogFactory
                              //                 .closeOutConfirmDialog(context,
                              //                     value: (_model.pnl +
                              //                             _model.commission +
                              //                             _model.accruedInterest)
                              //                         .toStringAsFixed(4),
                              //                     pnl:
                              //                         _model.pnl.toStringAsFixed(4),
                              //                     controller: controller);
                              //           }).then((value) async {
                              //         if (value != null && value) {
                              //           callAmend(context);
                              //         }
                              //       });
                              //     }),
                            ],
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ))
                : Expanded(
                    flex: 50,
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("${I18n.of(context).futureProfit} ",
                                  style: StyleNewFactory.grey14),
                              Text(
                                (_model.pnl).toStringAsFixed(4) +
                                    "(" +
                                    (100 * ((_model.pnl) / invest))
                                        .toStringAsFixed(1) +
                                    "%)",
                                style: (_model.pnl) > 0
                                    ? StyleFactory.buyUpOrderInfo
                                    : StyleFactory.buyDownOrderInfo,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              TextEditingController controller =
                                  TextEditingController();
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return DialogFactory.closeOutConfirmDialog(
                                        context,
                                        value: (_model.pnl).toStringAsFixed(4),
                                        pnl: (_model.pnl -
                                                _model.accruedInterest -
                                                _model.commission)
                                            .toStringAsFixed(4),
                                        controller: controller);
                                  }).then((value) async {
                                if (value != null && value) {
                                  callAmend(context);
                                }
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: new Text(
                                  "平仓",
                                  style: TextStyle(color: Colors.white),
                                ),
                                width: 130,
                                color: Palette.invitePromotionBadgeColor),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    )),
          ],
        ),
      );
    });
  }

  Widget getUpOrDownIcon({OrderResponseModel orderResponse}) {
    if (orderResponse.contractId.contains("N")) {
      return Icon(
        Icons.arrow_upward,
        color: Palette.redOrange,
      );
    } else {
      return Icon(
        Icons.arrow_downward,
        color: Palette.shamrockGreen,
      );
    }
  }

  Contract getCorrespondContract(
      {OrderResponseModel orderResponse, ContractResponse contractResponse}) {
    if (contractResponse == null) {
      return null;
    }
    for (Contract refContractResponseContract in contractResponse.contract) {
      if (orderResponse.contractId == refContractResponseContract.contractId) {
        return refContractResponseContract;
      }
    }

    return null;
  }

  // openDialog(BuildContext context, OrderResponseModel model) {
  //   Function callback = () {
  //     Navigator.of(context).popUntil((route) => route.isFirst);
  //   };
  //   showGeneralDialog(
  //     context: context,
  //     pageBuilder: (BuildContext buildContext, Animation<double> animation,
  //         Animation<double> secondaryAnimation) {
  //       return Builder(builder: (BuildContext context) {
  //         return PnlForm(model: model, callback: callback);
  //       });
  //     },
  //     barrierDismissible: true,
  //     barrierLabel: "",
  //     barrierColor: Colors.black54,
  //     transitionDuration: const Duration(milliseconds: 150),
  //     transitionBuilder: _buildMaterialDialogTransitions,
  //   ).then((v) {});
  // }

  // Widget _buildMaterialDialogTransitions(
  //     BuildContext context,
  //     Animation<double> animation,
  //     Animation<double> secondaryAnimation,
  //     Widget child) {
  //   return SlideTransition(
  //     position: CurvedAnimation(
  //       parent: animation,
  //       curve: Curves.easeOut,
  //     ).drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)),
  //     child: child,
  //   );
  // }

  callAmend(BuildContext context) async {
    PnlViewModel pnlViewModel = PnlViewModel(
        api: locator.get(),
        um: locator.get(),
        mtm: locator.get(),
        refm: locator.get());
    try {
      showLoading(context, isBarrierDismissible: false);
      PostOrderResponseModel postOrderResponseModel =
          await pnlViewModel.amend(_model, true, false);
      Navigator.of(context).pop();
      if (postOrderResponseModel.code != 0) {
        showNotification(context, true, postOrderResponseModel.msg);
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
