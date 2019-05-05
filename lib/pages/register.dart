import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/env.dart';
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
  void dispose() {
    timer.cancel();
    super.dispose();
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
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: DecorationFactory.cornerShadowDecoration,
                        height: 310,
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
                                      child: Text(
                                        "欢迎注册您的账户!",
                                        style: StyleFactory.title,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
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
                                                  color: Palette.separatorColor,
                                                  width: 0.5))),
                                    )
                                  ]),
                                  Column(
                                    children: <Widget>[
                                      TextField(
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
                                      TextField(
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
                                            child: TextField(
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
                          margin: EdgeInsets.only(top: 300),
                          child: ButtonTheme(
                            minWidth: 200,
                            child: WidgetFactory.button(
                                onPressed: () {},
                                color: Palette.redOrange,
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
                      router.navigateTo(context, "/login",
                          transition: TransitionType.inFromLeft);
                    },
                  )
                ],
              )),
        ));
  }
}
