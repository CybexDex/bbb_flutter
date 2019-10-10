import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ActivitiesResponse {
  String name;
  int showstaus;
  bool enable;
  String image;
  String url;
  String comment;

  ActivitiesResponse({
    this.name,
    this.showstaus,
    this.enable,
    this.image,
    this.url,
    this.comment,
  });

  factory ActivitiesResponse.fromRawJson(String str) =>
      ActivitiesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActivitiesResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : ActivitiesResponse(
          name: convertValueByType(jsonRes['name'], String, stack: "Root-name"),
          showstaus: convertValueByType(jsonRes['showstaus'], int,
              stack: "Root-showstaus"),
          enable:
              convertValueByType(jsonRes['enable'], bool, stack: "Root-enable"),
          image:
              convertValueByType(jsonRes['image'], String, stack: "Root-image"),
          url: convertValueByType(jsonRes['url'], String, stack: "Root-url"),
          comment: convertValueByType(jsonRes['comment'], String,
              stack: "Root-comment"),
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'showstaus': showstaus,
        'enable': enable,
        'image': image,
        'url': url,
        'comment': comment,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
