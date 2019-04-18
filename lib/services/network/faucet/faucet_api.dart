import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';

abstract class FaucetAPI {
  Future<FaucetCaptchaResponseModel> getCaptcha();
}
