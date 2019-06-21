import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/shared/types.dart';

UserEntity loadUserFromCache(SharedPref pref) {
  return UserEntity(
      account: pref.getAccount(),
      keys: pref.getAccountKeys(),
      name: pref.getUserName(),
      lockTimeType: LockTimeType.high,
      loginType: LoginType.none,
      permission: null,
      unlockType: UnlockType.none);
}