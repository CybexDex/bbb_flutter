import 'dart:convert';
import 'package:bbb_flutter/helper/utils.dart';

class BannerResponse {
  String name;
  String image;
  String link;

  BannerResponse({
    this.name,
    this.image,
    this.link,
  });

  factory BannerResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : BannerResponse(
          name: convertValueByType(jsonRes['name'], String, stack: "Root-name"),
          image:
              convertValueByType(jsonRes['image'], String, stack: "Root-image"),
          link: convertValueByType(jsonRes['link'], String, stack: "Root-link"),
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'link': link,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
