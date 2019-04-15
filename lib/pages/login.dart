import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/generated/i18n.dart';
import 'package:flutter/material.dart';

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
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            WidgetFactory.pageTopContainer(),
            AppBar(
              centerTitle: true,
              title: Text(S.of(context).log_in, style: StyleFactory.title),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            SafeArea(
              child: Container(
                  margin: Dimen.pageMargin,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: DecorationFactory.cornerShadowDecoration,
                        height: 457,
                        margin: EdgeInsets.only(top: 54),
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 40)),
                            Image.asset("res/assets/icons/icAccount.png"),
                            Expanded(
                                child: ListView(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    children: <Widget>[
                                  Column(children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(S.of(context).account_name,
                                          style: StyleFactory.loginFontStyle),
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText:
                                              S.of(context).account_name_hint),
                                    ),
                                  ]),
                                  Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(S.of(context).password,
                                            style: StyleFactory.loginFontStyle),
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            hintText:
                                                S.of(context).password_confirm),
                                      )
                                    ],
                                  )
                                ]))
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }
}
