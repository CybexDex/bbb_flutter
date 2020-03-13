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
                  if (bloc.user.logined) {
                    Navigator.of(context).pushNamed(RoutePaths.OrderHome);
                  } else {
                    Navigator.of(context).pushNamed(RoutePaths.Login);
                  }
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
          return Text("BTC/USDT --", style: StyleFactory.title);
        }
        return bloc.user.loginType == LoginType.test
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("试玩 BTC/USDT", style: StyleFactory.title),
                  // Text("${ticker.value.toStringAsFixed(4)}",
                  //     style: StyleFactory.subTitleStyle)
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      bloc.user.loginType == LoginType.reward
                          ? "奖励 BTC/USDT"
                          : "BTC/USDT",
                      style: StyleFactory.title),
                  // Text("${ticker.value.toStringAsFixed(4)}",
                  //     style: StyleFactory.subTitleStyle)
                ],
              );
      },
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
