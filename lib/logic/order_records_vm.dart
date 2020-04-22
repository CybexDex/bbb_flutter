import 'dart:collection';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/underlying_asset_response.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

class OrderRecordsViewModel extends BaseModel {
  final BBBAPI _bbbapi;
  final UserManager _userManager;

  List<OrderResponseModel> data = [];
  List<OrderResponseModel> upData = [];
  List<OrderResponseModel> downData = [];
  LinkedHashMap<int, List<OrderResponseModel>> orderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> upOrderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> downOrderMap = LinkedHashMap();
  List<UnderlyingAssetResponse> assetList = [];
  List<custom.DropdownMenuItem<UnderlyingAssetResponse>> dropdownList = [];
  UnderlyingAssetResponse selectedItem;

  OrderRecordsViewModel(BBBAPI bbbapi, UserManager userManager)
      : _bbbapi = bbbapi,
        _userManager = userManager;

  getRecords({String asset}) async {
    var name = _userManager.user.name;
    _bbbapi
        .getOrders(name,
            status: [OrderStatus.closed],
            startTime: (DateTime.now().subtract(Duration(days: 90))).toUtc().toIso8601String(),
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
    List<UnderlyingAssetResponse> response = locator.get<RefManager>().underlyingList;
    assetList = response;
    buildDropdownMenu();
    setBusy(false);
  }

  buildDropdownMenu() {
    for (var asset in assetList) {
      dropdownList.add(
        custom.DropdownMenuItem<UnderlyingAssetResponse>(
          value: asset,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(asset.underlying, style: StyleNewFactory.grey14),
          ),
        ),
      );
    }
    selectedItem = dropdownList
        .firstWhere((test) => test.value.underlying == locator.get<SharedPref>().getAsset(),
            orElse: () => null)
        ?.value;
  }

  changeSelectedItem(UnderlyingAssetResponse asset) {
    selectedItem = asset;
    getRecords(asset: asset.underlying);
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
