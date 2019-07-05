import 'dart:convert';

import 'package:cybex_flutter_plugin/commision.dart';

class PostWithdrawRequestModel {
  String transactionType;
  Commission transfer;
  String memo;

  PostWithdrawRequestModel({this.transactionType, this.transfer, this.memo});

  factory PostWithdrawRequestModel.fromRawJson(String str) =>
      PostWithdrawRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostWithdrawRequestModel.fromJson(Map<String, dynamic> json) =>
      new PostWithdrawRequestModel(
        transactionType: json["transactionType"],
        transfer: Commission.fromJson(json["transfer"]),
        memo: json["memo"],
      );

  Map<String, dynamic> toJson() => {
        "transactionType": transactionType,
        "transfer": transfer.toJson(),
      };
  Map<String, dynamic> toWithdrawJson() => {
        "transactionType": transactionType,
        "transfer": transfer.toJson(),
        "memo": memo
      };
}
