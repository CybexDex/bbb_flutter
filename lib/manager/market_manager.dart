import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class MarketManager {
  Stream<List<TickerData>> get prices => _priceController.stream;
  TickerData get lastTicker => _priceController.value.last;

  static const String _SERVER_ADDRESS = "wss://nxmdptest.cybex.io/";

  BehaviorSubject<List<TickerData>> _priceController =
      BehaviorSubject<List<TickerData>>();
  IOWebSocketChannel _channel;

  BBBAPIProvider _api;

  MarketManager({BBBAPIProvider api}) : _api = api;

// startTime: DateTime.now()
//             .subtract(Duration(days: 30))
//             .toUtc()
//             .toIso8601String(),
//         endTime: DateTime.now().toUtc().toIso8601String(),
//         asset: "BXBT"
  loadMarketHistory({String startTime, String endTime, String asset}) async {
    List<MarketHistoryResponseModel> _list = await _api.getMarketHistory(
        startTime: startTime, endTime: endTime, asset: asset);
    List<TickerData> data = _list.map((marketHistoryResponseModel) {
      var tickerData = TickerData(marketHistoryResponseModel.px,
          DateTime.fromMicrosecondsSinceEpoch(marketHistoryResponseModel.xts));
      return tickerData;
    }).toList();

    _priceController.add(data);
  }

// send(jsonEncode(
//             WebSocketRequestEntity(type: "subscribe", topic: "FAIRPRICE.BXBT"))
//         .toString());
  initCommunication() {
    reset();

    _channel = IOWebSocketChannel.connect(MarketManager._SERVER_ADDRESS);
    _channel.stream.listen((onData) {
      var wbResponse =
          WebSocketNXPriceResponseEntity.fromJson(json.decode(onData));
      _priceController.add(_priceController.value
        ..add(TickerData(wbResponse.px, DateTime.parse(wbResponse.time))));
    });
  }

  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
      }
    }
  }

  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.add(message);
      }
    }
  }
}
