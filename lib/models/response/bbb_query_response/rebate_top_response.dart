import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RebateTopResponse {
  String user;
  double total;

  RebateTopResponse({
    this.user,
    this.total,
  });

  factory RebateTopResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : RebateTopResponse(
          user: convertValueByType(jsonRes['user'], String, stack: "Root-user"),
          total: convertValueByType(jsonRes['total'], double, stack: "Root-total"),
        );

  Map<String, dynamic> toJson() => {
        'user': user,
        'total': total,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
