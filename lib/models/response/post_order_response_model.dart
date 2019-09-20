// To parse this JSON data, do
//
//     final postOrderResponseModel = postOrderResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:bbb_flutter/helper/error_code_translator.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/setup.dart';

class PostOrderResponseModel {
  String status;
  String message;
  double boughtContractPx;
  double boughtNotional;
  double boughtPx;
  String txId;
  DateTime time;
  int code;
  String errorMesage;

  PostOrderResponseModel(
      {this.status,
      this.message,
      this.boughtContractPx,
      this.boughtNotional,
      this.boughtPx,
      this.txId,
      this.time,
      this.code,
      this.errorMesage});

  factory PostOrderResponseModel.fromRawJson(String str) =>
      PostOrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostOrderResponseModel.fromJson(Map<String, dynamic> json) => json ==
          null
      ? null
      : new PostOrderResponseModel(
          status: convertValueByType(json["Status"], String),
          message: convertValueByType(json["Message"], String),
          boughtContractPx: convertValueByType(
              json.containsKey("boughtContractPx")
                  ? json["boughtContractPx"]
                  : null,
              double),
          boughtNotional: convertValueByType(
              json.containsKey("boughtNotional")
                  ? json["boughtNotional"]
                  : null,
              double),
          boughtPx: convertValueByType(
              json.containsKey("boughtPx") ? json["boughtPx"] : null, double),
          txId: convertValueByType(
              json.containsKey("txId") ? json["txId"] : null, String),
          time: convertValueByType(
              json.containsKey("time") ? DateTime.parse(json["time"]) : null,
              DateTime),
          code: convertValueByType(
              json.containsKey("Code") ? json["Code"] : null, int),
          errorMesage: translatePostOrderResponseErrorCode(
              code: json.containsKey("Code") ? json["Code"] : null,
              context: globalKey.currentContext));

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "boughtContractPx": boughtContractPx,
        "boughtNotional": boughtNotional,
        "boughtPx": boughtPx,
        "txId": txId,
        "time": time?.toIso8601String(),
        "Code": code,
        "errorMessage": errorMesage
      };
}
