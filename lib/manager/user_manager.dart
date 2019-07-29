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
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

import '../setup.dart';
import 'market_manager.dart';

class UserManager extends BaseModel {
  UserEntity user;

  final SharedPref _pref;
  final BBBAPI _api;

  UserManager({SharedPref pref, BBBAPI api, this.user})
      : _pref = pref,
        _api = api;

  ///AssetName.CYB

  Position fetchPositionFrom(String name) {
    if (user.balances == null || user.balances.positions.length == 0) {
      return null;
    }
    List<Position> positions = user.balances.positions.where((position) {
      return position.assetName == name;
    }).toList();
    return positions.isEmpty ? null : positions.first;
  }

  Future<bool> loginWith({String name, String password}) async {
    AccountResponseModel account = await _api.getAccount(name: name);
    if (account != null) {
      try {
        await unlockWith(name: name, password: password, account: account);
        user.name = name;
        user.account = account;
        user.loginType = LoginType.cloud;
        user.unlockType = UnlockType.cloud;

        _pref.saveUserName(name: name);
        _pref.saveAccount(account: account);
        _pref.saveLoginType(loginType: LoginType.cloud);
        notifyListeners();

        return true;
      } catch (error) {
        return false;
      }
    }

    return false;
  }

  Future<bool> loginWithPrivateKey() async {
    await locator.get<BBBAPI>().setTestNet(isTestNet: true);

    TestAccountResponseModel testAccount =
        _pref.getTestAccount() ?? await _api.getTestAccount();
    if (testAccount != null) {
      try {
        await unlockWithPrivKey(testAccount: testAccount);
        user.testAccountResponseModel = testAccount;
        user.loginType = LoginType.test;
        user.name = testAccount.accountName;
        _pref.saveLoginType(loginType: LoginType.test);
        _pref.saveTestAccount(testAccount: testAccount);
        _pref.saveUserName(name: user.name);
        fetchBalances(name: user.name);
        locator.get<MarketManager>().cancelAndRemoveData();
        locator.get<MarketManager>().loadAllData("BXBT");
        notifyListeners();
        return true;
      } catch (error) {
        return false;
      }
    }

    return false;
  }

  unlockWithPrivKey({TestAccountResponseModel testAccount}) async {
    try {
      await CybexFlutterPlugin.setDefaultPrivKey(testAccount.privateKey);
    } catch (error) {
      throw error.toString();
    }
  }

  unlockWith(
      {String name, String password, AccountResponseModel account}) async {
    try {
      AccountKeysEntity keys =
          await generateAccountKeys(name: name, password: password);
      if (keys != null) {
        var permission =
            generatePermission(account: account ?? user.account, keys: [keys]);
        if (permission.unlock) {
          CybexFlutterPlugin.resetDefaultPubKey(permission.defaultKey);
          keys.removePrivateKey();
          user.keys = keys;
          _pref.saveAccountKeys(keys: keys);
        } else {
          throw "error";
        }
      } else {
        throw "error";
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> checkAccount({String name}) async {
    AccountResponseModel account = await _api.getAccount(name: name);
    return account != null;
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
    _pref.removeLoginType();

    user.account = null;
    user.name = null;
    user.keys = null;
    user.permission = null;
    user.balances = null;
    notifyListeners();
  }

  logoutTestAccount() async {
    user.testAccountResponseModel = null;
    if (user.account != null) {
      user.loginType = LoginType.cloud;
      _pref.saveLoginType(loginType: LoginType.cloud);
      user.name = user.account.name;
      _pref.saveUserName(name: user.account.name);
      fetchBalances(name: user.name);
    } else {
      _pref.saveLoginType(loginType: LoginType.none);
      user.name = null;
      _pref.removeUserName();
    }
    await locator<BBBAPI>().setTestNet(isTestNet: false);
    locator.get<MarketManager>().cancelAndRemoveData();
    locator.get<MarketManager>().loadAllData(null);
    notifyListeners();
  }

  reload() async {
    fetchBalances(name: user.name);
    locator.get<MarketManager>().cancelAndRemoveData();
    locator.get<MarketManager>().loadAllData(null);
    notifyListeners();
  }
}

enum errorMessageState { Null, True, False }
