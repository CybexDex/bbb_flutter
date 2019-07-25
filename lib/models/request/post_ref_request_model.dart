import 'dart:convert';

import 'package:bbb_flutter/helper/utils.dart';

class PostRefRequestModel {
  String action;
  int expiration;
  String referrer;
  String account;
  String signature;

  PostRefRequestModel({
    this.action,
    this.expiration,
    this.referrer,
    this.account,
    this.signature,
  });

  factory PostRefRequestModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : PostRefRequestModel(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Root-action"),
          expiration: convertValueByType(jsonRes['expiration'], int,
              stack: "Root-expiration"),
          referrer: convertValueByType(jsonRes['referrer'], String,
              stack: "Root-referrer"),
          account: convertValueByType(jsonRes['account'], String,
              stack: "Root-account"),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'expiration': expiration,
        'referrer': referrer,
        'account': account,
        'signature': signature,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
