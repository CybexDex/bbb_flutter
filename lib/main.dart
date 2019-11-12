import 'dart:io';

import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/connection_widget.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_flipperkit/flutter_flipperkit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'manager/ref_manager.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (buildMode == BuildMode.debug) {
    // FlipperClient flipperClient = FlipperClient.getDefault();
    // flipperClient.addPlugin(new FlipperNetworkPlugin());
    // flipperClient.addPlugin(new FlipperSharedPreferencesPlugin());
    // flipperClient.start();
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    UMengAnalytics.init('5d8097684ca3578029000341',
        policy: Policy.BATCH, encrypt: true, reportCrash: false);
  } else if (Platform.isIOS) {
    UMengAnalytics.init('5d8098c90cafb277140006f7',
        policy: Policy.BATCH, encrypt: true, reportCrash: false);
  }

  setupLog();
  await setupLocator();
  setupProviders();

  CatcherOptions debugOptions =
      CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
    SentryHandler(
        "https://351353bdb8414e16a7799184219bb19b@sentry.nbltrust.com/19"),
  ]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
  // runApp(MyApp());
  if (locator.get<UserManager>().user.logined) {
    locator
        .get<UserManager>()
        .fetchBalances(name: locator.get<UserManager>().user.name);
  }
  await locator.get<RefManager>().firstLoadData();
  locator
      .get<MarketManager>()
      .loadAllData("BXBT", marketDuration: MarketDuration.oneMin);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: OKToast(
        child: ConnectionWidget(
          child: MaterialApp(
            navigatorKey: Catcher.navigatorKey,
            builder: (BuildContext context, Widget widget) {
              Catcher.addDefaultErrorWidget(
                  showStacktrace: true,
                  customTitle: " error title",
                  customDescription: " error description");
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
      ),
    );
  }
}
