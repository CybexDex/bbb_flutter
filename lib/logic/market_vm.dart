import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/helper/time_duration_calculate_helper.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/k_line/entity/k_line_entity.dart';
import 'package:bbb_flutter/widgets/k_line/utils/data_util.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class MarketViewModel extends BaseModel {
  SuppleData suppleData;
  String dateFormat = "HH:mm";

  DateTime startTime;
  DateTime endTime;

  Offset lastOffset;
  MarketDuration marketDuration = MarketDuration.line;
  MarketManager _mtm;
  BBBAPI _bbbapi;
  MarketManager get mtm => _mtm;
  bool moving = false;
  List<KLineEntity> candleData = [];
  bool isline = true;

  MarketViewModel({@required MarketManager mtm, BBBAPI bbbapi}) {
    _mtm = mtm;
    _bbbapi = bbbapi;
  }

  seedToCurrent() {
    startTime = getCorrectTime().subtract(
        Duration(seconds: 20 * marketDurationSecondMap[marketDuration]));
    endTime = getCorrectTime()
        .add(Duration(seconds: 10 * marketDurationSecondMap[marketDuration]));
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
    _mtm.loadAllData("BXBT", marketDuration: marketDuration);
    if (marketDuration == MarketDuration.line) {
      this.marketDuration = marketDuration;
      seedToCurrent();
      setDateFormat(marketDuration);
      isline = true;
    } else {
      isline = false;
    }
    setBusy(false);
  }

  getCandle(MarketDuration marketDuration, bool isline) async {
    int now = getNowEpochSeconds();
    candleData = await _bbbapi.getMarketHistoryCandle(
        startTime:
            (now - 300 * marketDurationSecondMap[marketDuration]).toString(),
        endTime: now.toString(),
        asset: "BXBT",
        duration: marketDuration);
    DataUtil.calculate(candleData);
    this.isline = isline;
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
          underOrder: order.boughtPx + order.commission);
      if (contract != null &&
          contract.conversionRate > double.minPositive &&
          (data.last.value > order.takeProfitPx ||
              data.last.value < order.cutLossPx) &&
          (order.takeProfitPx != 0 &&
              order.cutLossPx != contract.strikeLevel)) {
        vm.getOrders();
      } else if (contract != null &&
          contract.conversionRate < 0 &&
          (data.last.value < order.takeProfitPx ||
              data.last.value > order.cutLossPx) &&
          (order.takeProfitPx != 0 &&
              order.cutLossPx != contract.strikeLevel)) {
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
          showCutoff: order.showCutoff,
          showProfit: order.showProfit,
          current: current,
          takeProfit: order.takeProfitPx == null ? 0 : order.takeProfitPx,
          // : OrderCalculate.takeProfitPx(
          //     order.takeProfit, current, strikeLevel, order.isUp),
          cutOff: order.cutoffPx == null ? strikeLevel : order.cutoffPx);
      // : OrderCalculate.cutLossPx(
      //     order.cutoff, current, strikeLevel, order.isUp));
    }
  }
}
