import 'dart:convert';
import 'dart:io';

import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sentry/sentry.dart';
import 'manager/ref_manager.dart';

main() async {
  await Future.delayed(Duration(seconds: 1));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    FlutterUmplus.init('5d8097684ca3578029000341',
        reportCrash: false, logEnable: true, encrypt: true);
  } else if (Platform.isIOS) {
    FlutterUmplus.init('5d8098c90cafb277140006f7',
        reportCrash: false, logEnable: true, encrypt: true);
  }
  setupLog();
  await setupLocator();
  setupProviders();
  locator.get<JPush>().setup(appKey: "ac3739c30b71a1d301454eb6", production: false, debug: true);
  locator
      .get<JPush>()
      .applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: false));
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
    SentryHandler(
        SentryClient(dsn: "https://351353bdb8414e16a7799184219bb19b@sentry.nbltrust.com/19"))
  ]);
  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
  // runApp(MyApp());
  await locator.get<RefManager>().getActions();
  await locator.get<RefManager>().firstLoadData();
  locator.get<TimerManager>().start();
  if (locator.get<UserManager>().user.logined) {
    locator.get<UserManager>().fetchBalances(name: locator.get<UserManager>().user.name);
  }
  locator.get<MarketManager>().loadAllData("BXBT", marketDuration: MarketDuration.line);
  _handlePushCallback();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: OKToast(
        child: MaterialApp(
          color: Colors.red,
          navigatorKey: Catcher.navigatorKey,
          builder: (BuildContext context, Widget widget) {
            Catcher.addDefaultErrorWidget(
                showStacktrace: true, title: " error title", description: " error description");
            return widget;
          },
          debugShowCheckedModeBanner: false,
          title: 'BBB',
          localizationsDelegates: [
            RefreshLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          locale: Locale("zh"),
          supportedLocales: [
            const Locale("en"),
            const Locale("zh"),
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return Locale("zh");
          },
          initialRoute: RoutePaths.Home,
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}

_handlePushCallback() {
  locator.get<JPush>().getLaunchAppNotification().then((map) {
    if (map['page'] == RoutePaths.Trade) {
      Future.delayed(
          Duration.zero,
          () => Navigator.of(globalKey.currentContext).pushNamed(RoutePaths.Trade,
              arguments: RouteParamsOfTrade(isUp: true, isCoupon: false)));
    }
  });
  try {
    locator.get<JPush>().addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
      print("flutter onReceiveNotification: $message");
    }, onOpenNotification: (Map<String, dynamic> message) async {
      print("flutter onOpenNotification: $message");
      if (Platform.isAndroid) {
        Map<String, dynamic> map = json.decode(message['extras']['cn.jpush.android.EXTRA']);
        if (map['page'] == RoutePaths.Trade) {
          Navigator.of(globalKey.currentContext).pushNamedAndRemoveUntil(
              RoutePaths.Trade, (route) => route.isFirst,
              arguments: RouteParamsOfTrade(isUp: true, isCoupon: false));
        }
      } else {
        if (message['page'] == RoutePaths.Trade) {
          Navigator.of(globalKey.currentContext).pushNamedAndRemoveUntil(
              RoutePaths.Trade, (route) => route.isFirst,
              arguments: RouteParamsOfTrade(isUp: true, isCoupon: false));
        }
      }
    }, onReceiveMessage: (Map<String, dynamic> message) async {
      print("flutter onReceiveMessage: $message");
      if (message['page'] == RoutePaths.Trade) {
        Navigator.of(globalKey.currentContext).pushNamed(RoutePaths.Trade,
            arguments: RouteParamsOfTrade(isUp: true, isCoupon: false));
      }
    }, onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
      print("flutter onReceiveNotificationAuthorization: $message");
    });
  } on PlatformException {}
}
