import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/env.dart';

class LoginPage extends StatefulWidget {
  final String title;

  LoginPage({Key key, this.title}) : super(key: key);

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text("登录", style: StyleFactory.title),
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
                        height: 200,
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
                                        "欢迎登录您的账户!",
                                        style: StyleFactory.title,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextField(
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
                                  )
                                ]))
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(top: 190),
                          child: ButtonTheme(
                            minWidth: 200,
                            child: WidgetFactory.button(
                                onPressed: () {},
                                color: Palette.redOrange,
                                data: "登录"),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    child: Text(
                      "创建新账户",
                      style: StyleFactory.hyperText,
                    ),
                    onTap: () {
                      router.navigateTo(context, "/register",
                          transition: TransitionType.inFromRight);
                    },
                  )
                ],
              )),
        ));
  }
}
