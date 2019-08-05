import 'dart:convert';

import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';
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

  TestAccountResponseModel getTestAccount() {
    final value = _prefs.getString('bbb.testAccount');
    if (value != null) {
      return TestAccountResponseModel.fromJson(json.decode(value));
    }
    return null;
  }

  saveTestAccount({TestAccountResponseModel testAccount}) async {
    await _prefs.setString('bbb.testAccount', testAccount.toString());
  }

  removeTestAccount() async {
    await _prefs.remove('bbb.testAccount');
  }

  LoginType getLoginType() {
    var value = _prefs.getString('bbb.loginType');
    if (value != null) {
      return LoginType.values.firstWhere((e) => e.toString() == value);
    }
    return LoginType.none;
  }

  saveLoginType({LoginType loginType}) async {
    await _prefs.setString('bbb.loginType', loginType.toString());
  }

  removeLoginType() async {
    await _prefs.remove('bbb.loginType');
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

  bool getTestNet() {
    var value = _prefs.getBool('bbb.testNet');
    if (value != null) {
      return value;
    }
    return false;
  }

  saveTestNet({bool isTestNet}) async {
    await _prefs.setBool('bbb.testNet', isTestNet);
  }

  removeTestNet() async {
    await _prefs.remove('bbb.testNet');
  }

  EnvType getEnvType() {
    var value = _prefs.getString('bbb.envType');
    if (value != null) {
      return EnvType.values.firstWhere((e) => e.toString() == value);
    }
    return EnvType.Pro;
  }

  saveEnvType({EnvType envType}) async {
    await _prefs.setString('bbb.envType', envType.toString());
  }

  removeEnvType() async {
    await _prefs.remove('bbb.envType');
  }
}
