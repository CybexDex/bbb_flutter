import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

const String _SERVER_ADDRESS = "wss://nxmdptest.cybex.io/";

class WebSocketBloc {
  static final WebSocketBloc _webSocketBloc = new WebSocketBloc._internal();

  factory WebSocketBloc() {
    return _webSocketBloc;
  }

  WebSocketBloc._internal();

  IOWebSocketChannel _channel;

  bool _isOn = false;

  ObserverList<Function> _observerList = new ObserverList<Function>();

  initCommunication() async {
    try {
      _channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);
    } catch (e) {}
  }

  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
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

  Stream getChannelStream() {
    return _channel.stream;
  }
}
