import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class NewsResult {
  String from;
  String title;
  int created;
  int updated;
  String content;
  bool showAllText = false;
  bool showEllipse = true;

  NewsResult({
    this.from,
    this.title,
    this.created,
    this.updated,
    this.content,
  });

  factory NewsResult.fromJson(jsonRes) => jsonRes == null
      ? null
      : NewsResult(
          from: convertValueByType(jsonRes['from'], String, stack: "Root-from"),
          title:
              convertValueByType(jsonRes['title'], String, stack: "Root-title"),
          created: convertValueByType(jsonRes['created'], int,
              stack: "Root-created"),
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Root-updated"),
          content: convertValueByType(jsonRes['content'], String,
              stack: "Root-content"),
        );

  Map<String, dynamic> toJson() => {
        'from': from,
        'title': title,
        'created': created,
        'updated': updated,
        'content': content,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
