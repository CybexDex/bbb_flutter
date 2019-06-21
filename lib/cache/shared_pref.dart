import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef SharedPrefBuilder = Future<SharedPreferences> Function();

class SharedPref {
  SharedPreferences _prefs;
  SharedPref._(this._prefs);

  static Future<SharedPref> create() async =>
      SharedPref._(await SharedPreferences.getInstance());

  String getUserName() {
    var value = _prefs.getString("bbb.username");
    return value;
  }

  saveUserName({String name}) async {
    await _prefs.setString('bbb.username', name);
  }

  removeUserName() async {
    await _prefs.remove('bbb.username');
  }

  AccountResponseModel getAccount() {
    final value = _prefs.getString("bbb.account");
    if (value != null) {
      return AccountResponseModel.fromRawJson(value);
    }
    return null;
  }

  saveAccount({AccountResponseModel account}) async {
    await _prefs.setString('bbb.account', account.toRawJson());
  }

  removeAccount() async {
    await _prefs.remove('bbb.account');
  }

  AccountKeysEntity getAccountKeys() {
    var value = _prefs.getString("bbb.accountKeys");
    if (value != null) {
      return AccountKeysEntity.fromRawJson(value);
    }
    return null;
  }

  saveAccountKeys({AccountKeysEntity keys}) async {
    await _prefs.setString('bbb.accountKeys', keys.toRawJson());
  }

  removeAccountKeys() async {
    await _prefs.remove('bbb.accountKeys');
  }
}
