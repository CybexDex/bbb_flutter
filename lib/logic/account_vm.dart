import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class AccountViewModel extends BaseModel {
  final BBBAPI _bbbapi;
  final GatewayApi _gatewayApi;
  bool withdrawAvailable = true;
  bool depositAvailable = true;
  bool hasBonus = false;
  bool showAmount = true;
  Position bounusAccountBalance = Position(quantity: 0);
  String action;

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
    await locator.get<RefManager>().getActions();
    action = locator
        .get<RefManager>()
        .actions
        .firstWhere((i) => i.name.contains("reward"), orElse: () => null)
        ?.name;
    if (action == null) {
      hasBonus = false;
    } else {
      PositionsResponseModel testAccountPosition =
          await _bbbapi.getPositions(name: accountName, injectAction: action);
      RefDataResponse refDataResponse =
          await _bbbapi.getRefDataNew(injectAction: action);
      hasBonus = testAccountPosition.positions.first.quantity != null;
      if (hasBonus) {
        bounusAccountBalance =
            _fetchPositionFrom(refDataResponse.bbbAssetId, testAccountPosition);
      }
    }
    setBusy(false);
  }

  showAccountAmount() {
    showAmount = !showAmount;
    setBusy(false);
  }

  Position _fetchPositionFrom(
      String assetid, PositionsResponseModel positionsResponseModel) {
    if (positionsResponseModel == null ||
        positionsResponseModel.positions.length == 0) {
      return null;
    }
    List<Position> positions =
        positionsResponseModel.positions.where((position) {
      return position.assetId == assetid;
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
