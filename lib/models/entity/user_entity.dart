import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/entity/account_permission_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/types.dart';

class UserEntity {
  LoginType loginType;
  LockTimeType lockTimeType;
  UnlockType unlockType;

  String name;
  AccountResponseModel account;

  PositionsResponseModel balances;
  AccountKeysEntity keys;
  AccountPermissionEntity permission;
  DepositResponseModel deposit;
  TestAccountResponseModel testAccountResponseModel;
  String userPrivateKeyTag;
  String privateKey;

  UserEntity(
      {this.loginType,
      this.lockTimeType,
      this.unlockType,
      this.name,
      this.account,
      this.keys,
      this.permission,
      this.balances,
      this.deposit,
      this.testAccountResponseModel,
      this.userPrivateKeyTag,
      this.privateKey});

  bool get logined {
    return (name != null && name.isNotEmpty) || testAccountResponseModel != null;
  }

  bool get isLocked {
    bool isBiometricOpen =
        locator.get<SharedPref>().getUserBiometricEntity(userName: name).isBiomtricOpen;
    return ((keys == null) && (userPrivateKeyTag == null)) &&
        (loginType == LoginType.cloud || loginType == LoginType.reward);
  }
}
