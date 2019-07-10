import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/register_request_model.dart';
import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/models/response/register_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api_provider.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class RegisterPage extends StatefulWidget {
  final String title;

  RegisterPage({Key key, this.title}) : super(key: key);

  @override
  State createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _pinCodeController = TextEditingController();
  bool _errorMessageVisibility = false;
  bool _isButtonEnabled = false;
  bool _isAccountNamePassChecker = false;
  bool _isPasswordPassChecker = false;
  bool _isPasswordConfirmChecker = false;
  String _capid;

  String _errorMessage = "";
  Timer timer;
  Widget _widget = Text(
    "获取验证码",
    style: StyleFactory.pinCodeText,
  );

  displaySvg() {
    getSvg();
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(minutes: 5), (timer) {
      getSvg();
    });
  }

  getSvg() {
    Future<FaucetCaptchaResponseModel> response =
        FaucetAPIProvider().getCaptcha();
    response.then((FaucetCaptchaResponseModel model) {
      String rawSvg = model.data;
      _capid = model.id;

      setState(() {
        _widget = SvgPicture.string(
          rawSvg,
        );
      });
    });
  }

  _processRegister() async {
    RegisterRequestModel requestModel =
        RegisterRequestModel(cap: Cap(), account: Account());
    String keys = await CybexFlutterPlugin.getUserKeyWith(
        _accountNameController.text, _passwordController.text);
    var jsonKeys = json.decode(keys);
    requestModel.account.activeKey = jsonKeys["active-key"]["public_key"];
    requestModel.account.ownerKey = jsonKeys["owner-key"]["public_key"];
    requestModel.account.memoKey = jsonKeys["memo-key"]["public_key"];

    requestModel.account.name = _accountNameController.text;
    requestModel.cap.id = _capid;
    requestModel.cap.captcha = _pinCodeController.text;
    RegisterRequestResponse registerRequestResponse = await locator
        .get<FaucetAPIProvider>()
        .register(registerRequestModel: requestModel);
    if (registerRequestResponse.error != null) {
      setState(() {
        _errorMessageVisibility = true;
        _errorMessage = registerRequestResponse.error;
      });
    } else if (registerRequestResponse.error == null &&
        registerRequestResponse != null) {
      await locator.get<UserManager>().loginWith(
          name: _accountNameController.text,
          password: _passwordController.text);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _errorMessage = "Network status error";
        _errorMessageVisibility = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllerListener();
    createFocusNode();
  }

  controllerListener() {
    _accountNameController.addListener(() {
      _checkAccountName(_accountNameController.text);
    });

    _passwordController.addListener(() {
      _checkPassword(_passwordController.text);
    });

    _passwordConfirmController.addListener(() {
      _checkPasswordConfirmation(_passwordConfirmController.text);
    });

    _pinCodeController.addListener(() {
      _setButtonState(_isAccountNamePassChecker &&
          _isPasswordPassChecker &&
          _isPasswordConfirmChecker &&
          _pinCodeController.text.isNotEmpty);
    });
  }

  _checkAccountName(String accountName) {
    if (accountName.isEmpty) {
      setState(() {
        _errorMessage = "请输入账号";
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else if (!accountName.startsWith(RegExp("[a-zA-Z]"))) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageStartOnlyLetter;
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else if (!RegExp("^[a-z0-9-]+\$").hasMatch(accountName)) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageContainLowercase;
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else if (accountName.length < 3) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageShortNameLength;
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else if (accountName.contains("--")) {
      setState(() {
        _errorMessage =
            I18n.of(context).registerErrorMessageShouldNotContainContinuesDash;
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else if (RegExp("^[a-z]+\$").hasMatch(accountName)) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageOnlyContainLetter;
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
      });
    } else {
      _processAccountCheck(accountName);
    }
    _setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        _pinCodeController.text.isNotEmpty);
  }

  _checkPassword(String password) {
    if (password.isEmpty) {
      _checkPasswordConfirmation(_passwordConfirmController.text);
    } else if (!RegExp(
            "(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{12,}")
        .hasMatch(password)) {
      if (_accountNameController.text.isEmpty || _isAccountNamePassChecker) {
        setState(() {
          _errorMessageVisibility = true;
          _errorMessage = I18n.of(context).registerErrorMessagePasswordChecker;
          _isPasswordPassChecker = false;
        });
      }
    } else {
      setState(() {
        _errorMessageVisibility = false;
        _isPasswordPassChecker = true;
        _checkPasswordConfirmation(_passwordConfirmController.text);
      });
    }
    _setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        _pinCodeController.text.isNotEmpty);
  }

  _checkPasswordConfirmation(String confirmPassword) {
    if (!_isPasswordPassChecker) {
      return;
    }
    if (_passwordController.text != confirmPassword) {
      if ((_accountNameController.text.isEmpty || _isAccountNamePassChecker) &&
          (_isPasswordPassChecker || _passwordController.text.isEmpty)) {
        setState(() {
          _errorMessageVisibility = true;
          _errorMessage = "密码不一样";
        });
        _isPasswordConfirmChecker = false;
      }
    } else {
      if (_passwordController.text.isNotEmpty) {
        setState(() {
          _isPasswordConfirmChecker = true;
          _errorMessageVisibility = false;
        });
      }
    }

    _setButtonState(_isAccountNamePassChecker &&
        _isPasswordPassChecker &&
        _isPasswordConfirmChecker &&
        _pinCodeController.text.isNotEmpty);
  }

  createFocusNode() {
    var _accountNameFocusNode = FocusNode();
    var _passwordFocusNode = FocusNode();
    var _passwordConfirmFocusNode = FocusNode();
  }

  _processAccountCheck(String accountName) async {
    if (await locator.get<UserManager>().checkAccount(name: accountName)) {
      setState(() {
        _errorMessageVisibility = true;
        _isAccountNamePassChecker = false;
        _errorMessage =
            I18n.of(context).registerErrorMessageAccountHasAlreadyExist;
      });
    } else {
      setState(() {
        _errorMessageVisibility = false;
        _isAccountNamePassChecker = true;
        _errorMessage = "";
      });
    }
  }

  _setButtonState(bool isEnabled) {
    setState(() {
      _isButtonEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text("注册", style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            margin: Dimen.pageMargin,
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: DecorationFactory.cornerShadowDecoration,
                          height: 333,
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 29)),
                              Expanded(
                                  child: ListView(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      children: <Widget>[
                                    Column(children: <Widget>[
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("注册",
                                              style: StyleFactory.title)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Visibility(
                                          visible: !_errorMessageVisibility,
                                          child: Text(
                                            "欢迎注册您的账户!",
                                            style: StyleFactory.cellTitleStyle,
                                          ),
                                          replacement: Text(_errorMessage,
                                              style: StyleFactory
                                                  .errorMessageText),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      TextFormField(
                                        controller: _accountNameController,
                                        decoration: InputDecoration(
                                            hintText: I18n.of(context)
                                                .accountNameHint,
                                            hintStyle: StyleFactory.hintStyle,
                                            icon: Image.asset(
                                                "res/assets/icons/icUser.png"),
                                            border: InputBorder.none),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Palette.separatorColor,
                                                    width: 0.5))),
                                      )
                                    ]),
                                    Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                              hintText: I18n.of(context)
                                                  .passwordConfirm,
                                              hintStyle: StyleFactory.hintStyle,
                                              icon: Image.asset(
                                                  "res/assets/icons/icPassword.png"),
                                              border: InputBorder.none),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Palette
                                                          .separatorColor,
                                                      width: 0.5))),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller:
                                              _passwordConfirmController,
                                          decoration: InputDecoration(
                                              hintText: "请再次确认密码",
                                              hintStyle: StyleFactory.hintStyle,
                                              icon: Image.asset(
                                                  "res/assets/icons/icPassword.png"),
                                              border: InputBorder.none),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Palette
                                                          .separatorColor,
                                                      width: 0.5))),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                controller: _pinCodeController,
                                                decoration: InputDecoration(
                                                    hintText: "请输入验证码",
                                                    hintStyle:
                                                        StyleFactory.hintStyle,
                                                    icon: Image.asset(
                                                        "res/assets/icons/icCode.png"),
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                            GestureDetector(
                                              child: _widget,
                                              onTap: () {
                                                displaySvg();
                                              },
                                            )
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Palette
                                                          .separatorColor,
                                                      width: 0.5))),
                                        )
                                      ],
                                    ),
                                  ]))
                            ],
                          ),
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(top: 325),
                            child: ButtonTheme(
                              minWidth: 200,
                              child: WidgetFactory.button(
                                  onPressed: _isButtonEnabled
                                      ? () async {
                                          showLoading(context);
                                          await _processRegister();
                                        }
                                      : () {},
                                  color: _isButtonEnabled
                                      ? Palette.redOrange
                                      : Palette.subTitleColor,
                                  data: "注册"),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset("res/assets/icons/icWarn.png"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "为了您的资金安全请妥善保存您的密码，该密码无法找回!",
                          style: StyleFactory.subTitleStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    GestureDetector(
                      child: RichText(
                          text: new TextSpan(children: [
                        new TextSpan(
                            style: StyleFactory.hintStyle, text: "已注册？"),
                        new TextSpan(style: StyleFactory.hyperText, text: "去登录")
                      ])),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )),
          )),
        ));
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    disposeController();
    super.dispose();
  }

  disposeController() {
    _accountNameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _pinCodeController.dispose();
  }
}
