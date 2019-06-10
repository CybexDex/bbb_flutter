import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bbb_flutter/env.dart';

class RefDataBloc {
  final BehaviorSubject<RefContractResponseModel> _subject =
      BehaviorSubject<RefContractResponseModel>();

  getRefData() async {
    RefContractResponseModel response = await Env.apiClient.getRefData();
    log.info(response.chainId);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<RefContractResponseModel> get subject => _subject;
}

final bloc = RefDataBloc();
