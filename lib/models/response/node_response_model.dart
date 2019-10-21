import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/response/node_top_list_response_model.dart';

class NodeResponose<T> {
  int id;
  String jsonrpc;
  List<T> result;

  NodeResponose({
    this.id,
    this.jsonrpc,
    this.result,
  });

  factory NodeResponose.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<T> result = jsonRes['result'] is List ? [] : null;
    if (result != null) {
      for (var item in jsonRes['result']) {
        if (item != null) {
          if (T == NodeTopListResponse) {
            item = NodeTopListResponse.fromJson(item);
          }
          result.add(item);
        }
      }
    }
    return NodeResponose(
      id: convertValueByType(jsonRes['id'], int, stack: "Root-id"),
      jsonrpc:
          convertValueByType(jsonRes['jsonrpc'], String, stack: "Root-jsonrpc"),
      result: result,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jsonrpc': jsonrpc,
        'result': result,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
