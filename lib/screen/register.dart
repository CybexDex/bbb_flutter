import 'dart:ui';

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/register_vm.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class RegisterPage extends StatefulWidget {
  final String title;

  RegisterPage({Key key, this.title}) : super(key: key);

  @override
  State createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _accountNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _pinCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RegisterViewModel>(
      model: RegisterViewModel(
          bbbapi: locator.get(),
          faucetAPI: locator.get(),
          userManager: locator.get(),
          buildContext: context),
      builder: (context, registerViewModel, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
              body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
              margin: EdgeInsets.only(
                  left: 50, right: 50, top: ScreenUtil.getInstance().setHeight(41), bottom: 58),
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
                      child:
                          Text(I18n.of(context).welcomeRegister, style: StyleNewFactory.black26)),
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
                    height: 30,
                  ),

                  TextField(
                    autocorrect: false,
                    controller: _accountNameController,
                    onChanged: (value) {
                      registerViewModel.checkAccountName(value, _pinCodeController.text,
                          _passwordController.text, _passwordConfirmController.text);
                    },
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
                    height: 18,
                  ),
                  TextField(
                    obscureText: registerViewModel.passwordObscureText,
                    enableInteractiveSelection: true,
                    controller: _passwordController,
                    onChanged: (value) {
                      registerViewModel.checkPassword(value, _passwordConfirmController.text,
                          _accountNameController.text, _pinCodeController.text);
                    },
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
                              onPressed: registerViewModel.setPasswordObscure,
                              icon: Icon(
                                registerViewModel.passwordObscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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

                  SizedBox(
                    height: 18,
                  ),

                  TextField(
                    obscureText: registerViewModel.passwordConfirmObscureText,
                    enableInteractiveSelection: true,
                    controller: _passwordConfirmController,
                    onChanged: (value) {
                      registerViewModel.checkPasswordConfirmation(value, _passwordController.text,
                          _accountNameController.text, _pinCodeController.text);
                    },
                    decoration: InputDecoration(
                      hintText: I18n.of(context).passwordConfirm,
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
                              onPressed: registerViewModel.setPasswordConfirmObscure,
                              icon: Icon(
                                registerViewModel.passwordConfirmObscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              color: Palette.appGrey.withOpacity(0.3),
                            ),
                            IconButton(
                              onPressed: () {
                                _passwordConfirmController.clear();
                              },
                              icon: Icon(Icons.cancel),
                              color: Palette.appGrey.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _pinCodeController,
                              onChanged: registerViewModel.checkPinCode,
                              decoration: InputDecoration(
                                hintText: I18n.of(context).pinCode,
                                hintStyle: TextStyle(
                                  color: Palette.appGrey.withOpacity(0.6),
                                  fontSize: Dimen.fontSize15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _pinCodeController.clear();
                                  },
                                  icon: Icon(Icons.cancel),
                                  color: Palette.appGrey.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: registerViewModel.rawSvg != null
                                ? Column(
                                    children: <Widget>[
                                      SvgPicture.string(
                                        registerViewModel.rawSvg,
                                        width: 45,
                                        height: 25,
                                      ),
                                      Text(I18n.of(context).registerChangePinCode,
                                          style: StyleNewFactory.grey9)
                                    ],
                                  )
                                : registerViewModel.showPinCodeLoading
                                    ? SpinKitCircle(
                                        size: 24,
                                        color: Palette.appYellowOrange,
                                      )
                                    : Text(
                                        I18n.of(context).registerGetPinCode,
                                        style: StyleFactory.pinCodeText,
                                      ),
                            onTap: registerViewModel.displaySvg,
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Palette.separatorColor, width: 0.5))),
                      )
                    ],
                  ),

                  Visibility(
                    visible: registerViewModel.errorMessageVisibility,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(R.resAssetsIconsIcWarn),
                          Flexible(
                            child: Text(
                              registerViewModel.errorMessage,
                              style: StyleFactory.errorMessageText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(top: 28),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: WidgetFactory.button(
                            onPressed: registerViewModel.isButtonEnabled
                                ? () async {
                                    showLoading(context);
                                    await registerViewModel.processRegister(
                                        accountName: _accountNameController.text,
                                        password: _passwordController.text,
                                        pinCode: _pinCodeController.text);
                                  }
                                : () {},
                            color: registerViewModel.isButtonEnabled
                                ? Palette.redOrange
                                : Palette.appGrey.withOpacity(0.2),
                            data: I18n.of(context).register),
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
                  //     if (await locator
                  //         .get<UserManager>()
                  //         .loginWithPrivateKey(bonusEvent: false)) {
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
                    height: 35,
                  ),
                  GestureDetector(
                    child: RichText(
                        text: new TextSpan(children: [
                      new TextSpan(
                          style: TextStyle(
                            color: Palette.appGrey.withOpacity(0.6),
                            fontSize: Dimen.fontSize15,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0,
                          ),
                          text: I18n.of(context).alreadyRegister),
                      new TextSpan(
                          style: StyleNewFactory.yellowOrange15, text: I18n.of(context).logIn)
                    ])),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )),
          )),
        );
      },
    );
  }

  @override
  void dispose() {
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
