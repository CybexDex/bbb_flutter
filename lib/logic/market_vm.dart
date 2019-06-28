import 'package:bbb_flutter/base/base_model.dart';
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
    }
  }

  supplyDataWithOrder(List<TickerData> data, OrderForm order) {
    if (order != null) {
      var current = data.last.value;
      if (order.isUp) {
        suppleData = SuppleData(
            current: current,
            takeProfit: (order.takeProfit + 100) * current / 100,
            cutOff: (100 - order.cutoff) * current / 100);
      } else {
        suppleData = SuppleData(
            current: current,
            takeProfit: (100 - order.takeProfit) * current / 100,
            cutOff: (100 + order.cutoff) * current / 100);
      }
    }
  }
}
