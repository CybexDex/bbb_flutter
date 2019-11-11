import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class AstrologyHeaderResult {
  Result result;
  bool success;

  AstrologyHeaderResult({
    this.result,
    this.success,
  });

  factory AstrologyHeaderResult.fromJson(jsonRes) => jsonRes == null
      ? null
      : AstrologyHeaderResult(
          result: Result.fromJson(jsonRes['result']),
          success: convertValueByType(jsonRes['success'], bool,
              stack: "Root-success"),
        );

  Map<String, dynamic> toJson() => {
        'result': result,
        'success': success,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Result {
  String content;
  String headerImage;
  int updated;

  Result({
    this.content,
    this.headerImage,
    this.updated,
  });

  factory Result.fromJson(jsonRes) => jsonRes == null
      ? null
      : Result(
          content: convertValueByType(jsonRes['content'], String,
              stack: "Result-content"),
          headerImage: convertValueByType(jsonRes['header_image'], String,
              stack: "Result-header_image"),
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Result-updated"),
        );

  Map<String, dynamic> toJson() => {
        'content': content,
        'header_image': headerImage,
        'updated': updated,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
