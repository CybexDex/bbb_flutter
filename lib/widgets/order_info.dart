import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
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
    double takeprofit = OrderCalculate.getTakeProfit(
        _model.takeProfitPx,
        _model.underlyingSpotPx,
        currentContract.strikeLevel,
        currentContract.conversionRate > 0);
    double cutLoss = OrderCalculate.getCutLoss(
        _model.cutLossPx,
        _model.underlyingSpotPx,
        currentContract.strikeLevel,
        currentContract.conversionRate > 0);

    return Consumer<List<TickerData>>(builder: (context, ticker, child) {
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
                    style: StyleFactory.smallCellTitleStyle,
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: WidgetFactory.smallButton(
                        data: I18n.of(context).closeOut,
                        onPressed: () async {
                          if (locator.get<UserManager>().user.isLocked) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogFactory.sellOrderDialog(
                                    context,
                                    title: I18n.of(context).closeOut,
                                    contentText: I18n.of(context).futureProfit,
                                    value:
                                        "${(_model.pnl * _model.qtyContract).toStringAsFixed(2)} USDT",
                                  );
                                }).then((value) async {
                              if (value) {
                                callAmend(context);
                              }
                            });
                          } else {
                            callAmend(context);
                          }
                        }),
                  )),
                ],
              ),
            ),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
                flex: 16,
                child: Row(
                  children: <Widget>[
                    Text(
                      I18n.of(context).futureProfit,
                      style: StyleFactory.subTitleStyle,
                    ),
                    Text(
                      (_model.pnl * _model.qtyContract).toStringAsFixed(2) +
                          " USDT",
                      style: StyleFactory.smallCellTitleStyle,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
                flex: 16,
                child: Row(
                  children: <Widget>[
                    Text(
                      I18n.of(context).actLevel,
                      style: StyleFactory.subTitleStyle,
                    ),
                    Text(
                      OrderCalculate.calculateRealLeverage(
                              currentPx: ticker.last.value,
                              strikeLevel:
                                  currentContract.strikeLevel.toDouble(),
                              isUp: currentContract.conversionRate > 0)
                          .toStringAsFixed(2),
                      style: StyleFactory.smallCellTitleStyle,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
                flex: 16,
                child: Row(
                  children: <Widget>[
                    Text(
                      I18n.of(context).invest,
                      style: StyleFactory.subTitleStyle,
                    ),
                    Text(
                      OrderCalculate.calculateInvest(
                                  orderQtyContract: _model.qtyContract,
                                  orderBoughtContractPx:
                                      _model.boughtContractPx)
                              .toStringAsFixed(2) +
                          " USDT",
                      style: StyleFactory.smallCellTitleStyle,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
                flex: 20,
                child: Row(
                  children: <Widget>[
                    Text(
                      "${I18n.of(context).takeProfit}/${I18n.of(context).cutLoss}",
                      style: StyleFactory.subTitleStyle,
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "${takeprofit.toStringAsFixed(0)}% / ${cutLoss.toStringAsFixed(0)}%",
                              style: StyleFactory.smallCellTitleStyle,
                            ),
                          ),
                          WidgetFactory.smallButton(
                              data: I18n.of(context).amend,
                              onPressed: () {
                                openDialog(
                                  context,
                                );
                              }),
                        ],
                      ),
                    )),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                )),
            Expanded(
                flex: 16,
                child: Row(
                  children: <Widget>[
                    Text(
                      I18n.of(context).forceExpiration,
                      style: StyleFactory.subTitleStyle,
                    ),
                    Text(
                      DateFormat("yyyy.MM.dd HH:mm").format(_model.expiration),
                      style: StyleFactory.smallCellTitleStyle,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            Expanded(
                flex: 15,
                child: SizedBox(
                  height: 10,
                ))
          ],
        ),
      );
    });
  }

  Widget getUpOrDownIcon(
      {OrderResponseModel orderResponse, Contract refContract}) {
    if (refContract.contractId == orderResponse.contractId) {
      if (refContract.conversionRate > 0) {
        return Image.asset(R.resAssetsIconsIcUpRed14);
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
      Provider.of<OrderViewModel>(context).getOrders();
      Navigator.of(context).pop();
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
      await pnlViewModel.amend(_model, true);
      Navigator.of(context).pop();
      showToast(context, false,
          I18n.of(context).closeOut + I18n.of(context).successToast);
      Future.delayed(Duration(seconds: 2), () {
        Provider.of<OrderViewModel>(context).getOrders();
      });
    } catch (error) {
      Navigator.of(context).pop();
      showToast(context, true,
          I18n.of(context).closeOut + I18n.of(context).failToast);
    }
  }
}
