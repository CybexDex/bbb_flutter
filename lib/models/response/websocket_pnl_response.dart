import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class WebSocketPNLResponse {
  String topic;
  String accountName;
  double pnl;
  String contract;

  WebSocketPNLResponse({
    this.topic,
    this.accountName,
    this.pnl,
    this.contract,
  });

  factory WebSocketPNLResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : WebSocketPNLResponse(
          topic: convertValueByType(jsonRes['topic'], String, stack: "Root-topic"),
          accountName:
              convertValueByType(jsonRes['accountName'], String, stack: "Root-accountName"),
          pnl: convertValueByType(jsonRes['pnl'], double, stack: "Root-pnl"),
          contract: convertValueByType(jsonRes['contract'], String, stack: "Root-contract"),
        );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'accountName': accountName,
        'pnl': pnl,
        'contract': contract,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
