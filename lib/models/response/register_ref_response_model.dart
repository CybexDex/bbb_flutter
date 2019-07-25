import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RegisterRefResponseModel {
  bool success;
  String reason;

  RegisterRefResponseModel({
    this.success,
    this.reason,
  });

  factory RegisterRefResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : RegisterRefResponseModel(
          success: convertValueByType(jsonRes['success'], bool,
              stack: "Root-success"),
          reason: convertValueByType(jsonRes['reason'], String,
              stack: "Root-reason"),
        );

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': reason,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
