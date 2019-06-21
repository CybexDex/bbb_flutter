import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/cache/user_ops.dart';
import 'package:bbb_flutter/helper/log_helper.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/services/network/faucet/faucet_api_provider.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

setupLocator() async {
  locator.registerSingleton(Log(package: "BBB"));
  locator.registerSingleton(BBBAPIProvider());
  locator.registerSingleton(FaucetAPIProvider());
  locator.registerSingleton(MarketManager(api: locator<BBBAPIProvider>()));
  locator.registerSingleton(RefManager(api: locator<BBBAPIProvider>()));
  var pref = await SharedPref.create();
  locator.registerSingleton(pref);

  locator.registerLazySingleton(() => UserManager(
      api: locator<BBBAPIProvider>(),
      pref: locator<SharedPref>(),
      user: loadUserFromCache(locator<SharedPref>())));

  locator.registerLazySingleton(() => TradeViewModel(
      api: locator<BBBAPIProvider>(),
      mtm: locator<MarketManager>(),
      refm: locator<RefManager>(),
      um: locator<UserManager>()));

  locator.registerLazySingleton(
      () => OrderViewModel(api: locator<BBBAPIProvider>()));
}
