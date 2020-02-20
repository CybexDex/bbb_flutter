import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RankingResponse {
  String user;
  double pnlRatio;

  RankingResponse({
    this.user,
    this.pnlRatio,
  });

  factory RankingResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : RankingResponse(
          user: convertValueByType(jsonRes['user'], String, stack: "Root-name"),
          pnlRatio: convertValueByType(jsonRes['pnl_ratio'], double,
              stack: "Root-pnl_ratio"),
        );

  Map<String, dynamic> toJson() => {
        'user': user,
        'pnl_ratio': pnlRatio,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
