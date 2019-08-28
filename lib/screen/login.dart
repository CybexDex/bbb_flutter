import 'package:bbb_flutter/helper/show_dialog_utils.dart';
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
  bool _enableButton = false;
  String _errorMessage = "";
  var userLocator = locator<UserManager>();
  @override
  void initState() {
    _passwordController.addListener(() {
      if (_passwordController.text.length > 0) {
        setState(() {
          _enableButton = true;
        });
      } else {
        setState(() {
          _enableButton = false;
        });
      }
    });
    super.initState();
  }

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
                                                R.resAssetsIconsIcUser),
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
                                          enableInteractiveSelection: true,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                              hintText: I18n.of(context)
                                                  .passwordConfirm,
                                              hintStyle: StyleFactory.hintStyle,
                                              icon: Image.asset(
                                                  R.resAssetsIconsIcPassword),
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
                                  onPressed: _enableButton
                                      ? () async {
                                          setState(() {
                                            _loadingVisibility = true;
                                          });
                                          if (await userLocator.loginWith(
                                              name: _accountNameController.text,
                                              password:
                                                  _passwordController.text)) {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          } else {
                                            setState(() {
                                              _errorMessageVisible = true;
                                              _errorMessage = I18n.of(context)
                                                  .accountLogInError;
                                            });
                                          }
                                          setState(() {
                                            _loadingVisibility = false;
                                          });
                                        }
                                      : () {},
                                  color: _enableButton
                                      ? Palette.redOrange
                                      : Palette.subTitleColor,
                                  data: I18n.of(context).logIn),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Palette.redOrange),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0) //
                                    ),
                          ),
                          child: Text(
                            I18n.of(context).clickToTry,
                            style: StyleFactory.buyUpOrderInfo,
                          )),
                      onTap: () async {
                        if (await userLocator.loginWithPrivateKey(
                            bonusEvent: false)) {
                          showToast(
                              context, false, I18n.of(context).changeToTryEnv,
                              callback: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
                        } else {
                          showToast(
                              context, true, I18n.of(context).changeToTryEnv,
                              callback: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 40,
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
