import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class AstrologyPredictResponse {
  bool success;
  Result result;

  AstrologyPredictResponse({
    this.success,
    this.result,
  });

  factory AstrologyPredictResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : AstrologyPredictResponse(
          success: convertValueByType(jsonRes['success'], bool,
              stack: "Root-success"),
          result: Result.fromJson(jsonRes['result']),
        );

  Map<String, dynamic> toJson() => {
        'success': success,
        'result': result,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Result {
  String number1;
  int updated;
  String number2;

  Result({
    this.number1,
    this.updated,
    this.number2,
  });

  factory Result.fromJson(jsonRes) => jsonRes == null
      ? null
      : Result(
          number1: convertValueByType(jsonRes['number1'], String,
              stack: "Result-number1"),
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Result-updated"),
          number2: convertValueByType(jsonRes['number2'], String,
              stack: "Result-number2"),
        );

  Map<String, dynamic> toJson() => {
        'number1': number1,
        'updated': updated,
        'number2': number2,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
