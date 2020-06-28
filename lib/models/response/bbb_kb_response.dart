import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class BBBKBResponse {
  String link;
  Title title;

  BBBKBResponse({
    this.link,
    this.title,
  });

  factory BBBKBResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;
    return BBBKBResponse(
      link: convertValueByType(jsonRes['link'], String, stack: "Root-link"),
      title: Title.fromJson(jsonRes['title']),
    );
  }

  Map<String, dynamic> toJson() => {
        'link': link,
        'title': title,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Title {
  String rendered;

  Title({
    this.rendered,
  });

  factory Title.fromJson(jsonRes) => jsonRes == null
      ? null
      : Title(
          rendered: convertValueByType(jsonRes['rendered'], String, stack: "Title-rendered"),
        );

  Map<String, dynamic> toJson() => {
        'rendered': rendered,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
