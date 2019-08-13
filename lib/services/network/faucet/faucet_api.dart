import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class FaucetAPI {
  setEnvMode({EnvType envType});
  Future<FaucetCaptchaResponseModel> getCaptcha();
  Future<RegisterRequestResponse> register(
      {RegisterRequestModel registerRequestModel});
  //post
}
