import 'dart:convert';

import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/response/forum_response/astrology_result.dart';
import 'package:bbb_flutter/models/response/forum_response/bolockchain_vip_result.dart';
import 'package:bbb_flutter/models/response/forum_response/news_result.dart';

class ForumResponse<T> {
  List<T> result;
  bool success;

  ForumResponse({
    this.result,
    this.success,
  });

  factory ForumResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<T> result = jsonRes['result'] is List ? [] : null;
    if (result != null) {
      for (var item in jsonRes['result']) {
        if (item != null) {
          if (T == AstrologyResult) {
            item = AstrologyResult.fromJson(item);
          } else if (T == NewsResult) {
            item = NewsResult.fromJson(item);
          } else if (T == BlockchainVip) {
            item = BlockchainVip.fromJson(item);
          }
          result.add(item);
        }
      }
    }
    return ForumResponse(
      result: result,
      success:
          convertValueByType(jsonRes['success'], bool, stack: "Root-success"),
    );
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'success': success,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
