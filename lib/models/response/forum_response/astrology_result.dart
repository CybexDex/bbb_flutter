import 'dart:convert';

import 'package:bbb_flutter/helper/utils.dart';

class AstrologyResult {
  int created;
  String subtitle;
  String link;
  String title;
  int updated;
  String author;
  String image;

  AstrologyResult({
    this.created,
    this.subtitle,
    this.link,
    this.title,
    this.updated,
    this.author,
    this.image,
  });

  factory AstrologyResult.fromJson(jsonRes) => jsonRes == null
      ? null
      : AstrologyResult(
          created: convertValueByType(jsonRes['created'], int,
              stack: "Result-created"),
          subtitle: convertValueByType(jsonRes['subtitle'], String,
              stack: "Result-subtitle"),
          link:
              convertValueByType(jsonRes['link'], String, stack: "Result-link"),
          title: convertValueByType(jsonRes['title'], String,
              stack: "Result-title"),
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Result-updated"),
          author: convertValueByType(jsonRes['author'], String,
              stack: "Result-author"),
          image: convertValueByType(jsonRes['image'], String,
              stack: "Result-image"),
        );

  Map<String, dynamic> toJson() => {
        'created': created,
        'subtitle': subtitle,
        'link': link,
        'title': title,
        'updated': updated,
        'author': author,
        'image': image,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
