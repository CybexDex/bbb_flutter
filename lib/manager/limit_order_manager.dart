import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/cancel_limit_order_request_model.dart';
import 'package:bbb_flutter/models/response/limit_order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:logger/logger.dart';

import '../setup.dart';

class LimitOrderManager extends BaseModel {
  List<LimitOrderResponse> orders = [];
  List<SelectedItem> selectedOrders = [];
  bool isSelected = false;
  int selectedTotalCount = 0;

  int index = 0;
  BBBAPI _api;
  UserManager _um;

  Function _getOrdersCallback;
  StreamSubscription _refSub;

  LimitOrderManager({BBBAPI api, UserManager um, RefManager rm}) {
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
      orders = await _api.getLimitOrders(_um.user.name, active: "1");
      orders = orders.toList();
      if (orders.length > 0) {
        index = min(index, orders.length - 1);
      }
      initOrUpdateSelectedList();
      calculateMoneyCount();

      setBusy(false);
    } else {
      orders = [];
      setBusy(false);
    }
  }

  void initOrUpdateSelectedList() {
    if (selectedOrders.isEmpty) {
      selectedOrders = orders.map((value) {
        SelectedItem selectedItem = SelectedItem();
        selectedItem.isSelected = false;
        selectedItem.buyOrderTxId = value.orderId;
        return selectedItem;
      }).toList();
    } else if (selectedOrders.isNotEmpty &&
        selectedOrders.length != orders.length) {
      List<SelectedItem> tempList = [];
      tempList = orders.map((value) {
        SelectedItem selectedItem = SelectedItem();
        selectedItem.isSelected = false;
        selectedItem.buyOrderTxId = value.orderId;
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

  isAllSeleted() {
    var count = 0;
    for (var i = 0; i < selectedOrders.length; i++) {
      if (selectedOrders[i].isSelected) {
        count++;
      }
    }
    return count == selectedOrders.length;
  }

  void calculateMoneyCount() {
    selectedTotalCount = 0;
    for (int i = 0; i < orders.length; i++) {
      if (selectedOrders[i].isSelected) {
        selectedTotalCount++;
      }
    }
    setBusy(false);
  }

  Future<PostOrderResponseModel> cancelOrder(LimitOrderResponse order) async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(
          _um.user.testAccountResponseModel.privkey);
    }
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final model = CancelLimitOrderRequest(data: Data());
    model.data.action = locator.get<SharedPref>().getAction();
    model.data.user = _um.user.testAccountResponseModel != null
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.name;
    model.data.orderId = order.orderId;
    model.data.timeout = expir + 5 * 60;

    var data = model.data.toJson();
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    model.signature =
        sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    var requestCancelLimitOrder = model.toJson();
    try {
      PostOrderResponseModel res = await _api.postCancelLimitOrder(
          requestCancelLimitOrder: requestCancelLimitOrder);
      locator.get<Logger>().w(res);
      return res;
    } catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  @override
  void dispose() async {
    _um.removeListener(_getOrdersCallback);
    await _refSub.cancel();

    super.dispose();
  }
}

class SelectedItem {
  bool isSelected;
  int buyOrderTxId;
}
