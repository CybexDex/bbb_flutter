import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class NodeTopListResponse {
  String from;
  String to;
  String symbol;
  int totalCount;
  String amount;

  NodeTopListResponse({
    this.from,
    this.to,
    this.symbol,
    this.totalCount,
    this.amount,
  });

  factory NodeTopListResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : NodeTopListResponse(
          from: convertValueByType(jsonRes['from'], String, stack: "Root-from"),
          to: convertValueByType(jsonRes['to'], String, stack: "Root-to"),
          symbol: convertValueByType(jsonRes['symbol'], String,
              stack: "Root-asset"),
          totalCount: convertValueByType(jsonRes['total_count'], int,
              stack: "Root-total_count"),
          amount: convertValueByType(jsonRes['amount'], String,
              stack: "Root-total_amount"),
        );

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'symbol': symbol,
        'total_count': totalCount,
        'amount': amount,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
