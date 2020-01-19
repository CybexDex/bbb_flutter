import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class WebsocketNxKLineResponseEntity {
  int start;
  int interval;
  double open;
  double close;
  double high;
  double low;
  String topic;

  WebsocketNxKLineResponseEntity(
      {this.start,
      this.interval,
      this.open,
      this.close,
      this.high,
      this.low,
      this.topic});

  factory WebsocketNxKLineResponseEntity.fromJson(jsonRes) => jsonRes == null
      ? null
      : WebsocketNxKLineResponseEntity(
          start: convertValueByType(jsonRes['start'], int, stack: "Root-start"),
          interval: convertValueByType(jsonRes['interval'], int,
              stack: "Root-interval"),
          open: convertValueByType(jsonRes['open'], double, stack: "Root-open"),
          close:
              convertValueByType(jsonRes['close'], double, stack: "Root-close"),
          high: convertValueByType(jsonRes['high'], double, stack: "Root-high"),
          low: convertValueByType(jsonRes['low'], double, stack: "Root-low"),
          topic: convertValueByType(jsonRes['topic'], String,
              stack: "Root-topic"));

  Map<String, dynamic> toJson() => {
        'start': start,
        'interval': interval,
        'open': open,
        'close': close,
        'high': high,
        'low': low,
        'topic': topic
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
