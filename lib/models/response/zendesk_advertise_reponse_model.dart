import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ZendeskAdvertiseResponse {
  int count;
  List<Articles> articles;

  ZendeskAdvertiseResponse({
    this.count,
    this.articles,
  });

  factory ZendeskAdvertiseResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Articles> articles = jsonRes['articles'] is List ? [] : null;
    if (articles != null) {
      for (var item in jsonRes['articles']) {
        if (item != null) {
          articles.add(Articles.fromJson(item));
        }
      }
    }
    return ZendeskAdvertiseResponse(
      count: convertValueByType(jsonRes['count'], int, stack: "Root-count"),
      articles: articles,
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'articles': articles,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Articles {
  int id;
  String htmlUrl;
  String name;

  Articles({
    this.id,
    this.htmlUrl,
    this.name,
  });

  factory Articles.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    return Articles(
      id: convertValueByType(jsonRes['id'], int, stack: "Articles-id"),
      htmlUrl: convertValueByType(jsonRes['html_url'], String,
          stack: "Articles-html_url"),
      name: convertValueByType(jsonRes['name'], String, stack: "Articles-name"),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'html_url': htmlUrl,
        'name': name,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
