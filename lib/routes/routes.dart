import 'package:bbb_flutter/screen/allLimitOrders/all_limit_orders.dart';
import 'package:bbb_flutter/screen/allOrders/all_orders.dart';
import 'package:bbb_flutter/screen/coupon/coupon_page.dart';
import 'package:bbb_flutter/screen/coupon/coupon_rule.dart';
import 'package:bbb_flutter/screen/deposit.dart';
import 'package:bbb_flutter/screen/feedback.dart';
import 'package:bbb_flutter/screen/forum/forum_home.dart';
import 'package:bbb_flutter/screen/fund_records.dart';
import 'package:bbb_flutter/screen/help_center.dart';
import 'package:bbb_flutter/screen/homeNav.dart';
import 'package:bbb_flutter/screen/invite_page.dart';
import 'package:bbb_flutter/screen/limit_order/limit_order.dart';
import 'package:bbb_flutter/screen/limit_order_records.dart';
import 'package:bbb_flutter/screen/login.dart';
import 'package:bbb_flutter/screen/order_home.dart';
import 'package:bbb_flutter/screen/order_record_detail.dart';
import 'package:bbb_flutter/screen/order_records.dart';
import 'package:bbb_flutter/screen/register.dart';
import 'package:bbb_flutter/screen/reward_records.dart';
import 'package:bbb_flutter/screen/setting_page.dart';
import 'package:bbb_flutter/screen/share_page.dart';
import 'package:bbb_flutter/screen/trade/trade_home_page.dart';
import 'package:bbb_flutter/screen/transfer_page.dart';
import 'package:bbb_flutter/screen/transfer_records.dart';
import 'package:bbb_flutter/screen/withdraw_page.dart';
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
  static const String LimitOrderRecords = "LimitOrderRecords";
  static const String TransferRecords = "TransferRecords";
  static const String RewardRecords = "RewardRecords";
  static const String Transfer = "Transfer";
  static const String Withdraw = "Withdraw";
  static const String OrderRecordDetail = "OrderRecordDetail";
  static const String Invite = "Invite";
  static const String Feedback = "feedback";
  static const String Share = "Share";
  static const String Help = "Help";
  static const String Forum = "Forum";
  static const String AllOrders = "AllOrders";
  static const String AllLimitOrders = "AllLimitOrders";
  static const String OrderHome = "OrderHome";
  static const String Setting = "Setting";
  static const String LimitOrder = "LimitOrder";
  static const String SplashScreen = "SplashScreen";
  static const String Coupon = "Coupon";
  static const String CouponRules = "CouponRules";
  static const String inviteRules = "InviteRules";
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return CupertinoPageRoute(
            builder: (context) {
              ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
              return MainPage();
            },
            settings: settings);
      case RoutePaths.Login:
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Register:
        return CupertinoPageRoute(builder: (_) => RegisterPage(), settings: settings);
      case RoutePaths.Deposit:
        return CupertinoPageRoute(builder: (_) => DepositPage(), settings: settings);
      case RoutePaths.OrderRecords:
        return CupertinoPageRoute(builder: (_) => OrderRecordsWidget(), settings: settings);
      case RoutePaths.FundRecords:
        return CupertinoPageRoute(builder: (_) => FundRecordsWidget(), settings: settings);
      case RoutePaths.LimitOrderRecords:
        return CupertinoPageRoute(builder: (_) => LimitOrderRecordsPage(), settings: settings);

      case RoutePaths.OrderRecordDetail:
        return CupertinoPageRoute(builder: (_) => OrderRecordDetail(), settings: settings);
      case RoutePaths.Transfer:
        return CupertinoPageRoute(builder: (_) => TransferPage(), settings: settings);
      case RoutePaths.Withdraw:
        return CupertinoPageRoute(builder: (_) => WithdrawPage(), settings: settings);
      case RoutePaths.Invite:
        return CupertinoPageRoute(builder: (_) => InvitePage(), settings: settings);
      case RoutePaths.Trade:
        return CupertinoPageRoute(builder: (_) => TradeHomePage(), settings: settings);
      case RoutePaths.Feedback:
        return CupertinoPageRoute(builder: (_) => FeedBackScreen(), settings: settings);
      case RoutePaths.Help:
        return CupertinoPageRoute(
            fullscreenDialog: true, builder: (_) => HelpCenterScreen(), settings: settings);
      case RoutePaths.Share:
        return CupertinoPageRoute(builder: (_) => SharePage(), settings: settings);
      case RoutePaths.Forum:
        return CupertinoPageRoute(builder: (_) => ForumHome(), settings: settings);
      case RoutePaths.AllOrders:
        return CupertinoPageRoute(builder: (_) => AllOrdersPage(), settings: settings);
      case RoutePaths.AllLimitOrders:
        return CupertinoPageRoute(builder: (_) => AllLimitOrderPage(), settings: settings);
      case RoutePaths.OrderHome:
        return CupertinoPageRoute(builder: (_) => OrderHome(), settings: settings);
      case RoutePaths.Setting:
        return CupertinoPageRoute(builder: (_) => SettingWiget(), settings: settings);
      case RoutePaths.LimitOrder:
        return CupertinoPageRoute(builder: (_) => LimitOrderPage(), settings: settings);
      case RoutePaths.Coupon:
        return CupertinoPageRoute(builder: (_) => CouponPage(), settings: settings);
      case RoutePaths.CouponRules:
        return CupertinoPageRoute(builder: (_) => CouponRulePage(), settings: settings);
      case RoutePaths.TransferRecords:
        return CupertinoPageRoute(builder: (_) => TransferRecordsWidget(), settings: settings);
      case RoutePaths.RewardRecords:
        return CupertinoPageRoute(builder: (_) => RewardRecordsWidget(), settings: settings);
      // case RoutePaths.inviteRules:
      // return CupertinoPageRoute(builder: (_) => )
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
