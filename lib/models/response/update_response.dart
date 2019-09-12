import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class UpdateResponse {
  String version;
  String url;
  String cnUpdateInfo;
  String enUpdateInfo;
  dynamic force;

  UpdateResponse({
    this.version,
    this.url,
    this.cnUpdateInfo,
    this.enUpdateInfo,
    this.force,
  });

  factory UpdateResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : UpdateResponse(
          version: convertValueByType(jsonRes['version'], String,
              stack: "Root-version"),
          url: convertValueByType(jsonRes['url'], String, stack: "Root-url"),
          cnUpdateInfo: convertValueByType(jsonRes['cnUpdateInfo'], String,
              stack: "Root-cnUpdateInfo"),
          enUpdateInfo: convertValueByType(jsonRes['enUpdateInfo'], String,
              stack: "Root-enUpdateInfo"),
          force: jsonRes['force']);

  Map<String, dynamic> toJson() => {
        'version': version,
        'url': url,
        'cnUpdateInfo': cnUpdateInfo,
        'enUpdateInfo': enUpdateInfo,
        'force': force,
      };
  @override
  String toString() {
    return json.encode(this);
  }

  bool isForceUpdate(String currVersion) {
    var element = force[currVersion];
    return element != null && convertValueByType(element, bool);
  }

  bool needUpdate(String currVersion) {
    return int.tryParse(version.replaceAll(".", "")) >
        int.tryParse(currVersion.replaceAll(".", ""));
  }
}
