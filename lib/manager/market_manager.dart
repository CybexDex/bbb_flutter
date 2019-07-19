import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';
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

  BBBAPI _api;

  MarketManager({BBBAPI api}) : _api = api;

  String _assetName;
  MarketDuration _marketDuration = MarketDuration.oneMin;

  loadAllData(String assetName, {MarketDuration marketDuration}) async {
    _assetName = assetName ?? _assetName;
    _marketDuration = marketDuration ?? _marketDuration;
    if (isAllEmpty(_assetName)) {
      return;
    }
    int now = getNowEpochSeconds();
    await loadMarketHistory(
        startTime:
            (now - 300 * marketDurationSecondMap[_marketDuration]).toString(),
        endTime: now.toString(),
        asset: _assetName,
        marketDuration: _marketDuration);
    initCommunication();
    send(jsonEncode(WebSocketRequestEntity(
            type: "subscribe", topic: "FAIRPRICE.$_assetName"))
        .toString());
  }

  loadMarketHistory(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration marketDuration}) async {
    List<MarketHistoryResponseModel> _list = await _api.getMarketHistory(
        startTime: startTime,
        endTime: endTime,
        asset: asset,
        duration: marketDuration);
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

  cleanData() {
    if (!isAllEmpty(_priceController.value)) {
      _priceController.value.clear();
    }
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
