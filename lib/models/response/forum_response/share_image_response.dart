import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ShareImageResponse {
  int updated;
  int created;
  String url;

  ShareImageResponse({
    this.updated,
    this.created,
    this.url,
  });

  factory ShareImageResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : ShareImageResponse(
          updated: convertValueByType(jsonRes['updated'], int, stack: "Root-updated"),
          created: convertValueByType(jsonRes['created'], int, stack: "Root-created"),
          url: convertValueByType(jsonRes['url'], String, stack: "Root-url"),
        );

  Map<String, dynamic> toJson() => {
        'updated': updated,
        'created': created,
        'url': url,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
