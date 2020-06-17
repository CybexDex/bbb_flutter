import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/coupon/coupon_page.dart';
import 'package:bbb_flutter/screen/deposit.dart';
import 'package:bbb_flutter/screen/feedback.dart';
import 'package:bbb_flutter/screen/finger_print_reminder.dart';
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
import 'package:oktoast/oktoast.dart';

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
  static const String WebView = "WebView";
  static const String Forum = "Forum";
  static const String OrderHome = "OrderHome";
  static const String Setting = "Setting";
  static const String LimitOrder = "LimitOrder";
  static const String Coupon = "Coupon";
  static const String FingerPrint = "FingerPrint";
}

class Routes {
  static String parameter;
  static open(BuildContext context, {Object arguments}) {
    if (parameter == null || parameter.isEmpty) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(parameter, (route) => route.isFirst, arguments: arguments);
      parameter = null;
    }
  }

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
        if (locator.get<UserManager>().user.testAccountResponseModel != null) {
          showToast(I18n.of(globalKey.currentContext).toastFormalAccount,
              textPadding: EdgeInsets.all(20));
          break;
        }
        if (!locator.get<UserManager>().depositAvailable) {
          showToast(I18n.of(globalKey.currentContext).toastDeposit,
              textPadding: EdgeInsets.all(20));
          break;
        }
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => DepositPage(), settings: settings);
        }
        parameter = RoutePaths.Deposit;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.OrderRecords:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => OrderRecordsWidget(), settings: settings);
        }
        parameter = RoutePaths.OrderRecords;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.FundRecords:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => FundRecordsWidget(), settings: settings);
        }
        parameter = RoutePaths.FundRecords;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.LimitOrderRecords:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => LimitOrderRecordsPage(), settings: settings);
        }
        parameter = RoutePaths.LimitOrderRecords;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.OrderRecordDetail:
        return CupertinoPageRoute(builder: (_) => OrderRecordDetail(), settings: settings);
      case RoutePaths.Transfer:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => TransferPage(), settings: settings);
        }
        parameter = RoutePaths.Transfer;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Withdraw:
        if (locator.get<UserManager>().user.testAccountResponseModel != null) {
          showToast(I18n.of(globalKey.currentContext).toastFormalAccount,
              textPadding: EdgeInsets.all(20));
          break;
        }
        if (!locator.get<UserManager>().withdrawAvailable) {
          showToast(I18n.of(globalKey.currentContext).toastWithdraw,
              textPadding: EdgeInsets.all(20));
          break;
        }
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => WithdrawPage(), settings: settings);
        }
        parameter = RoutePaths.Withdraw;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Invite:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => InvitePage(), settings: settings);
        }
        parameter = RoutePaths.Invite;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Trade:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => TradeHomePage(), settings: settings);
        }
        parameter = RoutePaths.Trade;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Feedback:
        return CupertinoPageRoute(builder: (_) => FeedBackScreen(), settings: settings);
      case RoutePaths.WebView:
        dynamic param = settings.arguments;
        if (param['needLogIn'] != null &&
            param['needLogIn'] &&
            locator.get<UserManager>().user.testAccountResponseModel != null) {
          showToast(I18n.of(globalKey.currentContext).toastFormalAccount,
              textPadding: EdgeInsets.all(20));
          break;
        }
        if ((param['needLogIn'] == null || !param['needLogIn']) ||
            (param['needLogIn'] && locator.get<UserManager>().user.logined)) {
          return CupertinoPageRoute(builder: (_) => WebViewPage(), settings: settings);
        }
        parameter = RoutePaths.WebView;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.Share:
        return CupertinoPageRoute(builder: (_) => SharePage(), settings: settings);
      case RoutePaths.Forum:
        return CupertinoPageRoute(builder: (_) => ForumHome(), settings: settings);
      case RoutePaths.OrderHome:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => OrderHome(), settings: settings);
        }
        parameter = RoutePaths.OrderHome;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);

      case RoutePaths.Setting:
        return CupertinoPageRoute(builder: (_) => SettingWiget(), settings: settings);
      case RoutePaths.LimitOrder:
        return CupertinoPageRoute(builder: (_) => LimitOrderPage(), settings: settings);
      case RoutePaths.Coupon:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => CouponPage(), settings: settings);
        }
        parameter = RoutePaths.Coupon;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.TransferRecords:
        return CupertinoPageRoute(builder: (_) => TransferRecordsWidget(), settings: settings);
      case RoutePaths.RewardRecords:
        if (locator.get<UserManager>().user.logined) {
          return CupertinoPageRoute(builder: (_) => RewardRecordsWidget(), settings: settings);
        }
        parameter = RoutePaths.RewardRecords;
        return CupertinoPageRoute(builder: (_) => LoginPage(), settings: settings);
      case RoutePaths.FingerPrint:
        return CupertinoPageRoute(builder: (_) => FingerPrintReminderPage(), settings: settings);
      default:
        return CupertinoPageRoute(
            builder: (context) {
              ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
              return MainPage();
            },
            settings: settings);
    }
  }
}
