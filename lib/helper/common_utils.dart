int getNowEpochSeconds() {
  return DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
}

bool isAllEmpty(Object object) {
  if (object == null) return true;
  if (object is String && object.isEmpty) {
    return true;
  } else if (object is List && object.isEmpty) {
    return true;
  } else if (object is Map && object.isEmpty) {
    return true;
  }
  return false;
}

DateTime removeSeconds(DateTime time) {
  if (time == null) {
    return null;
  }
  return time.subtract(Duration(
      seconds: time.second,
      milliseconds: time.millisecond,
      microseconds: time.microsecond));
}

DateTime ceilSecondsToMinute(DateTime time) {
  if (time == null) {
    return null;
  }
  return time.add(Duration(minutes: 1)).subtract(Duration(
      seconds: time.second,
      milliseconds: time.millisecond,
      microseconds: time.microsecond));
}
