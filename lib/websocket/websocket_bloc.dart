import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/io.dart';

const String _SERVER_ADDRESS = "wss://nxmdptest.cybex.io/";

class WebSocketBloc {
  static final WebSocketBloc _webSocketBloc = new WebSocketBloc._internal();
  BehaviorSubject<WebSocketNXPriceResponseEntity> getNXPriceBloc =
      BehaviorSubject<WebSocketNXPriceResponseEntity>();

  factory WebSocketBloc() {
    return _webSocketBloc;
  }

  WebSocketBloc._internal();

  IOWebSocketChannel _channel;

  initCommunication() async {
    try {
      reset();

      _channel = IOWebSocketChannel.connect(_SERVER_ADDRESS);
      _channel.stream.listen((onData) {
        var wbResponse =
            WebSocketNXPriceResponseEntity.fromJson(json.decode(onData));
        getNXPriceBloc.add(wbResponse);
      });
    } catch (e) {}
    send(jsonEncode(
            WebSocketRequestEntity(type: "subscribe", topic: "FAIRPRICE.BXBT"))
        .toString());
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
