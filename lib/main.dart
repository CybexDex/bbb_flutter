import 'dart:io';

import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/generated/i18n.dart';
import 'package:bbb_flutter/pages/exchange.dart';
import 'package:bbb_flutter/pages/login.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/BBBAPIProvider.dart';
import 'package:bbb_flutter/widgets/injector.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

main() async {
  initLogger(package: 'bbb');
  Env.apiClient = BBBAPIProvider();
  Routes.register();

  var injector = InjectorWidget(child: MyApp());
  // assume that the `init` method is an async operation
  await injector.init();

  runApp(injector);

  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BBB',
      localizationsDelegates: const <
          LocalizationsDelegate<WidgetsLocalizations>>[S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
          S.delegate.resolution(fallback: const Locale('en', '')),
      home: ExchangePage(title: '.BXBT'),
    );
  }
}
