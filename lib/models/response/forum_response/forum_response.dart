import 'dart:convert';

import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/assets_list.dart';
import 'package:bbb_flutter/models/response/forum_response/astrology_result.dart';
import 'package:bbb_flutter/models/response/forum_response/bolockchain_vip_result.dart';
import 'package:bbb_flutter/models/response/forum_response/news_result.dart';
import 'package:bbb_flutter/models/response/forum_response/url_config_response.dart';

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
          } else if (T == BannerResponse) {
            item = BannerResponse.fromJson(item);
          } else if (T == AssetList) {
            item = AssetList.fromJson(item);
          } else if (T == UrlConfigResponse) {
            item = UrlConfigResponse.fromJson(item);
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
