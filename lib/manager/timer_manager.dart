import 'dart:async';

import 'package:rxdart/rxdart.dart';

const Time_GAP_SECONDS = 3;

class Ticker {
  int t;

  Ticker(int t);
}

class TimerManager {
  Stream<Ticker> get tick => _tick.stream;
  Stream<Ticker> get rankingUpdate => _rankingUpdate.stream;
  Stream<Ticker> get refDataUpdate => _refDataUpdte.stream;
  BehaviorSubject<Ticker> _tick = BehaviorSubject<Ticker>();
  BehaviorSubject<Ticker> _rankingUpdate = BehaviorSubject<Ticker>();
  BehaviorSubject<Ticker> _refDataUpdte = BehaviorSubject<Ticker>();

  start() {
    Timer.periodic(Duration(seconds: Time_GAP_SECONDS), (t) {
      _tick.add(Ticker(t.tick));
    });
  }

  rankingUpdateStart() {
    Timer.periodic(Duration(hours: 1), (t) {
      _rankingUpdate.add(Ticker(t.tick));
    });
  }

  refDataUpdateStart() {
    Timer.periodic(Duration(days: 1), (t) {
      _refDataUpdte.add(Ticker(t.tick));
    });
  }
}
