import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:rxdart/subjects.dart';

class RefManager {
  Stream<RefContractResponseModel> get data => _refdataController.stream;
  RefContractResponseModel get lastData => _refdataController.value;

  Contract get currentContract {
    if (_contractId == null) {
      return null;
    }
    return lastData?.contract
        ?.where((contract) {
          return contract.contractId == _contractId;
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
  String _contractId;

  RefManager({BBBAPIProvider api}) : _api = api;

  firstLoadData() async {
    RefContractResponseModel data = await refreshRefData();
    _contractId = data.contract.first.contractId;

    startLoop();
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
