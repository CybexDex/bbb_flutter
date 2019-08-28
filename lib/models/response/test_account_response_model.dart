import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class TestAccountResponseModel {
  String accountName;
  String accountId;
  int accountType;
  String privateKey;
  String cybexAccount;
  int expiration;

  TestAccountResponseModel({
    this.accountName,
    this.accountId,
    this.accountType,
    this.privateKey,
    this.cybexAccount,
    this.expiration,
  });

  factory TestAccountResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : TestAccountResponseModel(
          accountName: convertValueByType(jsonRes['accountName'], String,
              stack: "Root-accountName"),
          accountId: convertValueByType(jsonRes['accountId'], String,
              stack: "Root-accountId"),
          accountType: convertValueByType(jsonRes['accountType'], int,
              stack: "Root-accountType"),
          privateKey: convertValueByType(jsonRes['privateKey'], String,
              stack: "Root-privateKey"),
          cybexAccount: convertValueByType(jsonRes['cybexAccount'], String,
              stack: "Root-cybexAccount"),
          expiration: convertValueByType(jsonRes['expiration'], int,
              stack: "Root-expiration"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'accountId': accountId,
        'accountType': accountType,
        'privateKey': privateKey,
        'cybexAccount': cybexAccount,
        'expiration': expiration,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
