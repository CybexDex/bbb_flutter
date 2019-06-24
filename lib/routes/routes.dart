import 'package:bbb_flutter/screen/deposit.dart';
import 'package:bbb_flutter/screen/exchange/exchange.dart';
import 'package:bbb_flutter/screen/login.dart';
import 'package:bbb_flutter/screen/register.dart';
import 'package:bbb_flutter/screen/trade.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutePaths {
  static const String Login = 'login';
  static const String Home = '/';
  static const String Register = 'register';
  static const String Trade = 'trade';
  static const String Deposit = 'deposit';
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return CupertinoPageRoute(builder: (context) {
          ScreenUtil.instance = ScreenUtil(width: 375, height: 667)
            ..init(context);
          return ExchangePage(title: '.BXBT');
        });
      case RoutePaths.Login:
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case RoutePaths.Register:
        return CupertinoPageRoute(builder: (_) => RegisterPage());
      case RoutePaths.Deposit:
        return CupertinoPageRoute(builder: (_) => DepositPage());

      case RoutePaths.Trade:
        RouteParamsOfTrade param = settings.arguments as RouteParamsOfTrade;
        return CupertinoPageRoute(
            builder: (_) => TradePage(
                  params: param,
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
