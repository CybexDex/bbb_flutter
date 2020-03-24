import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/models/response/websocket_nx_daily_px_response.dart';
import 'package:bbb_flutter/models/response/websocket_nx_k_line_response_entity.dart';
import 'package:bbb_flutter/models/response/websocket_percentage_response.dart';
import 'package:bbb_flutter/models/response/websocket_pnl_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/k_line/entity/k_line_entity.dart';
import 'package:bbb_flutter/widgets/k_line/utils/data_util.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class MarketManager {
  Stream<List<TickerData>> get prices => _priceController.stream;
  Stream<List<KLineEntity>> get kline => _kLine.stream;
  BehaviorSubject<TickerData> lastTicker = BehaviorSubject<TickerData>();
  BehaviorSubject<WebSocketPercentageResponse> percentageTicker =
      BehaviorSubject<WebSocketPercentageResponse>();
  BehaviorSubject<WebSocketPNLResponse> pnlTicker =
      BehaviorSubject<WebSocketPNLResponse>();
  BehaviorSubject<List<TickerData>> _priceController =
      BehaviorSubject<List<TickerData>>();
  BehaviorSubject<List<KLineEntity>> _kLine =
      BehaviorSubject<List<KLineEntity>>();
  BehaviorSubject<WebSocketNXDailyPxResponse> dailyPxTicker =
      BehaviorSubject<WebSocketNXDailyPxResponse>();
  IOWebSocketChannel _channel;
  bool isClosedManually = false;

  BBBAPI _api;
  SharedPref _sharedPref;

  MarketManager({BBBAPI api, SharedPref sharedPref})
      : _api = api,
        _sharedPref = sharedPref;

  String _assetName;
  MarketDuration _marketDuration = MarketDuration.line;

  loadAllData(String assetName,
      {MarketDuration marketDuration, int time}) async {
    _assetName = assetName ?? _assetName;
    _marketDuration = marketDuration ?? _marketDuration;
    if (isAllEmpty(_assetName)) {
      return;
    }
    int now = getNowEpochSeconds();
    await loadMarketHistory(
        startTime:
            (now - 300 * marketDurationSecondMap[_marketDuration]).toString(),
        endTime: time != null ? time.toString() : now.toString(),
        asset: _assetName,
        marketDuration: _marketDuration);
    initCommunication();
    send(jsonEncode(WebSocketRequestEntity(
        type: "subscribe",
        topic:
            "${WebsocketRequestTopic.NX_PERCENTAGE}.${_sharedPref.getAction()}")));
    send(jsonEncode(WebSocketRequestEntity(
        topic: "${WebsocketRequestTopic.PNL}.${_sharedPref.getAction()}",
        type: "subscribe")));
    send(jsonEncode(WebSocketRequestEntity(
        topic: WebsocketRequestTopic.NX_DAILYPX, type: "subscribe")));
    send(jsonEncode(WebSocketRequestEntity(
        type: "subscribe", topic: "FAIRPRICE.$_assetName")));
    if (_marketDuration != MarketDuration.line) {
      send(jsonEncode(WebSocketRequestEntity(
          topic:
              "${WebsocketRequestTopic.NX_KLINE}.${marketDurationSecondMap[_marketDuration]}",
          type: "subscribe")));
    }
  }

  loadMarketHistory(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration marketDuration}) async {
    if (marketDuration == MarketDuration.line) {
      List<MarketHistoryResponseModel> _list = await _api.getMarketHistory(
          startTime: startTime, endTime: endTime, duration: marketDuration);
      List<TickerData> data = _list.map((marketHistoryResponseModel) {
        var tickerData = TickerData(
            marketHistoryResponseModel.px,
            DateTime.fromMicrosecondsSinceEpoch(
                marketHistoryResponseModel.xts));
        return tickerData;
      }).toList();
      _priceController.add(data);
      if (data.isNotEmpty) {
        lastTicker.add(data.last);
      }
    } else {
      List<KLineEntity> list = await _api.getMarketHistoryCandle(
          startTime: startTime, endTime: endTime, duration: marketDuration);
      DataUtil.calculate(list);
      _kLine.add(list);
    }
  }

  initCommunication() {
    reset();
    if (_sharedPref.getEnvType() == EnvType.Pro) {
      _channel = IOWebSocketChannel.connect(
          "${WebSocketConnection.PRO_WEBSOCKET}/api/${_sharedPref.getAsset()}/mdp");
    } else if (_sharedPref.getEnvType() == EnvType.Test) {
      _channel = IOWebSocketChannel.connect(
          "${WebSocketConnection.TEST_WEBSOCKET}/api/${_sharedPref.getAsset()}/mdp");
    } else if (_sharedPref.getEnvType() == EnvType.Dev) {
      _channel = IOWebSocketChannel.connect(
          "${WebSocketConnection.DEV_WEBSOCKET}/api/${_sharedPref.getAsset()}/mdp");
    }

    // _channel = _sharedPref.getEnvType() == EnvType.Pro
    //     ? IOWebSocketChannel.connect(
    //         _sharedPref.getTestNet()
    //             ? WebSocketConnection.PRO_TEST_WEBSOCKET
    //             : WebSocketConnection.PRO_WEBSOCKET,
    //       )
    //     : IOWebSocketChannel.connect(_sharedPref.getTestNet()
    //         ? WebSocketConnection.UAT_TEST_WEBSOCKET
    //         : WebSocketConnection.TEST_WEBSOCKET);
    _channel.stream.listen((onData) {
      dispatchMessage(onData);
    }, onError: (error) {
      cancelAndRemoveData();
      loadAllData(_assetName);
    }, onDone: () {
      if (isClosedManually) {
        print("onDoneManually");
      } else {
        print("onDone");
        loadAllData(_assetName);
      }
    });
  }

  dispatchMessage(String response) async {
    if (response.contains(WebsocketRequestTopic.FAIRPRICE)) {
      var wbResponse =
          WebSocketNXPriceResponseEntity.fromJson(json.decode(response));
      var tTime = DateTime.parse(wbResponse.time);

      var t = TickerData(wbResponse.px, tTime);

      lastTicker.add(t);
      if (isAllEmpty(_priceController.value)) {
        _priceController.value.add(t);
        _priceController.add(_priceController.value.toList());
        return;
      }

      var phase = (_priceController.value.last.time.millisecondsSinceEpoch -
              t.time.millisecondsSinceEpoch)
          .abs();
      if (phase < 60 * 1000) {
        t.time = _priceController.value.last.time;
        _priceController.value.removeLast();
        _priceController.value.add(t);
        _priceController.add(_priceController.value.toList());
      } else {
        _priceController.value.add(t);
        if (_priceController.value.length >= 500) {
          _priceController.value.removeRange(0, 200);
        }
        _priceController.add(_priceController.value.toList());
      }
    } else if (response.contains(WebsocketRequestTopic.NX_KLINE)) {
      var kLineResponse =
          WebsocketNxKLineResponseEntity.fromJson(json.decode(response));
      var kLineEntity = KLineEntity.fromCustom(
          open: kLineResponse.open,
          high: kLineResponse.high,
          low: kLineResponse.low,
          close: kLineResponse.close,
          vol: 10000,
          id: kLineResponse.start);
      if (isAllEmpty(_kLine.value)) {
        _kLine.value.add(kLineEntity);
        _kLine.add(_kLine.value.toList());
        return;
      }
      var diff = (_kLine.value.last.id - kLineResponse.start).abs();
      if (diff < kLineResponse.interval) {
        _kLine.value.last = kLineEntity;
        DataUtil.updateLastData(_kLine.value);
        _kLine.add(_kLine.value.toList());
      } else {
        DataUtil.addLastData(_kLine.value, kLineEntity);
        _kLine.add(_kLine.value.toList());
      }
    } else if (response.contains(WebsocketRequestTopic.NX_PERCENTAGE)) {
      var percentageResponse =
          WebSocketPercentageResponse.fromJson(json.decode(response));
      percentageTicker.add(percentageResponse);
    } else if (response.contains(WebsocketRequestTopic.PNL)) {
      var pnlResponse = WebSocketPNLResponse.fromJson(json.decode(response));
      pnlTicker.add(pnlResponse);
    } else if (response.contains(WebsocketRequestTopic.NX_DAILYPX)) {
      var nxDailyResponse =
          WebSocketNXDailyPxResponse.fromJson(json.decode(response));
      dailyPxTicker.add(nxDailyResponse);
    }
  }

  cancelAndRemoveData() {
    reset();
  }

  cleanData() {
    if (!isAllEmpty(_priceController.value)) {
      _priceController.value.clear();
    }
    if (!isAllEmpty(_kLine.value)) {
      _kLine.value.clear();
    }
  }

  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        isClosedManually = true;
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
