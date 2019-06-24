import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';

class OrderViewModel extends BaseModel {
  List<OrderResponseModel> orders = [];

  int index = 0;
  BBBAPIProvider _api;

  OrderViewModel({BBBAPIProvider api}) : _api = api;

  getOrders({String name}) async {
    setBusy(true);
    orders = await _api.getOrders(name: name);
    setBusy(false);
  }
}
