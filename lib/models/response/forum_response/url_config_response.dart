import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class UrlConfigResponse {
  int updated;
  String version;
  int created;
  String url;
  String mdp;

  UrlConfigResponse(
      {this.updated, this.version, this.created, this.url, this.mdp});

  factory UrlConfigResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : UrlConfigResponse(
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Root-updated"),
          version: convertValueByType(jsonRes['version'], String,
              stack: "Root-version"),
          created: convertValueByType(jsonRes['created'], int,
              stack: "Root-created"),
          url: convertValueByType(jsonRes['url'], String, stack: "Root-url"),
          mdp: convertValueByType(jsonRes['mdp'], String, stack: "Root-url"),
        );

  Map<String, dynamic> toJson() => {
        'updated': updated,
        'version': version,
        'created': created,
        'url': url,
        'mdp': mdp,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
