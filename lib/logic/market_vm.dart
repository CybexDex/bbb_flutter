import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class MarketViewModel extends BaseModel {
  SuppleData suppleData;

  DateTime startTime;
  DateTime endTime;

  Offset lastOffset;

  bool moving = false;

  seedToCurrent() {
    startTime = DateTime.now().subtract(Duration(minutes: 15));
    endTime = DateTime.now().add(Duration(minutes: 15));
    setBusy(false);
  }

  changeScope(DateTime start, DateTime end) {
    startTime = start;
    endTime = end;
    moving = true;
    setBusy(false);
  }

  supplyDataWithTrade(List<TickerData> data, OrderResponseModel order) {
    if (order != null) {
      suppleData = SuppleData(
          current: data.last.value,
          takeProfit: order.takeProfitPx,
          cutOff: order.cutLossPx,
          underOrder: order.boughtPx);
    } else {
      suppleData = SuppleData(
          current: data.last.value,
          takeProfit: null,
          cutOff: null,
          underOrder: null);
    }
  }

  supplyDataWithOrder(
      List<TickerData> data, OrderForm order, double strikeLevel) {
    if (order != null) {
      var current = data.last.value;
      suppleData = SuppleData(
          current: current,
          takeProfit: OrderCalculate.takeProfitPx(
              order.takeProfit, current, strikeLevel, order.isUp),
          cutOff: OrderCalculate.cutLossPx(
              order.takeProfit, current, strikeLevel, order.isUp));
    }
  }
}
