import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
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

  supplyDataWithTrade(
      List<TickerData> data, OrderViewModel vm, Contract contract) {
    final order = vm.getCurrentOrder();
    if (order != null && data != null && data.isNotEmpty) {
      suppleData = SuppleData(
          alwaysShow: false,
          current: data.last.value,
          takeProfit: order.takeProfitPx,
          cutOff: order.cutLossPx,
          underOrder: order.boughtPx);
      if (contract.conversionRate > double.minPositive &&
          (data.last.value > order.takeProfitPx ||
              data.last.value < order.cutLossPx)) {
        vm.getOrders();
      } else if (contract.conversionRate < 0 &&
          (data.last.value < order.takeProfitPx ||
              data.last.value > order.cutLossPx)) {
        vm.getOrders();
      }
    } else {
      if (!isAllEmpty(data)) {
        suppleData = SuppleData(
            alwaysShow: false,
            current: data.last.value,
            takeProfit: null,
            cutOff: null,
            underOrder: null);
      }
    }
  }

  supplyDataWithOrder(
      List<TickerData> data, OrderForm order, double strikeLevel) {
    if (order != null) {
      var current = data.last.value;
      suppleData = SuppleData(
          alwaysShow: true,
          current: current,
          takeProfit: OrderCalculate.takeProfitPx(
              order.takeProfit, current, strikeLevel, order.isUp),
          cutOff: OrderCalculate.cutLossPx(
              order.cutoff, current, strikeLevel, order.isUp));
    }
  }
}
