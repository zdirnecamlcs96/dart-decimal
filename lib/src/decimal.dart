import 'dart:math';

import 'package:dart_decimal/src/utils.dart';

class DartDecimal implements Comparable<DartDecimal> {
  int amount;
  int precision;

  DartDecimal(this.amount, this.precision);

  static parse(num value) {
    final precision = getPrecision(value, trailingZeroes: false);

    int eIndex = value.toString().indexOf('e');
    if (eIndex != -1) {
      var str = value.toString().substring(0, eIndex);
      value = double.parse(str);
    }

    final amount = (value * pow(10, precision)).toInt();

    return DartDecimal(amount, precision);
  }

  double toDouble() {
    final precision = min(this.precision, 18);
    final v = amount / pow(10, precision);
    return double.parse(v.toStringAsFixed(precision.toInt()));
  }

  @override
  int compareTo(DartDecimal b) {
    var aDouble = toDouble();
    var bDouble = b.toDouble();
    if (aDouble > bDouble) return 1; // a > b
    if (aDouble < bDouble) return -1; // b > a
    return 0; // a == b
  }
}
