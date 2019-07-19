import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class MarketViewModel extends BaseModel {
  SuppleData suppleData;
  String dateFormat = "HH:mm";

  DateTime startTime;
  DateTime endTime;

  Offset lastOffset;
  MarketDuration marketDuration = MarketDuration.oneMin;
  MarketManager _mtm;
  MarketManager get mtm => _mtm;
  bool moving = false;

  MarketViewModel({@required MarketManager mtm}) {
    _mtm = mtm;
  }

  seedToCurrent() {
    startTime = DateTime.now().subtract(
        Duration(seconds: 15 * marketDurationSecondMap[marketDuration]));
    endTime = DateTime.now()
        .add(Duration(seconds: 15 * marketDurationSecondMap[marketDuration]));
    setBusy(false);
  }

  changeScope(DateTime start, DateTime end) {
    startTime = start;
    endTime = end;
    moving = true;
    setBusy(false);
  }

  changeDuration(MarketDuration marketDuration) {
    _mtm.cleanData();
    _mtm.cancelAndRemoveData();
    _mtm.loadAllData("BXBT", marketDuration: marketDuration);
    this.marketDuration = marketDuration;
    seedToCurrent();
    setDateFormat(marketDuration);
    setBusy(false);
  }

  setDateFormat(MarketDuration marketDuration) {
    if (marketDuration == MarketDuration.oneDay) {
      dateFormat = "MM-dd";
    } else {
      dateFormat = "HH:mm";
    }
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
    if (order != null && !isAllEmpty(data)) {
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
