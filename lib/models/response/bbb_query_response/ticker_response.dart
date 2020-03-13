import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class TickerResponse {
  double lastDayPx;
  double highest;
  double lowest;
  String latest;

  TickerResponse({
    this.lastDayPx,
    this.highest,
    this.lowest,
    this.latest,
  });

  factory TickerResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : TickerResponse(
          lastDayPx: convertValueByType(jsonRes['last_day_px'], double,
              stack: "Root-last_day_px"),
          highest: convertValueByType(jsonRes['highest'], double,
              stack: "Root-highest"),
          lowest: convertValueByType(jsonRes['lowest'], double,
              stack: "Root-lowest"),
          latest: convertValueByType(jsonRes['latest'], String,
              stack: "Root-latest"),
        );

  Map<String, dynamic> toJson() => {
        'last_day_px': lastDayPx,
        'highest': highest,
        'lowest': lowest,
        'latest': latest,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
