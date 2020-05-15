import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/services/network/push/push_api.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:dio/dio.dart';

class PushApiProvider extends PushApi {
  Dio dio = Dio();

  PushApiProvider() {
    dio.options.baseUrl = "http://43.252.132.73:55500";
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
  }

  @override
  Future<dynamic> registerPush({String accountName, String regId, int timeout}) async {
    var data = {"account_name": accountName, "reg_id": regId, "timeout": timeout};
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    sig = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    var requestBody = {"data": data, "signature": sig};
    print(requestBody);
    try {
      var response = await dio.post("/push/subscribe", data: requestBody);
      return Future.value(response.data);
    } on DioError catch (e) {
      print(e.response);
    }
  }

  @override
  Future<dynamic> unRegisterPush({String accountName, String regId}) async {
    var requestBody = {"account_name": accountName, "reg_id": regId};
    print(requestBody);
    var response = await dio.post("/push/unsubscribe", data: requestBody);
    return Future.value(response.data);
  }
}
