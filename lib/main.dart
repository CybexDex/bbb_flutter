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
import 'dart:async';
import 'package:flutter/services.dart';

import 'colors/palette.dart';

main() async {
  Env.apiClient = BBBAPIProvider();
  Routes.register();

  var injector = InjectorWidget(child: MyApp());
  // assume that the `init` method is an async operation
  await injector.init();

  runApp(injector);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
