import 'package:bbb_flutter/screen/deposit.dart';
import 'package:bbb_flutter/screen/exchange/exchange.dart';
import 'package:bbb_flutter/screen/fund_records.dart';
import 'package:bbb_flutter/screen/login.dart';
import 'package:bbb_flutter/screen/order_record_detail.dart';
import 'package:bbb_flutter/screen/order_records.dart';
import 'package:bbb_flutter/screen/register.dart';
import 'package:bbb_flutter/screen/trade.dart';
import 'package:bbb_flutter/screen/transfer_page.dart';
import 'package:bbb_flutter/screen/withdraw_page.dart';
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
  static const String FundRecords = "FundRecords";
  static const String OrderRecords = "OrderRecords";
  static const String Transfer = "Transfer";
  static const String Withdraw = "Withdraw";
  static const String OrderRecordDetail = "OrderRecordDetail";
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
      case RoutePaths.OrderRecords:
        return CupertinoPageRoute(builder: (_) => OrderRecordsWidget());
      case RoutePaths.FundRecords:
        return CupertinoPageRoute(builder: (_) => FundRecordsWidget());
      case RoutePaths.OrderRecordDetail:
        return CupertinoPageRoute(
            builder: (_) => OrderRecordDetail(), settings: settings);
      case RoutePaths.Transfer:
        return CupertinoPageRoute(builder: (_) => TransferPage());
      case RoutePaths.Withdraw:
        return CupertinoPageRoute(builder: (_) => WithdrawPage());

      case RoutePaths.Trade:
        return CupertinoPageRoute(
            builder: (_) => TradePage(), settings: settings);

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
