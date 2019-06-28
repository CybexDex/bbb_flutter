import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';

class OrderViewModel extends BaseModel {
  List<OrderResponseModel> orders = [];

  int index = 0;
  BBBAPIProvider _api;
  UserManager _um;

  OrderViewModel({BBBAPIProvider api, UserManager um}) {
    _api = api;
    _um = um;

    if (_um.user.logined) {
      getOrders(name: "abigale1989");
    }
    um.addListener(() {
      if (_um.user.logined) {
        getOrders(name: "abigale1989");
      }
    });
  }

  getOrders({String name}) async {
    setBusy(true);
    orders = await _api.getOrders(name: name);
    orders = orders.take(10).toList();
    setBusy(false);
  }

  OrderResponseModel getCurrentOrder() {
    return isAllEmpty(orders) ? null : orders[index];
  }
}
