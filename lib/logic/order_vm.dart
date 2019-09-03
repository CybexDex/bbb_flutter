import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';

class OrderViewModel extends BaseModel {
  List<OrderResponseModel> orders = [];

  int index = 0;
  double totlaPnl = 0;
  BBBAPI _api;
  UserManager _um;

  Function _getOrdersCallback;
  StreamSubscription _refSub;

  OrderViewModel({BBBAPI api, UserManager um, RefManager rm}) {
    _api = api;
    _um = um;

    getOrders();

    _getOrdersCallback = () {
      getOrders();
    };
    _refSub = rm.data.listen((data) {
      getOrders();
    });
    um.removeListener(_getOrdersCallback);
    um.addListener(_getOrdersCallback);
  }

  getOrders() async {
    if (_um.user.logined) {
//      setBusy(true);
      orders = await _api.getOrders(_um.user.name, status: [OrderStatus.open]);
      orders = orders.take(10).toList();
      if (orders.length > 0) {
        index = min(index, orders.length - 1);
      }
      calculateTotalPnl();
      setBusy(false);
    } else {
      orders = [];
      totlaPnl = 0;
      setBusy(false);
    }
  }

  void calculateTotalPnl() {
    totlaPnl = 0;
    for (OrderResponseModel orderResponseModel in orders) {
      totlaPnl += (orderResponseModel.pnl + orderResponseModel.commission);
    }
  }

  OrderResponseModel getCurrentOrder() {
    return isAllEmpty(orders) ? null : orders[index];
  }

  @override
  void dispose() {
    _um.removeListener(_getOrdersCallback);
    _refSub.cancel();

    super.dispose();
  }
}
