import 'dart:math';

final _pattern = RegExp(r'^([+-]?\d*)(\.\d*)?([eE][+-]?\d+)?$');

/// pow(10, 19) = -8446744073709551616
/// pow(10, 20) = 7766279631452241920
const maxPrecision = 18;

class RationalNumber {
  final BigInt numerator;
  final BigInt denominator;

  RationalNumber(this.numerator, this.denominator) {
    assert(denominator != BigInt.zero, "Division by zero is not allowed");
  }

  num toValidDouble() {
    final s = _simplify(); // possible to reduce computation
    final doubleValue = s.numerator / s.denominator;
    return doubleValue;
  }

  RationalNumber roundTo(int precision) {
    return _limitToMaxPrecision(precision: precision);
  }

  static RationalNumber fromInt(int number) {
    return RationalNumber(BigInt.from(number), BigInt.one);
  }

  static RationalNumber fromDouble(double number) {
    final stringNumber = number.toString();
    return RationalNumber.parse(stringNumber);
  }

  static RationalNumber fromDecimal(num number, int precision) {
    final rationalNum = RationalNumber.parse(number.toStringAsExponential(),
        precision: precision);
    return rationalNum;
  }

  static RationalNumber parse(
    String value, {
    int? precision,
  }) {
    final regexMatch = _pattern.firstMatch(value.toString());

    if (regexMatch == null) {
      throw ArgumentError('Invalid number format');
    }

    final integerDigits = regexMatch.group(1);

    if (integerDigits == null) {
      throw ArgumentError('Invalid number format');
    }

    final floatingPointDigits = regexMatch.group(2);
    final exponentDigits = regexMatch.group(3);

    BigInt numerator = BigInt.zero;
    BigInt denominator = BigInt.one;

    if (floatingPointDigits != null) {
      var ignoredDigits = 0;
      if (floatingPointDigits.length - 1 > maxPrecision) {
        /// ignore the floating point digits after the max precision
        ignoredDigits = floatingPointDigits.length - 1 - maxPrecision;
      }
      for (var i = 1;
          i < min(floatingPointDigits.length, maxPrecision + 1);
          i++) {
        denominator = denominator * 10.toBigInt();
      }

      /// truncate the floating point digits after the max precision without rounding
      numerator = BigInt.parse(
          "$integerDigits${floatingPointDigits.substring(1, floatingPointDigits.length - ignoredDigits)}");
    } else {
      numerator = BigInt.parse(integerDigits);
    }

    if (exponentDigits != null) {
      final exponent =
          int.parse(exponentDigits.substring(1)) - (precision ?? 0);
      if (exponent > 0) {
        String numeratorString = numerator.toString();
        for (var i = 0; i < exponent; i++) {
          numeratorString += '0';
        }
        numerator = BigInt.parse(numeratorString);
      } else {
        denominator = denominator * 10.toBigInt().pow(-exponent);
      }
    }

    return RationalNumber(numerator, denominator)
        ._removeTrailingZeros()
        ._limitToMaxPrecision();
  }

  static RationalNumber? tryParse(String value) {
    try {
      return parse(value);
    } catch (e) {
      return null;
    }
  }

  RationalNumber operator +(RationalNumber other) {
    BigInt newNumerator =
        numerator * other.denominator + other.numerator * denominator;
    BigInt newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator)
        ._removeTrailingZeros()
        ._limitToMaxPrecision();
  }

  RationalNumber operator -(RationalNumber other) {
    BigInt newNumerator =
        numerator * other.denominator - other.numerator * denominator;
    BigInt newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator)
        ._removeTrailingZeros()
        ._limitToMaxPrecision();
  }

  RationalNumber operator *(RationalNumber other) {
    // Special cases: when either numerator is zero
    if (numerator == BigInt.zero || other.numerator == BigInt.zero) {
      return RationalNumber(BigInt.zero, BigInt.one);
    }

    BigInt newNumerator = numerator * other.numerator;
    BigInt newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator)
        ._removeTrailingZeros()
        ._limitToMaxPrecision();
  }

  RationalNumber operator /(RationalNumber other) {
    assert(other.numerator != BigInt.zero, "Division by zero is not allowed");

    // Special case: only when numerator is zero
    if (numerator == BigInt.zero) {
      return RationalNumber(BigInt.zero, BigInt.one);
    }

    // When dividing by x/x, it's same as dividing by 1
    if (other.numerator == other.denominator) {
      return this;
    }

    BigInt newNumerator = numerator * other.denominator;
    BigInt newDenominator = denominator * other.numerator;
    return RationalNumber(newNumerator, newDenominator)
        ._removeTrailingZeros()
        ._limitToMaxPrecision();
  }

  // int operator %(RationalNumber other) {
  //   if (other.numerator == 0) {
  //     throw ArgumentError("Cannot divide by zero");
  //   }
  //   return numerator % other.numerator;
  // }

  RationalNumber _removeTrailingZeros() {
    int countTrailingZeros(BigInt number) {
      if (number == BigInt.zero) {
        return 0;
      }

      int count = 0;

      while (number % 10.toBigInt() == BigInt.zero) {
        count++;
        number ~/=
            10.toBigInt(); // Use integer division to remove the last digit
      }

      return count;
    }

    final numeratorZeros = countTrailingZeros(numerator);
    final denominatorZeros = countTrailingZeros(denominator);

    final zeros = min(numeratorZeros, denominatorZeros);

    BigInt newNumerator = numerator;
    BigInt newDenominator = denominator;

    for (var i = 0; i < zeros; i++) {
      newNumerator ~/= 10.toBigInt();
      newDenominator ~/= 10.toBigInt();
    }

    return RationalNumber(newNumerator, newDenominator);
  }

  RationalNumber _limitToMaxPrecision({
    int precision = maxPrecision,
  }) {
    BigInt newNumerator = numerator;
    BigInt newDenominator = denominator;

    final powerOfTen = newDenominator.toString().length - 1;
    final diffPrecision = powerOfTen - precision;

    for (var i = 0; i < diffPrecision; i++) {
      final remainder = newNumerator % 10.toBigInt();

      if (remainder >= 5.toBigInt()) {
        if (newNumerator.isNegative) {
          newNumerator -= 10.toBigInt() - remainder;
        } else {
          newNumerator += 10.toBigInt() - remainder;
        }
      } else {
        newNumerator -= remainder;
      }

      newNumerator ~/= 10.toBigInt();
      newDenominator ~/= 10.toBigInt();
    }

    /// If the diffPrecision > numerator length, then the numerator probably is zero
    /// Since the numerator is zero, the denominator will always be 1
    if (newNumerator == BigInt.zero) {
      newDenominator = BigInt.one;
    }

    return RationalNumber(newNumerator, newDenominator);
  }

  BigInt _gcd(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return a;
    }
    return _gcd(b, a % b);
  }

  RationalNumber _simplify() {
    BigInt gcd = _gcd(numerator, denominator);
    return RationalNumber(numerator ~/ gcd, denominator ~/ gcd);
  }
}

extension NumExtension on num {
  BigInt toBigInt() {
    return BigInt.from(this);
  }

  List<String> toScientificNotation() {
    var numStr = toStringAsExponential();
    var exponent = 0;

    final regexMatch = _pattern.firstMatch(numStr.toString());

    if (regexMatch == null) {
      throw ArgumentError('Invalid number format');
    }

    final integerDigits = regexMatch.group(1);

    exponent += integerDigits!.length - 1;

    final floatingPointDigits = regexMatch.group(2);

    exponent -= floatingPointDigits?.length ?? 0;

    final exponentDigits = regexMatch.group(3);

    if (exponentDigits != null) {
      exponent += int.parse(exponentDigits.substring(1));
    }

    final dotIndex = numStr.indexOf('.');
    if (dotIndex != -1) {
      var str = numStr.substring(0, dotIndex);
      var decimal = numStr.substring(dotIndex + 1);

      /// Check how many leading zeros are there
      var leadingZeros = 0;
      var fullNumStr = str + decimal;
      for (var i = 0; i < fullNumStr.length; i++) {
        if (fullNumStr[i] == '0') {
          leadingZeros++;
          numStr = fullNumStr.substring(1);
        } else {
          break;
        }
      }
      exponent -= leadingZeros;
    }

    var chars = numStr.split('');
    chars.insert(1, ".");
    numStr = chars.join();

    return [numStr, exponent.toString()];
  }
}
