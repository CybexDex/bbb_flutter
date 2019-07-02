import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
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
    return lastData?.contract
        ?.where((contract) {
          return contract.contractId == _upcontractId;
        })
        ?.toList()
        ?.first;
  }

  Contract get currentDownContract {
    if (_downcontractId == null) {
      return null;
    }
    return lastData?.contract
        ?.where((contract) {
          return contract.contractId == _downcontractId;
        })
        ?.toList()
        ?.first;
  }

  List<Contract> get upContract {
    return lastData?.contract?.where((contract) {
      return contract.conversionRate > 0;
    })?.toList();
  }

  List<Contract> get downContract {
    return lastData?.contract?.where((contract) {
      return contract.conversionRate < 0;
    })?.toList();
  }

  BehaviorSubject<RefContractResponseModel> _refdataController =
      BehaviorSubject<RefContractResponseModel>();

  BBBAPIProvider _api;

  RefManager({BBBAPIProvider api}) : _api = api;

  firstLoadData() async {
    RefContractResponseModel _ = await refreshRefData();
    changeUpContractId(upContract.first.contractId);
    changeDownContractId(downContract.first.contractId);

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
