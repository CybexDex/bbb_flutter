import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/shared_pref.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:bloc_provider/bloc_provider.dart';

class UserBloc implements Bloc {
  BehaviorSubject<UserEntity> userSubject = BehaviorSubject<UserEntity>();

  static UserBloc _singleton = UserBloc._internal();
  UserBloc._internal();

  factory UserBloc() {
    _singleton = _singleton ?? UserBloc._internal();
    return _singleton;
  }

  @override
  dispose() async {
    await userSubject.close();
  }

  refreshUserInfo() {
    var user = userSubject.value ?? UserEntity();
    user.isLogin = SharedPref().isLogin();
    user.name = SharedPref().getUserName();
    userSubject.sink.add(user);
  }

  loginWith({String name}) async {
    await SharedPref().switchLoginState(login: true, name: name);
    refreshUserInfo();
  }

  logout() async {
    await SharedPref().switchLoginState(login: false, name: "");
    refreshUserInfo();
  }
}
