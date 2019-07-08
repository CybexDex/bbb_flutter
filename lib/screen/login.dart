import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _accountNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _errorMessageVisible = false;
  bool _loadingVisibility = false;
  String _errorMessage = "";
  var userLocator = locator<UserManager>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).logIn, style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
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
                                          child: Visibility(
                                            visible: !_errorMessageVisible,
                                            child: Text(
                                              "欢迎登录您的账户!",
                                              style: StyleFactory.title,
                                            ),
                                            replacement: Text(_errorMessage,
                                                style: StyleFactory
                                                    .errorMessageText),
                                          )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextField(
                                        autocorrect: false,
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
                                        TextField(
                                          obscureText: true,
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
                                  onPressed: () async {
                                    setState(() {
                                      _loadingVisibility = true;
                                    });
                                    if (await userLocator.loginWith(
                                        name: _accountNameController.text,
                                        password: _passwordController.text)) {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    } else {
                                      setState(() {
                                        _errorMessageVisible = true;
                                        _errorMessage =
                                            I18n.of(context).accountLogInError;
                                      });
                                    }
                                    setState(() {
                                      _loadingVisibility = false;
                                    });
                                  },
                                  color: Palette.redOrange,
                                  data: I18n.of(context).logIn),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      child: Text(
                        I18n.of(context).createNewAccount,
                        style: StyleFactory.hyperText,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.Register);
                      },
                    ),
                    Visibility(
                      visible: _loadingVisibility,
                      child: SpinKitWave(
                        color: Palette.redOrange,
                        size: 50,
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
