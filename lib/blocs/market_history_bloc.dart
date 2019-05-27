import 'dart:convert';

import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../env.dart';

class MarketHistoryBloc {
  BehaviorSubject<List<TickerData>> marketHistorySubject =
      BehaviorSubject<List<TickerData>>();

  dispose() {
    marketHistorySubject.close();
  }

//  startWebSocket() {
//    WebSocketChannel channel =
//        IOWebSocketChannel.connect("wss://nxmdptest.cybex.io/");
//    channel.sink.add(jsonEncode(
//        WebSocketRequestEntity(type: "subscribe", topic: "FAIRPRICE.BXBT")));
//    channel.stream.listen((message) {
//      log.info(message);
//    }, onError: () {}, onDone: () {}, cancelOnError: true);
//  }

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
