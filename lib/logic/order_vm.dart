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
  List<SelectedItem> selectedOrders = [];
  bool isSelected = false;
  var selectedTotalPnl = 0.0;
  int selectedTotalCount = 0;

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
    _refSub = rm.contractController.stream.listen((data) {
      getOrders();
    });
    um.removeListener(_getOrdersCallback);
    um.addListener(_getOrdersCallback);
  }

  getOrders() async {
    if (_um.user.logined) {
//      setBusy(true);
      orders = await _api.getOrders(_um.user.name, status: [OrderStatus.open]);
      orders = orders.toList();
      if (orders.length > 0) {
        index = min(index, orders.length - 1);
      }
      calculateTotalPnl();
      initOrUpdateSelectedList();
      calculateMoneyCount();
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
      totlaPnl += (orderResponseModel.pnl);
    }
  }

  void initOrUpdateSelectedList() {
    if (selectedOrders.isEmpty) {
      selectedOrders = orders.map((value) {
        SelectedItem selectedItem = SelectedItem();
        selectedItem.isSelected = false;
        selectedItem.buyOrderTxId = value.buyOrderTxId;
        return selectedItem;
      }).toList();
    } else if (selectedOrders.isNotEmpty &&
        selectedOrders.length != orders.length) {
      List<SelectedItem> tempList = [];
      tempList = orders.map((value) {
        SelectedItem selectedItem = SelectedItem();
        selectedItem.isSelected = false;
        selectedItem.buyOrderTxId = value.buyOrderTxId;
        return selectedItem;
      }).toList();
      for (int i = 0; i < tempList.length; i++) {
        for (int j = 0; j < selectedOrders.length; j++) {
          if (selectedOrders[j].buyOrderTxId == tempList[i].buyOrderTxId) {
            tempList[i].isSelected = selectedOrders[j].isSelected;
          }
        }
      }
      selectedOrders = tempList;
    }
  }

  void selectAll() {
    for (var i = 0; i < selectedOrders.length; i++) {
      selectedOrders[i].isSelected = !isSelected;
    }
    isSelected = !isSelected;
    setBusy(false);
  }

  void calculateMoneyCount() {
    selectedTotalPnl = 0.00;
    selectedTotalCount = 0;
    for (int i = 0; i < orders.length; i++) {
      if (selectedOrders[i].isSelected) {
        selectedTotalCount++;
        selectedTotalPnl += double.parse((orders[i].pnl).toStringAsFixed(4));
      }
    }
    setBusy(false);
  }

  isAllSeleted() {
    var count = 0;
    for (var i = 0; i < selectedOrders.length; i++) {
      if (selectedOrders[i].isSelected) {
        count++;
      }
    }
    return count == selectedOrders.length;
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

class SelectedItem {
  bool isSelected;
  int buyOrderTxId;
}
