import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ConfigResponse {
  double maxGearing;
  double maxOrderQuantity;
  double dailyInterest;

  ConfigResponse({this.maxGearing, this.maxOrderQuantity, this.dailyInterest});

  factory ConfigResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : ConfigResponse(
          maxGearing: convertValueByType(jsonRes['max_gearing'], double,
              stack: "Root-max_gearing"),
          maxOrderQuantity: convertValueByType(
              jsonRes['max_order_quantity'], double,
              stack: "Root-max_order_quantity"),
          dailyInterest: convertValueByType(jsonRes["daily_interest"], double));

  Map<String, dynamic> toJson() => {
        'max_gearing': maxGearing,
        'max_order_quantity': maxOrderQuantity,
        'daily_interest': dailyInterest
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
