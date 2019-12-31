import 'dart:io';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/cache/user_ops.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/logic/account_vm.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api_provider.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api_provider.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api_provider.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api_provider.dart';
import 'package:bbb_flutter/services/network/node/node_api.dart';
import 'package:bbb_flutter/services/network/node/node_api_provider.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:bbb_flutter/services/network/refer/refer_api_provider.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api_provider.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:dio/dio.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:package_info/package_info.dart';

import 'screen/home/home_view_model.dart';
import 'services/network/zendesk/zendesk_api.dart';

GetIt locator = GetIt();
List<SingleChildCloneableWidget> providers = [];
final globalKey = GlobalKey();
GlobalKey navGlobaykey = GlobalKey();
final flutterWebViewPlugin = FlutterWebviewPlugin();

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var color = PrettyPrinter.levelColors[level];
    var emoji = PrettyPrinter.levelEmojis[level];
    println(color('$emoji $className - $message'));
  }
}

setupLog() {
  Logger.level = Level.verbose;
}

Logger getLogger(String className) {
  return Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: false,
    printEmojis: true,
    printTime: true,
  ));
}

setupLocator() async {
  var pref = await SharedPref.create();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  locator.registerSingleton(packageInfo);
  locator.registerSingleton(pref);
  locator.registerSingleton(TimerManager());
  locator.registerSingleton(getLogger("BBB"));
  locator.registerSingleton<BBBAPI>(
      BBBAPIProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<GatewayApi>(
      GatewayAPIProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<ReferApi>(
      ReferApiProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<FaucetAPI>(
      FaucetAPIProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<ConfigureApi>(
      ConfiguireApiProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton(
      MarketManager(api: locator<BBBAPI>(), sharedPref: locator<SharedPref>()));
  locator.registerSingleton(RefManager(api: locator<BBBAPI>()));
  locator.registerSingleton<NodeApi>(
      NodeApiProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<ForumApi>(
      ForumApiProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<ZendeskApi>(ZendeskApiProvider());

  locator.registerLazySingleton(() => UserManager(
      api: locator<BBBAPI>(),
      pref: locator<SharedPref>(),
      user: loadUserFromCache(locator<SharedPref>())));

  locator.registerLazySingleton(() => HomeViewModel(
      bbbapi: locator.get(),
      forumApi: locator.get(),
      configureApi: locator.get(),
      zendeskApi: locator.get(),
      gatewayApi: locator.get(),
      userManager: locator.get()));

  locator.registerLazySingleton(
      () => AccountViewModel(bbbapi: locator.get(), gatewayApi: locator.get()));

  locator.registerFactory(() => TradeViewModel(
      api: locator<BBBAPI>(),
      mtm: locator<MarketManager>(),
      refm: locator<RefManager>(),
      um: locator<UserManager>()));

  locator.registerFactory(() => OrderViewModel(
      api: locator<BBBAPI>(),
      um: locator<UserManager>(),
      rm: locator<RefManager>()));
}

setupProviders() {
  providers = [
    ChangeNotifierProvider.value(
      value: locator.get<UserManager>(),
    ),
    StreamProvider(builder: (context) => locator.get<MarketManager>().prices),
    StreamProvider(
        builder: (context) => locator.get<MarketManager>().lastTicker.stream),
    StreamProvider(
        builder: (context) =>
            locator.get<MarketManager>().percentageTicker.stream),
    StreamProvider(
        builder: (context) => locator.get<MarketManager>().pnlTicker.stream),
    StreamProvider(
      builder: (context) => locator.get<RefManager>().data,
    ),
    StreamProvider(
      builder: (context) => locator.get<TimerManager>().tick,
    ),
    StreamProvider(
        builder: (context) => locator.get<MarketManager>().dailyPxTicker.stream)
  ];
}

setupProxy(Dio dio) {
  return;
  if (buildMode == BuildMode.release || Platform.isAndroid) {
    return;
  }
  String proxy = Platform.isAndroid ? '0.0.0.0:8888' : 'localhost:8888';

  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    // Hook into the findProxy callback to set the client's proxy.
    client.findProxy = (url) {
      return 'PROXY $proxy';
    };

    // This is a workaround to allow Charles to receive
    // SSL payloads when your app is running on Android.
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => Platform.isAndroid;
  };
}
