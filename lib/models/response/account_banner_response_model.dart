import 'dart:convert';
import 'package:bbb_flutter/helper/utils.dart';

class BannerResponse {
  String image;
  String sequence;
  String name;
  int updated;
  int created;
  String link;
  String needUserName;

  BannerResponse(
      {this.image,
      this.sequence,
      this.name,
      this.updated,
      this.created,
      this.link,
      this.needUserName});

  factory BannerResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : BannerResponse(
          image: convertValueByType(jsonRes['image'], String, stack: "Root-image"),
          sequence: convertValueByType(jsonRes['sequence'], String, stack: "Root-sequence"),
          name: convertValueByType(jsonRes['name'], String, stack: "Root-name"),
          updated: convertValueByType(jsonRes['updated'], int, stack: "Root-updated"),
          created: convertValueByType(jsonRes['created'], int, stack: "Root-created"),
          link: convertValueByType(jsonRes['link'], String, stack: "Root-link"),
          needUserName: convertValueByType(jsonRes['need_user_name'], String, stack: "Root-link"));

  Map<String, dynamic> toJson() => {
        'image': image,
        'sequence': sequence,
        'name': name,
        'updated': updated,
        'created': created,
        'link': link,
        'need_user_name': needUserName
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
