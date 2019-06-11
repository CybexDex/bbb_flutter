import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/utils/order_calculate_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatelessWidget {
  final OrderResponseModel orderResponseModel;
  final RefContractResponseModel refContractResponseModel;
  final WebSocketNXPriceResponseEntity webSocketNXPriceResponseEntity;

  OrderInfo(
      {Key key,
      this.orderResponseModel,
      this.refContractResponseModel,
      this.webSocketNXPriceResponseEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Contract currentContract = getCorrespondContract(
        refContract: refContractResponseModel,
        orderResponse: orderResponseModel);
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
                      orderResponse: orderResponseModel,
                      refContract: refContractResponseModel),
                ),
                Text(
                  orderResponseModel.contractId,
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
                    OrderCalculate.calculateRealTimeRevenue(
                        currentPx: webSocketNXPriceResponseEntity.px,
                        orderBoughtPx: orderResponseModel.boughtPx,
                        conversionRate:
                            double.parse(currentContract.conversionRate),
                        orderCommission: orderResponseModel.commission,
                        orderQtyContract: orderResponseModel.qtyContract),
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
                        currentPx: webSocketNXPriceResponseEntity.px,
                        strikeLevel: double.parse(currentContract.strikeLevel),
                        isUp: double.parse(currentContract.conversionRate) > 0),
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
                        orderQtyContract: orderResponseModel.qtyContract,
                        orderBoughtContractPx:
                            orderResponseModel.boughtContractPx),
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
                            data: I18n.of(context).amend, onPressed: () {}),
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
                    DateFormat("yyyy.MM.dd HH:mm")
                        .format(orderResponseModel.expiration),
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
  }

  Widget getUpOrDownIcon(
      {OrderResponseModel orderResponse,
      RefContractResponseModel refContract}) {
    for (Contract refContractResponseContract in refContract.contract) {
      if (refContractResponseContract.contractId == orderResponse.contractId) {
        if (double.parse(refContractResponseContract.conversionRate) > 0) {
          return ImageFactory.upIcon14;
        } else {
          return ImageFactory.downIcon14;
        }
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
