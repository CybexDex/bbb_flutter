import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/limit_order_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LimitOrderInfo extends StatelessWidget {
  final LimitOrderResponse _model;
  LimitOrderInfo({Key key, LimitOrderResponse model})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double openPrice = OrderCalculate.calculateLimitOrderOpenPrice(_model.contractId.contains("N"),
        _model.highestTriggerPx, _model.lowestTriggerPx, _model.strikePx);

    double takeprofit = _model.takeProfitPx == 0
        ? null
        : OrderCalculate.getTakeProfit(
            _model.takeProfitPx,
            _model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx,
            _model.strikePx,
            _model.contractId.contains("N"));
    double cutLoss = _model.cutLossPx == _model.strikePx
        ? null
        : OrderCalculate.getCutLoss(
            _model.cutLossPx,
            _model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx,
            _model.strikePx,
            _model.contractId.contains("N"));
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
                      child: Text(_model.contractId, style: StyleNewFactory.grey12),
                    ),
                    getUpOrDownIcon(orderResponse: _model),
                    SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                DateFormat("MM/dd HH:mm")
                                    .format(DateTime.parse(_model.createTime).toLocal()),
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
                            _model.highestTriggerPx != 0
                                ? _model.highestTriggerPx.toStringAsFixed(4)
                                : _model.lowestTriggerPx.toStringAsFixed(4),
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
                            _model.strikePx.toStringAsFixed(4),
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
                            "${(_model.paidAmount - _model.commission).toStringAsFixed(4)}/${_model.qtyContract.toStringAsFixed(0)}",
                            style: StyleNewFactory.grey15,
                          ),
                          Expanded(
                            child: Container(),
                            flex: 15,
                          ),
                          Text(I18n.of(context).fee, style: StyleNewFactory.grey12Opacity60),
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
                          Text(I18n.of(context).actLevel, style: StyleNewFactory.grey12Opacity60),
                          Expanded(
                            child: Container(),
                            flex: 5,
                          ),
                          Text(
                            openPrice.toStringAsFixed(0),
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
                            "${takeprofit == null ? I18n.of(context).stepWidgetNotSetHint : (takeprofit.round().toStringAsFixed(0) + "%")} / ${cutLoss == null ? "100%" : (cutLoss.round().toStringAsFixed(0) + "%")}",
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
          ],
        ),
      );
    });
  }

  Widget getUpOrDownIcon({LimitOrderResponse orderResponse}) {
    if (orderResponse.contractId.contains("N")) {
      return SvgPicture.asset(
        R.resAssetsIconsIcWithdraw,
        color: Palette.redOrange,
        height: 10,
        width: 7,
      );
    } else {
      return SvgPicture.asset(
        R.resAssetsIconsIcDeposit,
        color: Palette.shamrockGreen,
        height: 10,
        width: 7,
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
}
