import 'dart:async';

import 'package:rxdart/rxdart.dart';

const Time_GAP_SECONDS = 3;

class Ticker {
  int t;

  Ticker(int t);
}

class TimerManager {
  Stream<Ticker> get tick => _tick.stream;
  BehaviorSubject<Ticker> _tick = BehaviorSubject<Ticker>();

  Timer _timer;

  start() {
    _timer = Timer.periodic(Duration(seconds: Time_GAP_SECONDS), (t) {
      _tick.add(Ticker(t.tick));
    });
  }
}
