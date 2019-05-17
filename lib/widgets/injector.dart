import 'package:bbb_flutter/blocs/market_history_bloc.dart';
import 'package:bbb_flutter/blocs/user_bloc.dart';
import 'package:bbb_flutter/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InjectorWidget extends InheritedWidget {
  final UserBloc userBloc = UserBloc();
  final MarketHistoryBloc marketHistoryBloc = MarketHistoryBloc();

  init() async {
    SharedPref().prefs = await SharedPreferences.getInstance();
    userBloc.refreshUserInfo();
  }

  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
