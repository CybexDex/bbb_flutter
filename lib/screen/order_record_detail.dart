import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderRecordDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RouteParamsOfTransactionRecords params =
        ModalRoute.of(context).settings.arguments;
    RefContractResponseModel refData = locator<RefManager>().lastData;
    Contract currentContract = getCorrespondContract(
        orderResponse: params.orderResponseModel, refContract: refData);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title:
              Text(I18n.of(context).tradingDetail, style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: OrderRecordDetailInfo(
            model: params.orderResponseModel,
            contract: currentContract,
          ),
        ));
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
}

class OrderRecordDetailHeader extends StatelessWidget {
  final OrderResponseModel _model;
  final Contract _contract;
  OrderRecordDetailHeader(
      {Key key, OrderResponseModel model, Contract contract})
      : _model = model,
        _contract = contract,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isN = _model.contractId.contains("N");
    return Container(
      height: 106,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0.0, 4.0),
                blurRadius: 12.0)
          ],
          borderRadius: BorderRadius.circular(4.0)),
      child: Column(
        children: <Widget>[
          Container(
            height: 53,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: getPnlIcon(isN),
                ),
                Text(isN ? I18n.of(context).buyUp : I18n.of(context).buyDown,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0)),
              ],
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    (_model.pnl + _model.commission + _model.accruedInterest)
                        .toStringAsFixed(4),
                    style: (_model.pnl +
                                _model.commission +
                                _model.accruedInterest) >
                            0
                        ? TextStyle(
                            color: Palette.redOrange,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: Dimen.hugLabelFontSize)
                        : TextStyle(
                            color: Palette.shamrockGreen,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: Dimen.hugLabelFontSize)),
                Text("   USDT",
                    style: (_model.pnl +
                                _model.commission +
                                _model.accruedInterest) >
                            0
                        ? TextStyle(
                            color: Palette.redOrange,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: Dimen.middleLabelFontSize)
                        : TextStyle(
                            color: Palette.shamrockGreen,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: Dimen.middleLabelFontSize))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderRecordDetailInfo extends StatelessWidget {
  final titles = [
    0,
    I18n.of(globalKey.currentContext).openPositionPrice,
    I18n.of(globalKey.currentContext).settlementPrice,
    I18n.of(globalKey.currentContext).investPay,
    I18n.of(globalKey.currentContext).fee,
    I18n.of(globalKey.currentContext).accruedInterest,
    I18n.of(globalKey.currentContext).pnl,
    I18n.of(globalKey.currentContext).takeProfit,
    I18n.of(globalKey.currentContext).cutLoss,
    I18n.of(globalKey.currentContext).openPositionTime,
    I18n.of(globalKey.currentContext).settlementTime,
    I18n.of(globalKey.currentContext).settlementType
  ];

  final OrderResponseModel _model;
  final Contract _contract;
  OrderRecordDetailInfo({Key key, OrderResponseModel model, Contract contract})
      : _model = model,
        _contract = contract,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    double takeprofit = OrderCalculate.getTakeProfit(_model.takeProfitPx,
        _model.boughtPx, _contract.strikeLevel, _contract.conversionRate > 0);
    double cutLoss = OrderCalculate.getCutLoss(_model.cutLossPx,
        _model.boughtPx, _contract.strikeLevel, _contract.conversionRate > 0);
    double invest = OrderCalculate.calculateInvest(
        orderQtyContract: _model.qtyContract,
        orderBoughtContractPx: _model.boughtContractPx);
    _itemBuilder(title, index) {
      if (index == 0) {
        return OrderRecordDetailHeader(model: _model, contract: _contract);
      }
      return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(
                color: Color(0xff666666),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ),
          trailing: Builder(builder: (context) {
            switch (index) {
              case 1:
                return Text(_model.boughtPx.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 2:
                return Text(_model.soldPx.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 3:
                return Text(invest.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 4:
                return Text(_model.commission.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 5:
                return Text(_model.accruedInterest.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 6:
                return Text(_model.pnl.toStringAsFixed(4),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));

              case 7:
                return Text(
                    _model.takeProfitPx == 0
                        ? I18n.of(context).stepWidgetNotSetHint
                        : _model.takeProfitPx.toStringAsFixed(4) +
                            "(" +
                            takeprofit.toStringAsFixed(0) +
                            "%)",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 8:
                return Text(
                    _model.cutLossPx == _contract.strikeLevel
                        ? I18n.of(context).stepWidgetNotSetHint
                        : _model.cutLossPx.toStringAsFixed(4) +
                            "(" +
                            cutLoss.toStringAsFixed(0) +
                            "%)",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 9:
                return Text(
                    DateFormat("yyyy/MM/dd HH:mm:ss")
                        .format(DateTime.parse(_model.createTime).toLocal()),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 10:
                return Text(
                    DateFormat("yyyy/MM/dd HH:mm:ss")
                        .format(DateTime.parse(_model.settleTime).toLocal()),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
              case 11:
                return Text(closeResonCN(_model.closeReason),
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));

              default:
                return Text("text",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0));
            }
          }));
    }

    return ListView.separated(
      itemBuilder: (BuildContext build, int position) {
        return _itemBuilder(this.titles[position], position);
      },
      separatorBuilder: (BuildContext build, int position) {
        if (position != 0) {
          return Divider(
            height: 1,
            color: Color(0xffdddddd),
          );
        }
        return Container();
      },
      itemCount: this.titles.length,
    );
  }
}
