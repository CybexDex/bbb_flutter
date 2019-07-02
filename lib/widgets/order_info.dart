import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
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
                        data: I18n.of(context).closeOut, onPressed: () {}),
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
                              "40% / 50%",
                              style: StyleFactory.smallCellTitleStyle,
                            ),
                          ),
                          WidgetFactory.smallButton(
                              data: I18n.of(context).amend,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => SafeArea(
                                    bottom: false,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          color: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8),
                                                child: Text('Custom Dialog',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .none)),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15, bottom: 8),
                                                child: FlatButton(
                                                    onPressed: () {
                                                      // 关闭 Dialog
                                                      // Navigator.pop(_);
                                                    },
                                                    child: Text('确定')),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
        return ImageFactory.upIcon14;
      } else {
        return ImageFactory.downIcon14;
      }
    }
    return null;
  }

  Contract getCorrespondContract(
      {OrderResponseModel orderResponse,
      RefContractResponseModel refContract}) {
    for (Contract refContractResponseContract in refContract.contract) {
      if (orderResponse.contractId == refContractResponseContract.contractId) {
        return refContractResponseContract;
      }
    }

    return null;
  }
}
