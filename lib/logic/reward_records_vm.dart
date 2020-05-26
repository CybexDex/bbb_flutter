import 'dart:collection';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;
import 'package:flutter/widgets.dart';

class RewardRecordsViewModel extends BaseModel {
  final BBBAPI _bbbapi;
  final UserManager _userManager;

  List<FundRecordModel> data = [];
  List<FundRecordModel> transferIn = [];
  List<FundRecordModel> transferOut = [];
  LinkedHashMap<int, List<FundRecordModel>> dataMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> transferInMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> transferOutMap = LinkedHashMap();
  List<String> typeList = [];
  List<custom.DropdownMenuItem<String>> dropdownList = [];
  String selectedItem;
  String rewardType;

  RewardRecordsViewModel(BBBAPI bbbapi, UserManager userManager)
      : _bbbapi = bbbapi,
        _userManager = userManager;

  getRecords({String dropdownType}) async {
    var name = _userManager.user.name;
    rewardType = _mapFromDropdownToType(dropdownType);
    _bbbapi
        .getFundRecords(
      name: name,
      subType: "airdrop",
      start: DateTime.now().toUtc().subtract(Duration(days: 30)),
      end: DateTime.now().toUtc(),
    )
        .then((d) {
      dataMap.clear();
      data = d.where((f) {
        if (dropdownType == "全部") {
          return f.subtype == "airdrop";
        } else {
          return f.description == dropdownType;
        }
      }).toList();
      _constructMap(data, dataMap);
      setBusy(false);
    });
  }

  getDescription() async {
    List<String> response = await _bbbapi.getFundDescription();
    typeList = response;
    typeList.insert(0, "全部");
    setBusy(false);
  }

  buildDropdownMenu() {
    for (var asset in typeList) {
      dropdownList.add(
        custom.DropdownMenuItem<String>(
          value: asset,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(asset, style: StyleNewFactory.grey14),
          ),
        ),
      );
    }
    selectedItem = typeList[0];
  }

  changeSelectedItem(String type) {
    selectedItem = type;
    getRecords(dropdownType: type);
    setBusy(false);
  }

  _constructMap(List<FundRecordModel> list, var map) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        var month = DateTime.parse(list[i].time).toLocal().month;
        map.putIfAbsent(month, () => list);
        break;
      }
      if (i == 0) continue;
      var current = DateTime.parse(list[i].time).toLocal().month;
      var prev = DateTime.parse(list[i - 1].time).toLocal().month;
      if (current != prev) {
        map.putIfAbsent(prev, () => list.sublist(count, i));
        count = i;
      }
      if (i == list.length - 1) {
        map.putIfAbsent(current, () => list.sublist(count));
      }
    }
  }

  _mapFromDropdownToType(String dropDownText) {
    switch (dropDownText) {
      case "奖励金盈利":
        return "teddy-14";
      case "返佣":
        return "bbb-rebator";
      default:
        return "";
    }
  }
}
