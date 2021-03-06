import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/shared/types.dart';

UserEntity loadUserFromCache(SharedPref pref) {
  return UserEntity(
      account: pref.getAccount(),
      name: pref.getUserName(),
      lockTimeType: LockTimeType.high,
      loginType: pref.getLoginType(),
      permission: null,
      unlockType: UnlockType.cloud,
      testAccountResponseModel: pref.getAction() == "test"
          ? pref.getLoginType() == LoginType.reward
              ? pref.getRewardAccount()
              : pref.getTestAccount()
          : null);
}
