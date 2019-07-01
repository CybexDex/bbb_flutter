import 'dart:convert';
import 'dart:io';

import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'manager/ref_manager.dart';
import 'models/request/web_socket_request_entity.dart';
import 'manager/timer_manager.dart';

main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  setupLog();
  await setupLocator();
  setupProviders();

  runApp(MyApp());

  if (locator.get<UserManager>().user.logined) {
    locator
        .get<UserManager>()
        .fetchBalances(name: locator.get<UserManager>().user.account.name);
  }
  await locator.get<RefManager>().firstLoadData();
  locator.get<MarketManager>().loadAllData("BXBT");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BBB',
          localizationsDelegates: [I18n.delegate],
          locale: Locale("en"),
          supportedLocales: [
            const Locale("en"),
            const Locale("zh"),
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return Locale("en");
          },
          initialRoute: RoutePaths.Home,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}
