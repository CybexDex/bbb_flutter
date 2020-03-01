import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/models/response/limit_order_response_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class LimitOrderRecordItem extends StatelessWidget {
  final LimitOrderResponse _model;
  LimitOrderRecordItem({LimitOrderResponse model, Key key})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isN = _model.contractId.contains("N");
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: getPnlIcon(isN),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 18),
                      child: Text(
                          isN
                              ? I18n.of(context).buyUp
                              : I18n.of(context).buyDown,
                          style: isN
                              ? StyleNewFactory.red15
                              : StyleNewFactory.green15),
                    ),
                    Text(
                      _model.contractId,
                      style: StyleNewFactory.black15,
                    ),
                  ],
                ),
                Text(
                  DateFormat("MM/dd HH:mm")
                      .format(DateTime.parse(_model.createTime)),
                  style: StyleNewFactory.grey14,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    I18n.of(context).openPositionPrice,
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    _model.highestTriggerPx != 0
                        ? _model.highestTriggerPx.toStringAsFixed(4)
                        : _model.lowestTriggerPx.toStringAsFixed(4),
                    style: StyleNewFactory.grey14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    I18n.of(context).forceClosePrice,
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    _model.strikePx.toStringAsFixed(4),
                    style: StyleNewFactory.grey14,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${I18n.of(context).actLevel}",
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    "${_model.contractId.contains("N") ? ((_model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx) / ((_model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx) - _model.strikePx)).toStringAsFixed(1) : ((_model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx) / (_model.strikePx - (_model.highestTriggerPx != 0 ? _model.highestTriggerPx : _model.lowestTriggerPx))).toStringAsFixed(1)}",
                    style: StyleNewFactory.grey14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${I18n.of(context).investPay}(USDT)",
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    OrderCalculate.calculateInvest(
                            orderQtyContract: _model.qtyContract,
                            orderBoughtContractPx: _model.boughtContractPx)
                        .toStringAsFixed(4),
                    style: StyleNewFactory.grey14,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${I18n.of(context).takeProfit}/${I18n.of(context).cutLoss}",
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    "--/100%",
                    style: StyleNewFactory.grey14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    I18n.of(context).limitOrderStatus,
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    limitOrderStatusResonCN(_model.status == "FAILED" &&
                            _model.failReason == "EXPIRED"
                        ? _model.failReason
                        : _model.status),
                    style: StyleNewFactory.grey14,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
