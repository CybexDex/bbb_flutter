import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class MarketManager {
  Stream<List<TickerData>> get prices => _priceController.stream;
  BehaviorSubject<TickerData> lastTicker = BehaviorSubject<TickerData>();

  static const String _SERVER_ADDRESS = "wss://nxmdptest.cybex.io/";

  BehaviorSubject<List<TickerData>> _priceController =
      BehaviorSubject<List<TickerData>>();
  IOWebSocketChannel _channel;

  BBBAPIProvider _api;

  MarketManager({BBBAPIProvider api}) : _api = api;

  String _assetName;

  loadAllData(String assetName) async {
    _assetName = assetName ?? _assetName;
    if (isAllEmpty(_assetName)) {
      return;
    }
    int now = getNowEpochSeconds();
    await loadMarketHistory(
        startTime: (now - 300 * 60).toString(),
        endTime: now.toString(),
        asset: _assetName);
    initCommunication();
    send(jsonEncode(WebSocketRequestEntity(
            type: "subscribe", topic: "FAIRPRICE.$_assetName"))
        .toString());
  }

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
    lastTicker.add(data.last);
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
      var t_time = DateTime.parse(wbResponse.time);

      var t = TickerData(wbResponse.px, t_time);

      lastTicker.add(t);
      if (isAllEmpty(_priceController.value)) {
        _priceController.value.add(t);
        _priceController.add(_priceController.value.toList());
        return;
      }

      var phase =
          (_priceController.value.last.time.minute - t.time.minute).abs();
      if (phase == 1) {
        _priceController.value.add(t);
        if (_priceController.value.length >= 500) {
          _priceController.value.removeRange(0, 200);
        }
        _priceController.add(_priceController.value.toList());
      }
    }, onError: (error) {
      cancelAndRemoveData();
      loadAllData(_assetName);
    });
  }

  cancelAndRemoveData() {
    reset();
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
