import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

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
      builder: (context, bloc, child) => !bloc.user.logined
          ? GestureDetector(
              child: child,
              onTap: () {
                if (bloc.user.logined) {
                  Scaffold.of(context).openDrawer();
                } else {
                  Navigator.of(context).pushNamed(RoutePaths.Login);
                }
              },
            )
          : child,
      child: ImageFactory.personal,
    ),
    centerTitle: true,
    title: Text(".BXBT", style: StyleFactory.title),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
  );
}
