import 'dart:collection';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/forum_response/assets_list.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

class OrderRecordsViewModel extends BaseModel {
  final ForumApi _forumApi;
  final BBBAPI _bbbapi;
  final UserManager _userManager;

  List<OrderResponseModel> data = [];
  List<OrderResponseModel> upData = [];
  List<OrderResponseModel> downData = [];
  LinkedHashMap<int, List<OrderResponseModel>> orderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> upOrderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> downOrderMap = LinkedHashMap();
  List<AssetList> assetList = [];
  List<custom.DropdownMenuItem<AssetList>> dropdownList = [];
  AssetList selectedItem;

  OrderRecordsViewModel(
      ForumApi forumApi, BBBAPI bbbapi, UserManager userManager)
      : _forumApi = forumApi,
        _bbbapi = bbbapi,
        _userManager = userManager;

  getRecords({String asset}) async {
    var name = _userManager.user.name;
    _bbbapi
        .getOrders(name,
            status: [OrderStatus.closed],
            startTime: (DateTime.now().subtract(Duration(days: 90)))
                .toUtc()
                .toIso8601String(),
            endTime: DateTime.now().toUtc().toIso8601String(),
            injectAsset: asset)
        .then((d) {
      data = d;
      upData = d.where((o) => o.contractId.contains("N")).toList();
      downData = d.where((o) => !o.contractId.contains("N")).toList();
      _constructMap(data, orderMap);
      _constructMap(upData, upOrderMap);
      _constructMap(downData, downOrderMap);
      setBusy(false);
    });
  }

  getAsset() async {
    ForumResponse<AssetList> response =
        await _forumApi.getAssetList(siz: 100, pg: 0);
    assetList = response.result;
    assetList.sort((a, b) => a.seq.compareTo(b.seq));
    buildDropdownMenu();
    setBusy(false);
  }

  buildDropdownMenu() {
    for (var asset in assetList) {
      dropdownList.add(
        custom.DropdownMenuItem<AssetList>(
          value: asset,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(asset.symbol, style: StyleNewFactory.grey14),
          ),
        ),
      );
    }
    selectedItem = dropdownList
        .firstWhere(
            (test) => test.value.symbol == locator.get<SharedPref>().getAsset(),
            orElse: () => null)
        ?.value;
  }

  changeSelectedItem(AssetList asset) {
    selectedItem = asset;
    getRecords(asset: asset.symbol);
    setBusy(false);
  }

  _constructMap(List<OrderResponseModel> list, var map) {
    map.clear();
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        var month = DateTime.parse(list[i].settleTime).toLocal().month;
        map.putIfAbsent(month, () => list);
        break;
      }
      if (i == 0) continue;
      var current = DateTime.parse(list[i].settleTime).toLocal().month;
      var prev = DateTime.parse(list[i - 1].settleTime).toLocal().month;
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
