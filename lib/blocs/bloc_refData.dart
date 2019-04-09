import 'package:bbb_flutter/models/ref_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bbb_flutter/env.dart';

class RefDataBloc {
  final BehaviorSubject<RefData> _subject = BehaviorSubject<RefData>();

  getRefData() async {
    RefData response = await Env.apiClient.getRefData();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<RefData> get subject => _subject;

}
final bloc = RefDataBloc();