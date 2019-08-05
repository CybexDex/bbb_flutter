import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

AppBar exchangeAppBar() {
  return AppBar(
    actions: <Widget>[
      Consumer<UserManager>(
          builder: (context, bloc, child) =>
              bloc.user.loginType == LoginType.test
                  ? Container()
                  : GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            I18n.of(context).topUp,
                            style: StyleFactory.navButtonTitleStyle,
                            textScaleFactor: 1,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (bloc.user.logined) {
                          Navigator.of(context).pushNamed(RoutePaths.Deposit);
                        } else {
                          Navigator.of(context).pushNamed(RoutePaths.Login);
                        }
                      },
                    )),
    ],
    leading: Consumer<UserManager>(
      builder: (context, bloc, child) => GestureDetector(
        child: !bloc.user.logined
            ? child
            : Padding(
                padding: EdgeInsets.all(16),
                child: SvgPicture.string(Jdenticon.toSvg(bloc.user.name),
                    fit: BoxFit.contain, height: 20, width: 20),
              ),
        onTap: () {
          if (bloc.user.logined) {
            bloc.fetchBalances(name: bloc.user.name);
            Scaffold.of(context).openDrawer();
          } else {
            Navigator.of(context).pushNamed(RoutePaths.Login);
          }
        },
      ),
      child: Image.asset(R.resAssetsIconsIcPerson),
    ),
    centerTitle: true,
    title: Consumer<UserManager>(
      builder: (context, bloc, child) {
        return bloc.user.loginType == LoginType.test
            ? Text("试玩 .BXBT", style: StyleFactory.title)
            : Text(".BXBT", style: StyleFactory.title);
      },
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
