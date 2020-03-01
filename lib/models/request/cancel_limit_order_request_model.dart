import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class CancelLimitOrderRequest {
  Data data;
  String signature;

  CancelLimitOrderRequest({
    this.data,
    this.signature,
  });

  factory CancelLimitOrderRequest.fromJson(jsonRes) => jsonRes == null
      ? null
      : CancelLimitOrderRequest(
          data: Data.fromJson(jsonRes['data']),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'data': data,
        'signature': signature,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  String action;
  String user;
  int orderId;
  int timeout;

  Data({
    this.action,
    this.user,
    this.orderId,
    this.timeout,
  });

  factory Data.fromJson(jsonRes) => jsonRes == null
      ? null
      : Data(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Data-action"),
          user: convertValueByType(jsonRes['user'], String, stack: "Data-user"),
          orderId: convertValueByType(jsonRes['order_id'], int,
              stack: "Data-order_id"),
          timeout: convertValueByType(jsonRes['timeout'], int,
              stack: "Data-timeout"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'user': user,
        'order_id': orderId,
        'timeout': timeout,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
