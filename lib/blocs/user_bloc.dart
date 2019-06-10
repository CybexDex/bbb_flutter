import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/shared_pref.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class UserBloc {
  BehaviorSubject<UserEntity> userSubject = BehaviorSubject<UserEntity>();

  dispose() {
    userSubject.close();
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
