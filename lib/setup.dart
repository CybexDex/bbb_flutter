import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/cache/user_ops.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api_provider.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api_provider.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:bbb_flutter/services/network/refer/refer_api_provider.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'services/network/faucet/faucet_api.dart';

GetIt locator = GetIt();
List<SingleChildCloneableWidget> providers = [];
final globalKey = GlobalKey();

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
  locator.registerSingleton(pref);
  locator.registerSingleton(TimerManager());
  locator.registerSingleton(getLogger("BBB"));
  locator.registerSingleton<BBBAPI>(
      BBBAPIProvider(sharedPref: locator<SharedPref>()));
  locator.registerSingleton<GatewayApi>(GatewayAPIProvider());
  locator.registerSingleton<ReferApi>(ReferApiProvider());
  locator.registerSingleton<FaucetAPI>(FaucetAPIProvider());
  locator.registerSingleton(MarketManager(api: locator<BBBAPI>()));
  locator.registerSingleton(RefManager(api: locator<BBBAPI>()));

  locator.registerLazySingleton(() => UserManager(
      api: locator<BBBAPI>(),
      pref: locator<SharedPref>(),
      user: loadUserFromCache(locator<SharedPref>())));

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
      builder: (context) => locator.get<RefManager>().data,
    ),
    StreamProvider(
      builder: (context) => locator.get<TimerManager>().tick,
    )
  ];
}
