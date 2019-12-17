import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RankingResponse {
  String name;
  double pnlRatio;

  RankingResponse({
    this.name,
    this.pnlRatio,
  });

  factory RankingResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : RankingResponse(
          name: convertValueByType(jsonRes['name'], String, stack: "Root-name"),
          pnlRatio: convertValueByType(jsonRes['pnl_ratio'], double,
              stack: "Root-pnl_ratio"),
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'pnl_ratio': pnlRatio,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
