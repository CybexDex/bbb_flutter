import 'package:bbb_flutter/models/response/bbb_kb_response.dart';
import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:dio/dio.dart';

class ZendeskApiProvider extends ZendeskApi {
  Dio dio = Dio();

  ZendeskApiProvider() {
    _dispatchNode();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
  }

  _dispatchNode() {
    dio.options.baseUrl = BBBKBConnection.PRO_NODE;
  }

  @override
  Future<ZendeskAdvertiseResponse> getZendeskAdvertise({int count, String sortBy}) async {
    var response = await dio.get("/api/v2/help_center/zh-cn/categories/360002063651/articles.json",
        queryParameters: {"sort_by": sortBy, "per_page": count});
    return Future.value(ZendeskAdvertiseResponse.fromJson(response.data));
  }

  @override
  Future<List<BBBKBResponse>> getKBList() async {
    var response =
        await dio.get("/index.php?rest_route=%2Fwp%2Fv2%2Fknowledgebase&knowledgebase_cat=4");
    var responseData = response.data as List;
    List<BBBKBResponse> responseList =
        responseData.map((value) => BBBKBResponse.fromJson(value)).toList();
    return Future.value(responseList);
  }
}
