import 'dart:math';

import 'package:dart_decimal/src/rational.dart';
import 'package:dart_decimal/src/utils.dart';

// const int64_max = 2 ^ 63 - 1;
// const int64_min = -2 ^ 63;

class DartDecimal implements Comparable<DartDecimal> {
  late final RationalNumber _rational;

  int amount;
  int precision;

  DartDecimal({
    required this.amount,
    required this.precision,
  }) {
    _rational =
        RationalNumber(amount.toBigInt(), BigInt.from(10).pow(precision));
  }

  static DartDecimal fromDecimal({
    required num amount,
    required int precision,
  }) {
    final rationalNum = RationalNumber.parse(amount.toStringAsExponential(),
        precision: precision);
    return DartDecimal(
      amount: rationalNum.numerator.toInt(),
      precision: logBase10(rationalNum.denominator).toInt(),
    );
  }

  static parse(num value) {
    final precision = getPrecision(value, trailingZeroes: false);

    int eIndex = value.toString().indexOf('e');
    if (eIndex != -1) {
      var str = value.toString().substring(0, eIndex);
      value = double.parse(str);
    }

    final amount = (value * pow(10, precision)).toInt();

    return DartDecimal(
      amount: amount,
      precision: precision,
    );
  }

  double toDouble() {
    final precision = min(this.precision, 18);
    final v = amount / pow(10, precision);
    return double.parse(v.toStringAsFixed(precision.toInt()));
  }

  DartDecimal operator +(DartDecimal other) {
    final newAmount = _rational + other._rational;

    return DartDecimal(
      amount: newAmount.numerator.toInt(),
      precision: logBase10(newAmount.denominator).toInt(),
    );
  }

  DartDecimal operator -(DartDecimal other) {
    final newAmount = _rational - other._rational;

    return DartDecimal(
      amount: newAmount.numerator.toInt(),
      precision: logBase10(newAmount.denominator).toInt(),
    );
  }

  DartDecimal operator *(DartDecimal other) {
    var newAmount = amount * other.amount;
    var newPrecision = precision + other.precision;
    return DartDecimal(
      amount: newAmount,
      precision: newPrecision,
    );
  }

  DartDecimal operator /(DartDecimal other) {
    var newAmount = amount ~/ other.amount;
    var newPrecision = precision - other.precision;

    if (newPrecision > maxPrecision) {
      newAmount = newAmount ~/ pow(10, newPrecision - maxPrecision);
      newPrecision = maxPrecision;
    }

    if (newPrecision < 0) {
      newAmount = newAmount ~/ pow(10, newPrecision.abs());
      newPrecision = 0;
    }

    return DartDecimal(
      amount: newAmount,
      precision: newPrecision,
    );
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
