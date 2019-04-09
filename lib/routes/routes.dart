import 'package:bbb_flutter/pages/exchange.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final router = Router();

class Routes {
  // router.navigateTo(context, "/exchange", transition: TransitionType.fadeIn);
  static register() {
    var exchangeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ExchangePage();
    });

    router.define("/exchange", handler: exchangeHandler);
  }
}