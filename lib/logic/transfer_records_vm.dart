import 'dart:collection';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';

class TransferRecordsViewModel extends BaseModel {
  final BBBAPI _bbbapi;
  final UserManager _userManager;

  List<FundRecordModel> data = [];
  List<FundRecordModel> transferIn = [];
  List<FundRecordModel> transferOut = [];
  LinkedHashMap<int, List<FundRecordModel>> dataMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> transferInMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> transferOutMap = LinkedHashMap();

  TransferRecordsViewModel(BBBAPI bbbapi, UserManager userManager)
      : _bbbapi = bbbapi,
        _userManager = userManager;

  getRecords({String asset}) async {
    var name = _userManager.user.name;
    _bbbapi
        .getFundRecords(
      name: name,
      subType: "transfer_in,transfer_out",
      start: DateTime.now().toUtc().subtract(Duration(days: 30)),
      end: DateTime.now().toUtc(),
    )
        .then((d) {
      data = d
          .where((f) =>
              fundTypeMap[f.subtype] == FundType.userDepositCybex ||
              fundTypeMap[f.subtype] == FundType.userWithdrawCybex)
          .toList();
      transferIn = d.where((f) => fundTypeMap[f.subtype] == FundType.userDepositCybex).toList();
      transferOut = d.where((f) => fundTypeMap[f.subtype] == FundType.userWithdrawCybex).toList();
      _constructMap(data, dataMap);
      _constructMap(transferIn, transferInMap);
      _constructMap(transferOut, transferOutMap);
      setBusy(false);
    });
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
}
