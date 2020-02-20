import 'package:bbb_flutter/models/response/bbb_query_response/action_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:rxdart/subjects.dart';

class RefManager {
  BehaviorSubject<RefDataResponse> refDataControllerNew =
      BehaviorSubject<RefDataResponse>();
  BehaviorSubject<ContractResponse> contractController =
      BehaviorSubject<ContractResponse>();
  BBBAPI _api;
  String _upcontractId;
  String _downcontractId;
  List<Action> actions;

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
    return contractController.value?.contract
        ?.where((contract) {
          return contract.conversionRate > 0 &&
              contractStatusMap[ContractStatus.active] == contract.status;
        })
        ?.toList()
        ?.reversed
        ?.toList();
  }

  List<Contract> get downContract {
    return contractController.value?.contract?.where((contract) {
      return contract.conversionRate < 0 &&
          contractStatusMap[ContractStatus.active] == contract.status;
    })?.toList();
  }

  Contract getContractFromId(String id) {
    return contractController.value?.contract
        ?.where((contract) {
          return contract.contractId == id;
        })
        ?.toList()
        ?.first;
  }

  firstLoadData() async {
    await getActions();
    await updateRefData();
    await updateContract();
    updateUpContractId();
    updateDownContractId();
    startLoop();
  }

  updateUpContractId() {
    changeUpContractId(
        upContract.isEmpty ? null : upContract.first?.contractId);
  }

  updateDownContractId() {
    changeDownContractId(
        downContract.isEmpty ? null : downContract.first?.contractId);
  }

  changeUpContractId(String id) {
    _upcontractId = id;
  }

  changeDownContractId(String id) {
    _downcontractId = id;
  }

  startLoop() {
    var timerManager = locator.get<TimerManager>();
    timerManager.tick.listen((_) {
      updateContract();
    });
    timerManager.start();
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
    contractController.add(contractResponse);
  }

  getActions() async {
    ActionResponse response = await _api.getActions();
    actions = response.action;
  }
}
