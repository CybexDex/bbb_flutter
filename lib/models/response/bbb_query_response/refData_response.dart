import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RefDataResponse {
  String actionName;
  String adminAccountId;
  String gatewayAccountId;
  String cybexAssetId;
  int cybexAssetPrecision;
  String bbbAssetId;
  int bbbAssetPrecision;
  String chainId;
  String blockId;
  int blockNum;
  int expiration;

  RefDataResponse({
    this.actionName,
    this.adminAccountId,
    this.gatewayAccountId,
    this.cybexAssetId,
    this.cybexAssetPrecision,
    this.bbbAssetId,
    this.bbbAssetPrecision,
    this.chainId,
    this.blockId,
    this.blockNum,
    this.expiration,
  });

  factory RefDataResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : RefDataResponse(
          actionName: convertValueByType(jsonRes['action_name'], String,
              stack: "Root-action_name"),
          adminAccountId: convertValueByType(
              jsonRes['admin_account_id'], String,
              stack: "Root-admin_account_id"),
          gatewayAccountId: convertValueByType(
              jsonRes['gateway_account_id'], String,
              stack: "Root-gateway_account_id"),
          cybexAssetId: convertValueByType(jsonRes['cybex_asset_id'], String,
              stack: "Root-cybex_asset_id"),
          cybexAssetPrecision: convertValueByType(
              jsonRes['cybex_asset_precision'], int,
              stack: "Root-cybex_asset_precision"),
          bbbAssetId: convertValueByType(jsonRes['bbb_asset_id'], String,
              stack: "Root-bbb_asset_id"),
          bbbAssetPrecision: convertValueByType(
              jsonRes['bbb_asset_precision'], int,
              stack: "Root-bbb_asset_precision"),
          chainId: convertValueByType(jsonRes['chain_id'], String,
              stack: "Root-chain_id"),
          blockId: convertValueByType(jsonRes['block_id'], String,
              stack: "Root-block_id"),
          blockNum: convertValueByType(jsonRes['block_num'], int,
              stack: "Root-block_num"),
          expiration: convertValueByType(jsonRes['expiration'], int,
              stack: "Root-expiration"),
        );

  Map<String, dynamic> toJson() => {
        'action_name': actionName,
        'admin_account_id': adminAccountId,
        'gateway_account_id': gatewayAccountId,
        'cybex_asset_id': cybexAssetId,
        'cybex_asset_precision': cybexAssetPrecision,
        'bbb_asset_id': bbbAssetId,
        'bbb_asset_precision': bbbAssetPrecision,
        'chain_id': chainId,
        'block_id': blockId,
        'block_num': blockNum,
        'expiration': expiration,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
