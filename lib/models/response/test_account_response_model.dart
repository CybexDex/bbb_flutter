import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class TestAccountResponseModel {
  String accountName;
  String accountId;
  String privateKey;
  String publicKey;

  TestAccountResponseModel({
    this.accountName,
    this.accountId,
    this.privateKey,
    this.publicKey,
  });

  factory TestAccountResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : TestAccountResponseModel(
          accountName: convertValueByType(jsonRes['accountName'], String,
              stack: "TestAccountResponseModel-accountName"),
          accountId: convertValueByType(jsonRes['accountId'], String,
              stack: "TestAccountResponseModel-accountId"),
          privateKey: convertValueByType(jsonRes['privateKey'], String,
              stack: "TestAccountResponseModel-privateKey"),
          publicKey: convertValueByType(jsonRes['publicKey'], String,
              stack: "TestAccountResponseModel-publicKey"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'accountId': accountId,
        'privateKey': privateKey,
        'publicKey': publicKey,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
