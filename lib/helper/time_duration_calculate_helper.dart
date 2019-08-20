DateTime getCorrectTime() {
  DateTime time = DateTime.now();
  if (time.minute % 5 <= 2) {
    time = time.subtract(Duration(minutes: time.minute % 5));
  } else {
    time = time.add(Duration(minutes: (5 - time.minute % 5)));
  }
  return time;
}
