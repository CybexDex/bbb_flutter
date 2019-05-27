import 'package:bbb_flutter/models/response/order_response_model.dart';

import '../env.dart';
import 'package:rxdart/rxdart.dart';

class GetOrderBloc {
  BehaviorSubject<List<OrderResponseModel>> getOrderBloc =
      BehaviorSubject<List<OrderResponseModel>>();

  dispose() {
    getOrderBloc.close();
  }

  getOrder({String name}) async {
    List<OrderResponseModel> orderResponseModelList =
        await Env.apiClient.getOrders(name: name);
    getOrderBloc.sink.add(orderResponseModelList);
  }
}
