// To parse this JSON data, do
//
//     final postOrderResponseModel = postOrderResponseModelFromJson(jsonString);

import 'dart:convert';

class PostOrderResponseModel {
  String status;
  String reason;
  String details;
  String txId;
  DateTime time;

  PostOrderResponseModel({
    this.status,
    this.reason,
    this.details,
    this.txId,
    this.time,
  });

  factory PostOrderResponseModel.fromRawJson(String str) =>
      PostOrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      new PostOrderResponseModel(
        status: json["Status"],
        reason: json["reason"],
        details: json["details"],
        txId: json["txId"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "reason": reason,
        "details": details,
        "txId": txId,
        "time": time.toIso8601String(),
      };
}
