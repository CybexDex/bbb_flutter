import 'dart:convert';
import 'dart:io';

import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/pages/exchange.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/websocket/websocket_bloc.dart';
import 'package:bbb_flutter/widgets/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_socket_channel/io.dart';

import 'models/request/web_socket_request_entity.dart';

main() async {
  initLogger(package: 'bbb');
  Env.apiClient = BBBAPIProvider();
  Routes.register();

  var injector = InjectorWidget(child: MyApp());
  // assume that the `init` method is an async operation
  await injector.init();
  runApp(injector);
  WebSocketBloc webSocketBloc = new WebSocketBloc();
  webSocketBloc.initCommunication();
  webSocketBloc.send(jsonEncode(
          WebSocketRequestEntity(type: "subscribe", topic: "FAIRPRICE.BXBT"))
      .toString());

  if (Platform.isAndroid) {
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
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
      localizationsDelegates: [I18n.delegate],
      locale: Locale("en"),
      supportedLocales: [
        const Locale("en"),
        const Locale("zh"),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return Locale("en");
      },
      home: ExchangePage(
        title: '.BXBT',
      ),
    );
  }
}
