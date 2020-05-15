import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/action_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/config_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/underlying_asset_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:rxdart/subjects.dart';

class RefManager {
  BehaviorSubject<RefDataResponse> refDataControllerNew = BehaviorSubject<RefDataResponse>();
  BehaviorSubject<ContractResponse> contractController = BehaviorSubject<ContractResponse>();
  BBBAPI _api;
  String _upcontractId;
  String _downcontractId;
  List<UnderlyingAssetResponse> underlyingList;
  List<Action> actions;
  ContractResponse firstLoadContractResponse;
  ConfigResponse config;
  ConfigResponse couponConfig;
  bool isIdSelectedByUser = false;
  String pushRegId;

  RefManager({BBBAPI api}) : _api = api;

  Contract get currentUpContract {
    if (_upcontractId == null) {
      return null;
    }
    return getContractFromId(_upcontractId);
  }

  Contract get currentDownContract {
    if (_downcontractId == null) {
      return null;
    }
    return getContractFromId(_downcontractId);
  }

  List<Contract> get upContract {
    List<Contract> contractList = contractController.value?.contract?.where((contract) {
      return contract.contractId.contains("N");
    })?.toList();
    contractList?.sort((b, a) => a.strikeLevel.compareTo(b.strikeLevel));
    return contractList;
  }

  List<Contract> get downContract {
    List<Contract> contractList = contractController.value?.contract?.where((contract) {
      return contract.contractId.contains("X");
    })?.toList();
    contractList?.sort((a, b) => a.strikeLevel.compareTo(b.strikeLevel));
    return contractList;
  }

  List<Contract> get allUpContract {
    List<Contract> contractList = firstLoadContractResponse.contract?.where((contract) {
      return contract.contractId.contains("N");
    })?.toList();
    contractList?.sort((b, a) => a.strikeLevel.compareTo(b.strikeLevel));
    return contractList;
  }

  List<Contract> get allDownContract {
    List<Contract> contractList = firstLoadContractResponse.contract?.where((contract) {
      return contract.contractId.contains("X");
    })?.toList();
    contractList?.sort((a, b) => a.strikeLevel.compareTo(b.strikeLevel));
    return contractList;
  }

  Contract getContractFromId(String id) {
    return contractController.value?.contract?.firstWhere((contract) {
      return contract.contractId == id;
    }, orElse: () {
      return null;
    });
  }

  firstLoadData() async {
    await getConfig();
    await updateRefData();
    await updateContract();
    await getAssetList();
    await getPushRegistrationId();
    // updateUpContractId();
    // updateDownContractId();
    startLoop();
  }

  updateUpContractId() {
    changeUpContractId(upContract.isEmpty ? null : upContract.first?.contractId);
  }

  updateDownContractId() {
    changeDownContractId(downContract.isEmpty ? null : downContract.first?.contractId);
  }

  changeUpContractId(String id) {
    _upcontractId = id;
  }

  changeDownContractId(String id) {
    _downcontractId = id;
  }

  startLoop() {
    var timerManager = locator.get<TimerManager>();
    var marketManager = locator.get<MarketManager>();
    marketManager.lastTicker.stream.listen((ticker) {
      var copyContractResponse = ContractResponse();
      copyContractResponse.contract = firstLoadContractResponse.contract.where((contract) {
        return ((contract.contractId.contains("N")) &&
                (ticker.value > contract.strikeLevel) &&
                ((ticker.value / ((ticker.value - contract.strikeLevel).abs())) <=
                    config.maxGearing)) ||
            ((contract.contractId.contains("X")) &&
                (ticker.value < contract.strikeLevel) &&
                ((ticker.value / ((ticker.value - contract.strikeLevel).abs())) <=
                    config.maxGearing));
      }).toList();
      contractController.add(copyContractResponse);
    });

    // timerManager.tick.listen((_) {
    //   updateContract();
    // });
    // timerManager.start();
    timerManager.refDataUpdate.listen((ticker) {
      updateRefData();
    });
    timerManager.refDataUpdateStart();
  }

  // Future<RefContractResponseModel> refreshRefData() async {
  //   RefContractResponseModel response = await _api.getRefData();
  //   _refdataController.add(response);
  //   return response;
  // }

  updateRefData() async {
    RefDataResponse response = await _api.getRefDataNew();
    refDataControllerNew.add(response);
  }

  updateContract() async {
    ContractResponse contractResponse = await _api.getContract();
    firstLoadContractResponse = contractResponse;
    // contractController.add(contractResponse);
  }

  getActions() async {
    ActionResponse response = await _api.getActions();
    actions = response.action;
  }

  getConfig() async {
    ConfigResponse response = await _api.getConfig();
    ConfigResponse couponResponse = await _api.getConfig(injectAction: "coupon");
    config = response;
    couponConfig = couponResponse;
  }

  getAssetList() async {
    List<UnderlyingAssetResponse> assetList = await _api.getAsset();
    underlyingList = assetList;
  }

  getPushRegistrationId() async {
    String regId = await locator.get<JPush>().getRegistrationID();
    print(regId);
    pushRegId = regId;
  }
}
