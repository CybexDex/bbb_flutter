import 'package:bbb_flutter/pages/exchange.dart';
import 'package:bbb_flutter/pages/login.dart';
import 'package:bbb_flutter/pages/register.dart';
import 'package:bbb_flutter/pages/trade.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final router = Router();

class Routes {
  // router.navigateTo(context, "/trade", transition: TransitionType.fadeIn);
  static register() {
    var tradeHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return TradePage(isUp: params["isUp"][0]);
    });

    router.define("/trade/:isUp", handler: tradeHandler);

    var loginHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginPage();
    });

    router.define("/login", handler: loginHandler);

    var registerHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return RegisterPage();
    });

    router.define("/register", handler: registerHandler);
  }
}
