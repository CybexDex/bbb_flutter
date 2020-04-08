import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class OpenRewardRequestModel {
  Data data;
  String signature;

  OpenRewardRequestModel({
    this.data,
    this.signature,
  });

  factory OpenRewardRequestModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : OpenRewardRequestModel(
          data: Data.fromJson(jsonRes['data']),
          signature: convertValueByType(jsonRes['signature'], String, stack: "Root-signature"),
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
  String contract;
  String takeProfitPrice;
  String cutlossPrice;
  int quantity;
  int couponId;
  int timeout;

  Data({
    this.action,
    this.user,
    this.contract,
    this.takeProfitPrice,
    this.cutlossPrice,
    this.quantity,
    this.couponId,
    this.timeout,
  });

  factory Data.fromJson(jsonRes) => jsonRes == null
      ? null
      : Data(
          action: convertValueByType(jsonRes['action'], String, stack: "Data-action"),
          user: convertValueByType(jsonRes['user'], String, stack: "Data-user"),
          contract: convertValueByType(jsonRes['contract'], String, stack: "Data-contract"),
          takeProfitPrice: convertValueByType(jsonRes['take_profit_price'], String,
              stack: "Data-take_profit_price"),
          cutlossPrice:
              convertValueByType(jsonRes['cutloss_price'], String, stack: "Data-cutloss_price"),
          quantity: convertValueByType(jsonRes['quantity'], int, stack: "Data-quantity"),
          couponId: convertValueByType(jsonRes['coupon_id'], int, stack: "Data-couponId"),
          timeout: convertValueByType(jsonRes['timeout'], int, stack: "Data-timeout"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'user': user,
        'contract': contract,
        'take_profit_price': takeProfitPrice,
        'cutloss_price': cutlossPrice,
        'coupon_id': couponId,
        'quantity': quantity,
        'timeout': timeout,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
