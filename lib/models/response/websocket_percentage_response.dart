import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class WebSocketPercentageResponse {
  String topic;
  double nPercentage;
  double xPercentage;

  WebSocketPercentageResponse({
    this.topic,
    this.nPercentage,
    this.xPercentage,
  });

  factory WebSocketPercentageResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : WebSocketPercentageResponse(
          topic: convertValueByType(jsonRes['topic'], String, stack: "Root-topic"),
          nPercentage:
              convertValueByType(jsonRes['nPercentage'], double, stack: "Root-nPercentage"),
          xPercentage:
              convertValueByType(jsonRes['xPercentage'], double, stack: "Root-xPercentage"),
        );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'nPercentage': nPercentage,
        'xPercentage': xPercentage,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
