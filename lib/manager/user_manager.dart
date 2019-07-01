import 'dart:async';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/account_util.dart';
import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/entity/account_permission_entity.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class UserManager extends BaseModel {
  UserEntity user;

  final SharedPref _pref;
  final BBBAPIProvider _api;

  UserManager({SharedPref pref, BBBAPIProvider api, this.user})
      : _pref = pref,
        _api = api;

/**
 *    //AssetName.CYB
 */
  Position fetchPositionFrom(String name) {
    return user.balances.positions.where((position) {
      return position.assetName == name;
    }).first;
  }

  Future<bool> loginWith({String name, String password}) async {
    var account = await unlockWith(name: name, password: password);
    if (account != null) {
      user.name = name;
      user.account = account;
      user.loginType = LoginType.cloud;
      user.unlockType = UnlockType.cloud;

      _pref.saveUserName(name: name);
      _pref.saveAccount(account: account);
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<AccountResponseModel> unlockWith(
      {String name, String password}) async {
    AccountResponseModel account = await _api.getAccount(name: name);
    if (account != null) {
      AccountKeysEntity keys =
          await generateAccountKeys(name: name, password: password);
      if (keys != null) {
        var permission = generatePermission(account: account, keys: [keys]);
        if (permission.unlock) {
          CybexFlutterPlugin.resetDefaultPubKey(permission.defaultKey);
          keys.removePrivateKey();
          user.keys = keys;
          _pref.saveAccountKeys(keys: keys);

          return account;
        }
      }
    }

    return null;
  }

  refreshAccount({String name}) async {
    AccountResponseModel account = await _api.getAccount(name: name);
    if (account != null) {
      user.account = account;
      _pref.saveAccount(account: account);
      notifyListeners();
    }
  }

  fetchBalances({String name}) async {
    PositionsResponseModel balances = await _api.getPositions(name: name);
    if (balances != null) {
      user.balances = balances;
      notifyListeners();
    }
  }

  getDepositAddress({String name, String asset}) async {
    DepositResponseModel deposit =
        await _api.getDeposit(name: name, asset: asset);
    if (deposit != null) {
      user.deposit = deposit;
      notifyListeners();
    }
  }

  Future<AccountKeysEntity> generateAccountKeys(
      {String name, String password}) async {
    await CybexFlutterPlugin.cancelDefaultPubKey();
    String keys = await CybexFlutterPlugin.getUserKeyWith(name, password);
    if (keys != null) {
      return AccountKeysEntity.fromRawJson(keys);
    }

    return Future.error("generate keys failed");
  }

  AccountPermissionEntity generatePermission(
      {AccountResponseModel account, List<AccountKeysEntity> keys}) {
    var permission = AccountPermissionEntity();
    permission.unlock = false;
    permission.trade = false;

    var allKeys = keys
        .fold(<String>[], (List<String> t, e) => t + e.pubkeys)
        .toSet()
        .toList();

    for (var key in allPubkeys(account: account)) {
      if (allKeys.contains(key)) {
        permission.unlock = true;
        permission.defaultKey = key;
        break;
      }

      if (activePubkeysFrom(account: account).contains(key)) {
        permission.trade = true;
      }
    }

    permission.withdraw = allKeys.contains(account.options.memoKey);

    return permission;
  }

  logout() async {
    _pref.removeAccount();
    _pref.removeAccountKeys();
    _pref.removeUserName();

    user.account = null;
    user.name = null;
    user.keys = null;
    user.permission = null;
    notifyListeners();
  }
}
