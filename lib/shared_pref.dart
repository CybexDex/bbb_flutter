import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref _singleton = SharedPref._internal();
  SharedPreferences prefs;

  SharedPref._internal();

  factory SharedPref() {
    _singleton = _singleton ?? SharedPref._internal();
    return _singleton;
  }

  String getUserName() {
    var value = prefs.getString("bbb.username") ?? "";
    return value;
  }

  bool isLogin() {
    var value = prefs.getBool("bbb.isLogin") ?? false;
    return value;
  }

  switchLoginState({bool login, String name = ""}) async {
    await prefs.setBool('bbb.isLogin', login);
    await prefs.setString('bbb.username', name);
  }
}
