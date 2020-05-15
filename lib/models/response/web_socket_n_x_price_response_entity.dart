import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class WebSocketNXPriceResponseEntity {
  String topic;
  double px;
  String sym;
  String time;

  WebSocketNXPriceResponseEntity({
    this.topic,
    this.px,
    this.sym,
    this.time,
  });

  factory WebSocketNXPriceResponseEntity.fromJson(jsonRes) => jsonRes == null
      ? null
      : WebSocketNXPriceResponseEntity(
          topic: convertValueByType(jsonRes['topic'], String, stack: "Root-topic"),
          px: convertValueByType(jsonRes['px'], double, stack: "Root-px"),
          sym: convertValueByType(jsonRes['sym'], String, stack: "Root-sym"),
          time: convertValueByType(jsonRes['time'], String, stack: "Root-time"),
        );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'px': px,
        'sym': sym,
        'time': time,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
