import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';

abstract class FaucetAPI {
  Future<FaucetCaptchaResponseModel> getCaptcha();
  Future<RegisterRequestResponse> register(
      {RegisterRequestModel registerRequestModel});
  //post
}
