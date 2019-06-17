import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bloc_provider/bloc_provider.dart';

class RefDataBloc implements Bloc {
  static RefDataBloc _singleton = RefDataBloc._internal();
  RefDataBloc._internal();

  factory RefDataBloc() {
    _singleton = _singleton ?? RefDataBloc._internal();
    return _singleton;
  }

  final BehaviorSubject<RefContractResponseModel> _subject =
      BehaviorSubject<RefContractResponseModel>();

  getRefData() async {
    RefContractResponseModel response = await Env.apiClient.getRefData();
    _subject.sink.add(response);
  }

  @override
  dispose() async {
    await _subject.close();
  }

  BehaviorSubject<RefContractResponseModel> get subject => _subject;
}
