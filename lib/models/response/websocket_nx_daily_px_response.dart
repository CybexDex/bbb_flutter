import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class WebSocketNXDailyPxResponse {
  String topic;
  double lastDayPx;
  double highPx;
  double lowPx;

  WebSocketNXDailyPxResponse({
    this.topic,
    this.lastDayPx,
    this.highPx,
    this.lowPx,
  });

  factory WebSocketNXDailyPxResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : WebSocketNXDailyPxResponse(
          topic: convertValueByType(jsonRes['topic'], String, stack: "Root-topic"),
          lastDayPx: convertValueByType(jsonRes['last_day_px'], double, stack: "Root-last_day_px"),
          highPx: convertValueByType(jsonRes['high_px'], double, stack: "Root-high_px"),
          lowPx: convertValueByType(jsonRes['low_px'], double, stack: "Root-low_px"),
        );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'last_day_px': lastDayPx,
        'high_px': highPx,
        'low_px': lowPx,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
