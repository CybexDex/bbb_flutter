import 'package:bbb_flutter/models/response/order_response_model.dart';

import '../env.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_provider/bloc_provider.dart';

class GetOrderBloc implements Bloc {
  BehaviorSubject<List<OrderResponseModel>> getOrderBloc =
      BehaviorSubject<List<OrderResponseModel>>();

  @override
  dispose() async {
    await getOrderBloc.close();
  }

  getOrder({String name}) async {
    List<OrderResponseModel> orderResponseModelList =
        await Env.apiClient.getOrders(name: name);
    getOrderBloc.sink.add(orderResponseModelList);
  }
}
