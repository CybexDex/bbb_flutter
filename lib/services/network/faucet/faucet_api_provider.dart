import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';
import 'package:dio/dio.dart';

import 'faucet_api.dart';

class FaucetAPIProvider extends FaucetAPI {
  Dio dio = Dio();

  FaucetAPIProvider() {
    dio.options.baseUrl = "http://uatfaucet.51nebula.com";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<FaucetCaptchaResponseModel> getCaptcha() async {
    var response = await dio.get('/captcha');
    return Future.value(FaucetCaptchaResponseModel.fromJson(response.data));
  }

  @override
  Future<RegisterRequestResponse> register(
      {RegisterRequestModel registerRequestModel}) async {
    try {
      var response =
          await dio.post('/register', data: registerRequestModel.toJson());
      return Future.value(RegisterRequestResponse.fromJson(response.data));
    } on DioError catch (e) {
      if (e.response != null) {
        return Future.value(RegisterRequestResponse.fromJson(e.response.data));
      }
    }
    return RegisterRequestResponse();
  }
}
