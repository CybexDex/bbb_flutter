import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class AccountViewModel extends BaseModel {
  final BBBAPI _bbbapi;
  final GatewayApi _gatewayApi;
  bool withdrawAvailable = true;
  bool depositAvailable = true;
  bool hasBonus = false;
  bool showAmount = true;
  Position bounusAccountBalance;

  AccountViewModel({BBBAPI bbbapi, GatewayApi gatewayApi})
      : _bbbapi = bbbapi,
        _gatewayApi = gatewayApi;

  getGatewayInfo({String assetName}) async {
    try {
      GatewayAssetResponseModel gatewayAssetResponseModel =
          await _gatewayApi.getAsset(asset: assetName);
      if (gatewayAssetResponseModel != null) {
        depositAvailable = gatewayAssetResponseModel.depositSwitch;
        withdrawAvailable = gatewayAssetResponseModel.withdrawSwitch;
        setBusy(false);
      }
    } catch (err) {
      depositAvailable = false;
      withdrawAvailable = false;
      setBusy(false);
    }
  }

  checkRewardAccount({String accountName, bool bonusEvent}) async {
    TestAccountResponseModel testAccount = await _bbbapi.getTestAccount(
        accountName: accountName, bonusEvent: bonusEvent);
    hasBonus = testAccount != null;
    if (hasBonus) {
      PositionsResponseModel positionsResponseModel =
          await _bbbapi.getPositionsTestAccount(name: testAccount.accountName);
      bounusAccountBalance =
          _fetchPositionFrom(AssetName.NXUSDT, positionsResponseModel);
    }
    setBusy(false);
  }

  showAccountAmount() {
    showAmount = !showAmount;
    setBusy(false);
  }

  Position _fetchPositionFrom(
      String name, PositionsResponseModel positionsResponseModel) {
    if (positionsResponseModel == null ||
        positionsResponseModel.positions.length == 0) {
      return null;
    }
    List<Position> positions =
        positionsResponseModel.positions.where((position) {
      return position.assetName == name;
    }).toList();
    return positions.isEmpty ? null : positions.first;
  }

  puchToNextPage(bool isLogin, String path, BuildContext context) {
    if (isLogin) {
      Navigator.of(context).pushNamed(path);
    } else {
      Navigator.of(context).pushNamed(RoutePaths.Login);
    }
  }
}
