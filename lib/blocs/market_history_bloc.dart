import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:rxdart/rxdart.dart';

import '../env.dart';

class MarketHistoryBloc {
  BehaviorSubject<List<TickerData>> marketHistorySubject =
      BehaviorSubject<List<TickerData>>();

  dispose() {
    marketHistorySubject.close();
  }

  fetchPriceHistory({String startTime, String endTime, String asset}) async {
    List<MarketHistoryResponseModel> _list = await Env.apiClient
        .getMarketHistory(startTime: startTime, endTime: endTime, asset: asset);
    List<TickerData> tickerDataList = _list.map((marketHistoryResponseModel) {
      var tickerData = TickerData(marketHistoryResponseModel.px,
          DateTime.fromMicrosecondsSinceEpoch(marketHistoryResponseModel.xts));
      return tickerData;
    }).toList(growable: true);
    marketHistorySubject.sink.add(tickerDataList);
  }
}
