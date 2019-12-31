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
  BehaviorSubject<Ticker> _tick = BehaviorSubject<Ticker>();
  BehaviorSubject<Ticker> _rankingUpdate = BehaviorSubject<Ticker>();

  Timer _timer;

  start() {
    _timer = Timer.periodic(Duration(seconds: Time_GAP_SECONDS), (t) {
      _tick.add(Ticker(t.tick));
    });
  }

  rankingUpdateStart() {
    Timer.periodic(Duration(hours: 1), (t) {
      _rankingUpdate.add(Ticker(t.tick));
    });
  }
}
