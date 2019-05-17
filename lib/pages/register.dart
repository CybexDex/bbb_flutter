import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/faucet_captcha_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../env.dart';

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
  bool _isButtonDisabled = true;
  bool _isAccountNamePassChecker = false;
  bool _isPasswordPassChecker = false;
  bool _isPasswordConfirmChecker = false;
  String _errorMessage = "s";
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
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getSvg();
    });
  }

  getSvg() {
    Future<FaucetCaptchaResponseModel> response =
        FaucetAPIProvider().getCaptcha();
    response.then((FaucetCaptchaResponseModel model) {
      String rawSvg = model.data;
      setState(() {
        _widget = SvgPicture.string(
          rawSvg,
          width: 20,
          height: 20,
        );
      });
    });
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

    _passwordController.addListener(() {});

    _passwordConfirmController.addListener(() {});
  }

  _checkAccountName(String accountName) {
    if (accountName.isEmpty) {
      setState(() {
        _errorMessage = "请输入账号";
        _errorMessageVisibility = true;
      });
    } else if (!accountName.startsWith(RegExp("[a-zA-Z]"))) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageStartOnlyLetter;
        _errorMessageVisibility = true;
      });
    } else if (!RegExp("^[a-z0-9-]+").hasMatch(accountName)) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageContainLowercase;
        _errorMessageVisibility = true;
      });
    } else if (accountName.length < 3) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageShortNameLength;
        _errorMessageVisibility = true;
      });
    } else if (accountName.contains("--")) {
      setState(() {
        _errorMessage =
            I18n.of(context).registerErrorMessageShouldNotContainContinuesDash;
        _errorMessageVisibility = true;
      });
    } else if (RegExp("^[a-z]+").hasMatch(accountName)) {
      setState(() {
        _errorMessage = I18n.of(context).registerErrorMessageOnlyContainLetter;
        _errorMessageVisibility = true;
      });
    } else {
      _processAccountCheck(accountName);
    }
    _setButtonState();
  }

  _checkPassword(String password) {
    if (password.isEmpty) {
    } else if (!RegExp(
            "(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{12,}")
        .hasMatch(password)) {
      if (_accountNameController.text.isEmpty || _isAccountNamePassChecker) {
        setState(() {
          _errorMessageVisibility = true;
          _errorMessage = I18n.of(context).registerErrorMessagePasswordChecker;
        });
      } else {
        _errorMessageVisibility = false;
        _isPasswordPassChecker = true;
        _checkPasswordConfirmation(_passwordConfirmController.text);
      }
    }
  }

  _checkPasswordConfirmation(String confirmPassword) {}

  createFocusNode() {
    var _accountNameFocusNode = FocusNode();
    var _passwordFocusNode = FocusNode();
    var _passwordConfirmFocusNode = FocusNode();
  }

  _processAccountCheck(String accountName) async {
    AccountResponseModel response =
        await Env.apiClient.getAccount(name: accountName);
    if (response != null && accountName == response.name) {
      setState(() {
        _errorMessageVisibility = true;
        _errorMessage =
            I18n.of(context).registerErrorMessageAccountHasAlreadyExist;
      });
    } else {
      setState(() {
        _errorMessageVisibility = false;
      });
    }
  }

  _setButtonState() {
    setState(() {});
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
        body: SafeArea(
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
                                            style:
                                                StyleFactory.errorMessageText),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    TextFormField(
                                      controller: _accountNameController,
                                      decoration: InputDecoration(
                                          hintText:
                                              I18n.of(context).accountNameHint,
                                          hintStyle: StyleFactory.hintStyle,
                                          icon: Image.asset(
                                              "res/assets/icons/icUser.png"),
                                          border: InputBorder.none),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Palette.separatorColor,
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
                                                    color:
                                                        Palette.separatorColor,
                                                    width: 0.5))),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: _passwordConfirmController,
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
                                                    color:
                                                        Palette.separatorColor,
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
                                                    color:
                                                        Palette.separatorColor,
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
                                onPressed: () {},
                                color: _isButtonDisabled
                                    ? Palette.subTitleColor
                                    : Palette.redOrange,
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
                      new TextSpan(style: StyleFactory.hintStyle, text: "已注册？"),
                      new TextSpan(style: StyleFactory.hyperText, text: "去登录")
                    ])),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
        )));
  }

  @override
  void dispose() {
    timer.cancel();
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
