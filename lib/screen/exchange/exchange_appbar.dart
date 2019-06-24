import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

AppBar exchangeAppBar() {
  return AppBar(
    actions: <Widget>[
      Builder(
          builder: (context) => GestureDetector(
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
                  Navigator.of(context).pushNamed(RoutePaths.Deposit);
                },
              ))
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
      child: ImageFactory.personal,
    ),
    centerTitle: true,
    title: Text(".BXBT", style: StyleFactory.title),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
