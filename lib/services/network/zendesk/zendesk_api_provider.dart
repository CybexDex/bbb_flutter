import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:dio/dio.dart';

import '../../../setup.dart';

class ZendeskApiProvider extends ZendeskApi {
  Dio dio = Dio();

  ZendeskApiProvider() {
    _dispatchNode();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
    setupProxy(dio);
  }

  _dispatchNode() {
    dio.options.baseUrl = ZenDeskConnection.PRO_NODE;
  }

  @override
  Future<ZendeskAdvertiseResponse> getZendeskAdvertise(
      {int count, String sortBy}) async {
    var response = await dio.get(
        "/api/v2/help_center/zh-cn/categories/360002063651/articles.json",
        queryParameters: {"sort_by": sortBy, "per_page": count});
    return Future.value(ZendeskAdvertiseResponse.fromJson(response.data));
  }
}
