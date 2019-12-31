import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class OrderRecordItem extends StatelessWidget {
  final OrderResponseModel _model;
  OrderRecordItem({OrderResponseModel model, Key key})
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: getPnlIcon(isN),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: Text(
                      isN ? I18n.of(context).buyUp : I18n.of(context).buyDown,
                      style: isN
                          ? StyleNewFactory.red15
                          : StyleNewFactory.green15),
                ),
                Text(
                  _model.contractId,
                  style: StyleNewFactory.black15,
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
                    I18n.of(context).settlementTime,
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    DateFormat("MM-dd HH:mm:ss").format(
                        DateTime.parse(_model.lastUpdateTime).toLocal()),
                    style: StyleNewFactory.grey14,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                    "${I18n.of(context).profitAndLoss}(USDT)",
                    style: StyleNewFactory.appCellTitleLightGrey14,
                  ),
                  Text(
                    (_model.pnl + _model.commission + _model.accruedInterest)
                        .toStringAsFixed(4),
                    style: (_model.pnl +
                                _model.commission +
                                _model.accruedInterest) >
                            0
                        ? StyleNewFactory.red15
                        : StyleNewFactory.green15,
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
