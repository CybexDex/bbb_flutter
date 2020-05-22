import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar exchangeAppBar({BuildContext context}) {
  return AppBar(
    actions: <Widget>[
      Consumer<UserManager>(
          builder: (context, bloc, child) => GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                      child: SvgPicture.asset(
                    R.resAssetsIconsHoldAll,
                    width: 24,
                    height: 24,
                  )),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RoutePaths.OrderHome);
                },
              )),
    ],
    leading: GestureDetector(
      onTap: () {
        Scaffold.of(globalKey.currentContext).openDrawer();
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          R.resAssetsIconsIcDrawer,
          fit: BoxFit.contain,
        ),
      ),
    ),
    // Consumer<UserManager>(
    //     builder: (context, bloc, child) => GestureDetector(
    //           child: child,
    //           // : Padding(
    //           //     padding: EdgeInsets.all(16),
    //           //     child: SvgPicture.string(Jdenticon.toSvg(bloc.user.name),
    //           //         fit: BoxFit.contain, height: 20, width: 20),
    //           // ),
    //           onTap: () {
    //             if (bloc.user.logined) {
    //               bloc.fetchBalances(name: bloc.user.name);
    //               Scaffold.of(context).openDrawer();
    //             } else {
    //               Navigator.of(context).pushNamed(RoutePaths.Login);
    //             }
    //           },
    //         ),
    //     child:
    //         SvgPicture.asset(R.resAssetsIconsIcDrawer, width: 24, height: 24)),
    centerTitle: true,
    title: Consumer2<UserManager, TickerData>(
      builder: (context, bloc, ticker, child) {
        if (ticker == null) {
          return Text("${locator.get<SharedPref>().getAsset()}/USDT --", style: StyleFactory.title);
        }
        return bloc.user.loginType == LoginType.test
            ? Text("试玩 ${locator.get<SharedPref>().getAsset()}/USDT", style: StyleFactory.title)
            : Text(
                bloc.user.loginType == LoginType.reward
                    ? "奖励 ${locator.get<SharedPref>().getAsset()}/USDT"
                    : "${locator.get<SharedPref>().getAsset()}/USDT",
                style: StyleFactory.title);
      },
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
