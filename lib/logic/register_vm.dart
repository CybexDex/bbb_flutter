import 'dart:async';
import 'dart:convert';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class RegisterViewModel extends BaseModel {
  UserManager _userManager;
  FaucetAPI _faucetAPI;
  BuildContext _buildContext;
  Timer timer;
  String _capid;
  String rawSvg;
  bool errorMessageVisibility = false;
  bool isButtonEnabled = false;
  bool _isAccountNamePassChecker = false;
  bool _isPasswordPassChecker = false;
  bool _isPasswordConfirmChecker = false;
  bool showPinCodeLoading = false;
  bool passwordObscureText = true;
  bool passwordConfirmObscureText = true;
  String errorMessage = "";
  FaucetCaptchaResponseModel faucetCaptchaResponseModel;

  RegisterViewModel(
      {BBBAPI bbbapi,
      UserManager userManager,
      FaucetAPI faucetAPI,
      BuildContext buildContext})
      : _userManager = userManager,
        _faucetAPI = faucetAPI,
        _buildContext = buildContext;

  processRegister({
    String accountName,
    String password,
    String pinCode,
  }) async {
    RegisterRequestModel requestModel =
        RegisterRequestModel(cap: Cap(), account: Account());
    String keys =
        await CybexFlutterPlugin.getUserKeyWith(accountName, password);
    var jsonKeys = json.decode(keys);
    requestModel.account.activeKey = jsonKeys["active-key"]["public_key"];
    requestModel.account.ownerKey = jsonKeys["owner-key"]["public_key"];
    requestModel.account.memoKey = jsonKeys["memo-key"]["public_key"];

    requestModel.account.name = accountName;
    requestModel.cap.id = _capid;
    requestModel.cap.captcha = pinCode;
    RegisterRequestResponse registerRequestResponse =
        await _faucetAPI.register(registerRequestModel: requestModel);
    if (registerRequestResponse.error != null) {
      errorMessageVisibility = true;
      errorMessage = registerRequestResponse.error;
      Navigator.of(_buildContext).pop();
    } else if (registerRequestResponse.error == null &&
        registerRequestResponse != null) {
      try {
        if (await _userManager.loginWith(
            name: accountName, password: password)) {
          await checkAdd(_buildContext, activityTypes[ActivityType.register]);
          await _userManager.fetchBalances(name: accountName);
          Navigator.of(_buildContext).popUntil((route) => route.isFirst);
        } else {
          errorMessage = "注册失败请重试";
          errorMessageVisibility = true;
          Navigator.of(_buildContext).pop();
        }
      } catch (error) {
        errorMessage = "注册失败请重试";
        errorMessageVisibility = true;
        Navigator.of(_buildContext).pop();
      }
    } else {
      errorMessage = "注册失败请重试";
      errorMessageVisibility = true;
      Navigator.of(_buildContext).pop();
    }
    setBusy(false);
  }

  checkAccountName(String accountName, String pinCode) async {
    if (accountName.isEmpty) {
      errorMessage = "请输入账号";
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (!accountName.startsWith(RegExp("[a-zA-Z]"))) {
      errorMessage = I18n.of(_buildContext).registerErrorMessageStartOnlyLetter;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (!RegExp("^[a-z0-9-]+\$").hasMatch(accountName)) {
      errorMessage =
          I18n.of(_buildContext).registerErrorMessageContainLowercase;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (accountName.length < 3) {
      errorMessage = I18n.of(_buildContext).registerErrorMessageShortNameLength;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (accountName.contains("--")) {
      errorMessage = I18n.of(_buildContext)
          .registerErrorMessageShouldNotContainContinuesDash;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (accountName.endsWith("-")) {
      errorMessage = I18n.of(_buildContext).registerErrorMessageDashEnd;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (RegExp("^[a-z]+\$").hasMatch(accountName)) {
      errorMessage =
          I18n.of(_buildContext).registerErrorMessageOnlyContainLetter;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else if (accountName.length >= 63) {
      errorMessage = I18n.of(_buildContext).registerErrorMessageTooLong;
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
    } else {
      await processAccountCheck(accountName);
    }
    setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        pinCode.isEmpty);
  }

  checkPassword(String password, String passwordConfirm, String accountName,
      String pinCode) {
    if (password.isEmpty) {
      checkPasswordConfirmation(
          passwordConfirm, password, accountName, pinCode);
    } else if (!RegExp(
            "(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{12,}")
        .hasMatch(password)) {
      if (accountName.isEmpty || _isAccountNamePassChecker) {
        errorMessageVisibility = true;
        errorMessage =
            I18n.of(_buildContext).registerErrorMessagePasswordChecker;
        _isPasswordPassChecker = false;
      }
    } else {
      errorMessageVisibility = false;
      _isPasswordPassChecker = true;
      checkPasswordConfirmation(
          passwordConfirm, password, accountName, pinCode);
    }
    setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        pinCode.isEmpty);
  }

  checkPasswordConfirmation(String confirmPassword, String password,
      String accountName, String pinCode) {
    if (!_isPasswordPassChecker || confirmPassword.isEmpty) {
      return;
    }
    if (password != confirmPassword) {
      if ((accountName.isEmpty || _isAccountNamePassChecker) &&
          (_isPasswordPassChecker || password.isEmpty)) {
        errorMessageVisibility = true;
        errorMessage =
            I18n.of(_buildContext).registerErrorMessagePasswordConfirm;
        _isPasswordConfirmChecker = false;
      }
    } else {
      if (confirmPassword.isNotEmpty) {
        _isPasswordConfirmChecker = true;
        errorMessageVisibility = false;
      }
    }
    setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        pinCode.isNotEmpty);
  }

  processAccountCheck(String accountName) async {
    if (await _userManager.checkAccount(name: accountName)) {
      errorMessageVisibility = true;
      _isAccountNamePassChecker = false;
      errorMessage =
          I18n.of(_buildContext).registerErrorMessageAccountHasAlreadyExist;
    } else {
      errorMessageVisibility = false;
      _isAccountNamePassChecker = true;
      errorMessage = "";
    }
    setBusy(false);
  }

  checkPinCode(String pinCode) {
    setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        pinCode.isNotEmpty);
  }

  setPasswordObscure() {
    passwordObscureText = !passwordObscureText;
    setBusy(false);
  }

  setPasswordConfirmObscure() {
    passwordConfirmObscureText = !passwordConfirmObscureText;
    setBusy(false);
  }

  setButtonState(bool isEnabled) {
    isButtonEnabled = isEnabled;
    setBusy(false);
  }

  getSvg() async {
    faucetCaptchaResponseModel = await _faucetAPI.getCaptcha();
    _capid = faucetCaptchaResponseModel?.id;
    rawSvg = faucetCaptchaResponseModel?.data;
    if (showPinCodeLoading) {
      showPinCodeLoading = !showPinCodeLoading;
    }
    setBusy(false);
  }

  displaySvg() async {
    showPinCodeLoading = true;
    await getSvg();
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(minutes: 5), (timer) {
      getSvg();
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }
}
