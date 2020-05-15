import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/coupon_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/push/push_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _accountNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _errorMessageVisible = false;
  bool _enableButton = false;
  bool _obscureText = true;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
          body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 45),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SvgPicture.asset(
                        R.resAssetsIconsBbblog,
                        width: 38,
                        height: 26,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Palette.appGrey.withOpacity(0.3),
                        ),
                      )
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 44),
                      child: Text(I18n.of(context).loginTitle, style: StyleNewFactory.black26)),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      I18n.of(context).loginProtectPassword,
                      style: TextStyle(
                        color: Palette.appGrey.withOpacity(0.6),
                        fontSize: Dimen.fontSize12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: _accountNameController,
                    decoration: InputDecoration(
                      hintText: I18n.of(context).accountName,
                      hintStyle: TextStyle(
                        color: Palette.appGrey.withOpacity(0.6),
                        fontSize: Dimen.fontSize15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _accountNameController.clear();
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Palette.appGrey.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Palette.appGrey.withOpacity(0.1))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Palette.appGrey.withOpacity(0.1))),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  TextField(
                    obscureText: _obscureText,
                    enableInteractiveSelection: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: I18n.of(context).password,
                      hintStyle: TextStyle(
                        color: Palette.appGrey.withOpacity(0.6),
                        fontSize: Dimen.fontSize15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Palette.appGrey.withOpacity(0.1))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Palette.appGrey.withOpacity(0.1))),
                      suffixIcon: SizedBox(
                        width: 96,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 0),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility,
                              ),
                              color: Palette.appGrey.withOpacity(0.3),
                            ),
                            IconButton(
                              onPressed: () {
                                _passwordController.clear();
                              },
                              icon: Icon(Icons.cancel),
                              color: Palette.appGrey.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _errorMessageVisible,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(R.resAssetsIconsIcWarn),
                          Text(
                            _errorMessage,
                            style: StyleFactory.errorMessageText,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(top: 25),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: WidgetFactory.button(
                            onPressed: _enableButton
                                ? () async {
                                    showLoading(context, isBarrierDismissible: true);
                                    try {
                                      if (await userLocator.loginWith(
                                          name: _accountNameController.text,
                                          password: _passwordController.text)) {
                                        userLocator.fetchBalances(
                                            name: _accountNameController.text);
                                        locator.get<CouponViewModel>().getCoupons();
                                        int expir =
                                            DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
                                        int timeout = expir + 5 * 60;

                                        locator.get<PushApi>().registerPush(
                                            regId: locator.get<RefManager>().pushRegId,
                                            accountName: _accountNameController.text,
                                            timeout: timeout);
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      } else {
                                        setState(() {
                                          _errorMessageVisible = true;
                                          _errorMessage = I18n.of(context).accountLogInError;
                                        });
                                        Navigator.of(context).maybePop();
                                      }
                                    } catch (error) {
                                      if (error is DioError) {
                                        setState(() {
                                          _errorMessageVisible = true;
                                          _errorMessage = "网络错误请重试";
                                        });
                                      } else {
                                        setState(() {
                                          _errorMessageVisible = true;
                                          _errorMessage = I18n.of(context).accountLogInError;
                                        });
                                      }
                                      Navigator.of(context).maybePop();
                                    }
                                  }
                                : () {},
                            color: _enableButton
                                ? Palette.redOrange
                                : Palette.appGrey.withOpacity(0.2),
                            data: I18n.of(context).logIn),
                      )),
                  // GestureDetector(
                  //   child: Container(
                  //       alignment: Alignment.center,
                  //       width: 200,
                  //       margin: EdgeInsets.only(top: 20),
                  //       padding: EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Palette.redOrange),
                  //         borderRadius: BorderRadius.all(Radius.circular(4.0) //
                  //             ),
                  //       ),
                  //       child: Text(
                  //         I18n.of(context).clickToTry,
                  //         style: StyleFactory.buyUpOrderInfo,
                  //       )),
                  //   onTap: () async {
                  //     if (await userLocator.loginWithPrivateKey(
                  //         bonusEvent: false)) {
                  //       showNotification(
                  //           context, false, I18n.of(context).changeToTryEnv,
                  //           callback: () {
                  //         Navigator.of(context)
                  //             .popUntil((route) => route.isFirst);
                  //       });
                  //     } else {
                  //       showNotification(
                  //           context, true, I18n.of(context).changeToTryEnv,
                  //           callback: () {
                  //         Navigator.of(context)
                  //             .popUntil((route) => route.isFirst);
                  //       });
                  //     }
                  //   },
                  // ),
                  SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    child: Text(
                      I18n.of(context).createNewAccount,
                      style: TextStyle(
                        color: Palette.appGrey.withOpacity(0.6),
                        fontSize: Dimen.fontSize15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.Register);
                    },
                  ),
                ],
              )),
        ),
      )),
    );
  }
}
