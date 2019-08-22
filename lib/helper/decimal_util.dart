import 'dart:math';

String floor(double num, int precision) {
  return (((num * pow(10, precision)).floor()) / pow(10, precision))
      .toStringAsFixed(precision);
}
