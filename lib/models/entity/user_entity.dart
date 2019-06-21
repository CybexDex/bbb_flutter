import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/entity/account_permission_entity.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';

class UserEntity {
  LoginType loginType;
  LockTimeType lockTimeType;
  UnlockType unlockType;

  String name;
  AccountResponseModel account;

  AccountKeysEntity keys;
  AccountPermissionEntity permission;

  UserEntity(
      {this.loginType,
      this.lockTimeType,
      this.unlockType,
      this.name,
      this.account,
      this.keys,
      this.permission});

  bool get logined {
    return name != null && name.isNotEmpty;
  }

  bool get isLocked {
    return keys == null && unlockType == UnlockType.cloud;
  }
}
