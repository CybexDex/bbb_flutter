import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:rxdart/subjects.dart';

class RefManager {
  Stream<RefContractResponseModel> get data => _refdataController.stream;
  RefContractResponseModel get lastData => _refdataController.value;
  String _upcontractId;
  String _downcontractId;

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
    return lastData?.contract?.where((contract) {
      return contract.conversionRate > 0 &&
          contractStatusMap[ContractStatus.active] == contract.status;
    })?.toList();
  }

  List<Contract> get downContract {
    return lastData?.contract?.where((contract) {
      return contract.conversionRate < 0 &&
          contractStatusMap[ContractStatus.active] == contract.status;
    })?.toList();
  }

  BehaviorSubject<RefContractResponseModel> _refdataController =
      BehaviorSubject<RefContractResponseModel>();

  BBBAPI _api;

  RefManager({BBBAPI api}) : _api = api;

  Contract getContractFromId(String id) {
    return lastData?.contract
        ?.where((contract) {
          return contract.contractId == id;
        })
        ?.toList()
        ?.first;
  }

  firstLoadData() async {
    RefContractResponseModel _ = await refreshRefData();
    changeUpContractId(
        upContract.isEmpty ? null : upContract.first?.contractId);
    changeDownContractId(
        downContract.isEmpty ? null : downContract.first?.contractId);

    startLoop();
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
      refreshRefData();
    });
    timerManager.start();
  }

  Future<RefContractResponseModel> refreshRefData() async {
    RefContractResponseModel response = await _api.getRefData();
    _refdataController.add(response);
    return response;
  }
}
