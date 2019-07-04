import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:cybex_flutter_plugin/common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class UnlockViewModel extends BaseModel {
  bool shouldShowErrorMessage = false;

  UserManager _um;

  UnlockViewModel({
    UserManager um,
  }) {
    _um = um;
  }

  Future<bool> checkPassword({String name, String password}) async {
    var account = await _um.unlockWith(name: name, password: password);
    if (account != null) {
      shouldShowErrorMessage = false;
      setBusy(false);
      return true;
    } else {
      shouldShowErrorMessage = true;
      setBusy(false);
      return false;
    }
  }
}
