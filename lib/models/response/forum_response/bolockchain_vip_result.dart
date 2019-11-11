import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class BlockchainVip {
  int created;
  String link;
  String title;
  int updated;
  String author;
  String preview;
  String image;

  BlockchainVip({
    this.created,
    this.link,
    this.title,
    this.updated,
    this.author,
    this.preview,
    this.image,
  });

  factory BlockchainVip.fromJson(jsonRes) => jsonRes == null
      ? null
      : BlockchainVip(
          created: convertValueByType(jsonRes['created'], int,
              stack: "Root-created"),
          link: convertValueByType(jsonRes['link'], String, stack: "Root-link"),
          title:
              convertValueByType(jsonRes['title'], String, stack: "Root-title"),
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Root-updated"),
          author: convertValueByType(jsonRes['author'], String,
              stack: "Root-author"),
          preview: convertValueByType(jsonRes['preview'], String,
              stack: "Root-preview"),
          image:
              convertValueByType(jsonRes['image'], String, stack: "Root-image"),
        );

  Map<String, dynamic> toJson() => {
        'created': created,
        'link': link,
        'title': title,
        'updated': updated,
        'author': author,
        'preview': preview,
        'image': image,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
