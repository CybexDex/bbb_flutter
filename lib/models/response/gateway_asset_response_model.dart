import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class GatewayAssetResponseModel {
  int id;
  String createdAt;
  String updatedAt;
  Object deletedAt;
  String name;
  String blockchain;
  String cybname;
  String confirmation;
  String smartContract;
  String gatewayAccount;
  String withdrawPrefix;
  bool depositSwitch;
  bool withdrawSwitch;
  String minDeposit;
  double minWithdraw;
  String withdrawFee;
  String depositFee;
  String precision;
  String imgURL;
  String hashLink;
  Object info;

  GatewayAssetResponseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.blockchain,
    this.cybname,
    this.confirmation,
    this.smartContract,
    this.gatewayAccount,
    this.withdrawPrefix,
    this.depositSwitch,
    this.withdrawSwitch,
    this.minDeposit,
    this.minWithdraw,
    this.withdrawFee,
    this.depositFee,
    this.precision,
    this.imgURL,
    this.hashLink,
    this.info,
  });

  factory GatewayAssetResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : GatewayAssetResponseModel(
          id: jsonRes['ID'],
          createdAt: jsonRes['CreatedAt'],
          updatedAt: jsonRes['UpdatedAt'],
          deletedAt: jsonRes['DeletedAt'],
          name: jsonRes['name'],
          blockchain: jsonRes['blockchain'],
          cybname: jsonRes['cybname'],
          confirmation: jsonRes['confirmation'],
          smartContract: jsonRes['smartContract'],
          gatewayAccount: jsonRes['gatewayAccount'],
          withdrawPrefix: jsonRes['withdrawPrefix'],
          depositSwitch: jsonRes['depositSwitch'],
          withdrawSwitch: jsonRes['withdrawSwitch'],
          minDeposit: jsonRes['minDeposit'],
          minWithdraw: convertValueByType(jsonRes['minWithdraw'], double),
          withdrawFee: jsonRes['withdrawFee'],
          depositFee: jsonRes['depositFee'],
          precision: jsonRes['precision'],
          imgURL: jsonRes['imgURL'],
          hashLink: jsonRes['hashLink'],
          info: jsonRes['info'],
        );

  Map<String, dynamic> toJson() => {
        'ID': id,
        'CreatedAt': createdAt,
        'UpdatedAt': updatedAt,
        'DeletedAt': deletedAt,
        'name': name,
        'blockchain': blockchain,
        'cybname': cybname,
        'confirmation': confirmation,
        'smartContract': smartContract,
        'gatewayAccount': gatewayAccount,
        'withdrawPrefix': withdrawPrefix,
        'depositSwitch': depositSwitch,
        'withdrawSwitch': withdrawSwitch,
        'minDeposit': minDeposit,
        'minWithdraw': minWithdraw,
        'withdrawFee': withdrawFee,
        'depositFee': depositFee,
        'precision': precision,
        'imgURL': imgURL,
        'hashLink': hashLink,
        'info': info,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
