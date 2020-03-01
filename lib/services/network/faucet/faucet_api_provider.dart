import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';
import 'faucet_api.dart';

class FaucetAPIProvider extends FaucetAPI {
  Dio dio = Dio();
  SharedPref _pref;

  FaucetAPIProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000; //5s
    dio.options.receiveTimeout = 13000;
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

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = FaucetConnection.PRO_FAUCET;
    } else if (_pref.getEnvType() == EnvType.Test) {
      dio.options.baseUrl = FaucetConnection.UAT_FAUCET;
    }
  }
}
