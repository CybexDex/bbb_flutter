import 'dart:async';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/account_util.dart';
import 'package:bbb_flutter/logic/coupon_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/entity/account_permission_entity.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/services/network/push/push_api.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

import '../setup.dart';
import 'market_manager.dart';

class UserManager extends BaseModel {
  UserEntity user;
  bool withdrawAvailable = true;
  bool depositAvailable = true;
  bool hasBonus = false;

  final SharedPref _pref;
  final BBBAPI _api;

  UserManager({pref, BBBAPI api, this.user})
      : _pref = pref,
        _api = api;

  ///AssetName.CYB

  Position fetchPositionFrom(String assetId) {
    if (user.balances == null || user.balances.positions.length == 0 || assetId == null) {
      return null;
    }
    List<Position> positions = user.balances.positions.where((position) {
      return position.assetId == assetId;
    }).toList();
    return positions.isEmpty ? null : positions.first;
  }

  Future<bool> loginWith({String name, String password}) async {
    try {
      AccountResponseModel account = await _api.getAccount(name: name);
      if (account != null) {
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
      }
      return false;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> loginWithPrivateKey({bool bonusEvent, String accountName}) async {
    TestAccountResponseModel testAccount = _pref.getTestAccount() ??
        await _api.getTestAccount(bonusEvent: bonusEvent, accountName: accountName);
    if (testAccount != null) {
      try {
        await locator.get<BBBAPI>().setAction(action: "test");
        await locator.get<RefManager>().updateRefData();
        await locator.get<RefManager>().updateContract();
        locator.get<RefManager>().updateUpContractId();
        locator.get<RefManager>().updateDownContractId();
        await fetchBalances(name: testAccount.name);
        if (user.balances.positions
                .firstWhere((position) =>
                    position.assetId ==
                    locator.get<RefManager>().refDataControllerNew.value?.bbbAssetId)
                .quantity ==
            null) {
          testAccount = await _api.getTestAccount(bonusEvent: bonusEvent, accountName: accountName);
          await fetchBalances(name: testAccount.name);
        }
        await unlockWithPrivKey(testAccount: testAccount);
        user.testAccountResponseModel = testAccount;
        user.loginType = LoginType.test;
        user.name = testAccount.name;
        _pref.saveLoginType(loginType: user.loginType);
        _pref.saveTestAccount(testAccount: testAccount);
        _pref.saveUserName(name: user.name);
        notifyListeners();
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  Future<bool> loginReward({String action}) async {
    await locator.get<BBBAPI>().setAction(action: action);
    await locator.get<RefManager>().updateRefData();
    await locator.get<RefManager>().updateContract();
    locator.get<RefManager>().updateUpContractId();
    locator.get<RefManager>().updateDownContractId();
    user.loginType = LoginType.reward;
    _pref.saveLoginType(loginType: user.loginType);
    fetchBalances(name: user.name);
    notifyListeners();
    return true;
  }

  unlockWithPrivKey({TestAccountResponseModel testAccount}) async {
    try {
      await CybexFlutterPlugin.setDefaultPrivKey(testAccount.privkey);
    } catch (error) {
      throw error.toString();
    }
  }

  unlockWith({String name, String password, AccountResponseModel account}) async {
    try {
      AccountKeysEntity keys = await generateAccountKeys(name: name, password: password);
      if (keys != null) {
        var permission = generatePermission(account: account ?? user.account, keys: [keys]);
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
    String expiration = (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    String sig = await CybexFlutterPlugin.signMessageOperation(expiration + name);
    sig = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    String authorization = "bearer $expiration.$name.$sig";
    DepositResponseModel deposit = await locator
        .get<GatewayApi>()
        .getDepositAddress(user: name, asset: asset, authorization: authorization);
    if (deposit != null) {
      user.deposit = deposit;
      notifyListeners();
    }
  }

  getGatewayInfo({String assetName}) async {
    try {
      GatewayAssetResponseModel gatewayAssetResponseModel =
          await locator.get<GatewayApi>().getAsset(asset: assetName);
      if (gatewayAssetResponseModel != null) {
        depositAvailable = gatewayAssetResponseModel.depositSwitch;
        withdrawAvailable = gatewayAssetResponseModel.withdrawSwitch;
        notifyListeners();
      }
    } catch (err) {
      depositAvailable = false;
      withdrawAvailable = false;
      notifyListeners();
    }
  }

  checkRewardAccount({String accountName, bool bonusEvent}) async {
    TestAccountResponseModel testAccount =
        await _api.getTestAccount(accountName: accountName, bonusEvent: bonusEvent);
    hasBonus = testAccount != null;
    notifyListeners();
  }

  Future<AccountKeysEntity> generateAccountKeys({String name, String password}) async {
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

    var allKeys = keys.fold(<String>[], (List<String> t, e) => t + e.pubkeys).toSet().toList();

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

    locator
        .get<PushApi>()
        .unRegisterPush(accountName: user.name, regId: locator.get<RefManager>().pushRegId);

    user.account = null;
    user.name = null;
    user.keys = null;
    user.permission = null;
    user.balances = null;
    user.loginType = LoginType.none;
    locator.get<CouponViewModel>().getCoupons();
    notifyListeners();
  }

  logoutTestAccount() async {
    user.testAccountResponseModel = null;
    await locator<BBBAPI>().setAction(action: "main");
    await locator.get<RefManager>().updateRefData();
    await locator.get<RefManager>().updateContract();
    locator.get<RefManager>().updateUpContractId();
    locator.get<RefManager>().updateDownContractId();
    if (user.account != null) {
      user.loginType = LoginType.cloud;
      _pref.saveLoginType(loginType: LoginType.cloud);
      user.name = user.account.name;
      _pref.saveUserName(name: user.account.name);
      fetchBalances(name: user.name);
    } else {
      _pref.saveLoginType(loginType: LoginType.none);
      user.loginType = LoginType.none;
      user.name = null;
      _pref.removeUserName();
      user.balances = null;
    }
    locator.get<HomeViewModel>().getRankingList();
    locator.get<CouponViewModel>().getCoupons();
    notifyListeners();
  }

  logOutRewardAccount() async {
    await locator<BBBAPI>().setAction(action: "main");
    locator.get<HomeViewModel>().getRankingList();
    await locator.get<RefManager>().updateRefData();
    await locator.get<RefManager>().updateContract();
    locator.get<RefManager>().updateUpContractId();
    locator.get<RefManager>().updateDownContractId();
    user.loginType = LoginType.cloud;
    _pref.saveLoginType(loginType: LoginType.cloud);
    user.name = user.account.name;
    _pref.saveUserName(name: user.account.name);
    fetchBalances(name: user.name);
    notifyListeners();
  }

  reload() async {
    await locator.get<RefManager>().updateRefData();
    await locator.get<RefManager>().updateContract();
    locator.get<RefManager>().updateUpContractId();
    locator.get<RefManager>().updateDownContractId();
    if (user.logined) {
      fetchBalances(name: user.name);
    }
    locator.get<HomeViewModel>().getRankingList();
    locator.get<CouponViewModel>().getCoupons();
    locator.get<MarketManager>().cancelAndRemoveData();
    locator.get<MarketManager>().loadAllData(null);
    notifyListeners();
  }
}

enum errorMessageState { Null, True, False }
