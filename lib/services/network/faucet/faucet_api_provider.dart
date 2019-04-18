import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:dio/dio.dart';

import 'faucet_api.dart';

class FaucetAPIProvider extends FaucetAPI {
  factory FaucetAPIProvider() => _sharedInstance();

  static FaucetAPIProvider _sharedInstance() {
    if (_instance == null) {
      _instance = FaucetAPIProvider._();
    }
    return _instance;
  }

  static FaucetAPIProvider _instance;

  Dio dio = Dio();

  FaucetAPIProvider._() {
    dio.options.baseUrl = "https://faucet.cybex.io";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<FaucetCaptchaResponseModel> getCaptcha() async {
    var response = await dio.get('/captcha');
    return Future.value(FaucetCaptchaResponseModel.fromJson(response.data));
  }
}
