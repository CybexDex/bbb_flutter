import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:quiver/check.dart';

List<String> activePubkeysFrom({AccountResponseModel account}) {
  checkNotNull(account);

  final activeKeys =
      account.active.keyAuths.map((auth) => auth.first).toList().cast<String>();
  return activeKeys;
}

List<String> ownerPubkeysFrom({AccountResponseModel account}) {
  checkNotNull(account);

  final activeKeys =
      account.owner.keyAuths.map((auth) => auth.first).toList().cast<String>();
  return activeKeys;
}

List<String> allPubkeys({AccountResponseModel account}) {
  checkNotNull(account);

  return activePubkeysFrom(account: account) +
      ownerPubkeysFrom(account: account);
}

String getAssetIdForSign({String assetId}) {
  return assetId.split(".").last;
}
