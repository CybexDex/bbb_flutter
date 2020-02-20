import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ActionResponse {
  List<Action> action;

  ActionResponse({
    this.action,
  });

  factory ActionResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Action> action = jsonRes['action'] is List ? [] : null;
    if (action != null) {
      for (var item in jsonRes['action']) {
        if (item != null) {
          action.add(Action.fromJson(item));
        }
      }
    }
    return ActionResponse(
      action: action,
    );
  }

  Map<String, dynamic> toJson() => {
        'action': action,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Action {
  int id;
  String name;
  String description;
  String start;
  String stop;
  int needHedge;
  int isActive;

  Action({
    this.id,
    this.name,
    this.description,
    this.start,
    this.stop,
    this.needHedge,
    this.isActive,
  });

  factory Action.fromJson(jsonRes) => jsonRes == null
      ? null
      : Action(
          id: convertValueByType(jsonRes['id'], int, stack: "Action-id"),
          name:
              convertValueByType(jsonRes['name'], String, stack: "Action-name"),
          description: convertValueByType(jsonRes['description'], String,
              stack: "Action-description"),
          start: convertValueByType(jsonRes['start'], String,
              stack: "Action-start"),
          stop:
              convertValueByType(jsonRes['stop'], String, stack: "Action-stop"),
          needHedge: convertValueByType(jsonRes['need_hedge'], int,
              stack: "Action-need_hedge"),
          isActive: convertValueByType(jsonRes['is_active'], int,
              stack: "Action-is_active"),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'start': start,
        'stop': stop,
        'need_hedge': needHedge,
        'is_active': isActive,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
