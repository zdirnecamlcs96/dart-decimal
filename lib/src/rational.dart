import 'dart:math';

final _pattern = RegExp(r'^([+-]?\d*)(\.\d*)?([eE][+-]?\d+)?$');

class RationalNumber {
  final int numerator;
  final int denominator;

  RationalNumber(this.numerator, this.denominator) {
    if (denominator == 0) {
      throw ArgumentError('Denominator cannot be zero');
    }
  }

  int _gcd(int a, int b) {
    if (b == 0) {
      return a;
    }
    return _gcd(b, a % b);
  }

  static RationalNumber zero() {
    return RationalNumber(0, 1);
  }

  RationalNumber simplify() {
    final gcd = _gcd(numerator, denominator);
    return RationalNumber(numerator ~/ gcd, denominator ~/ gcd);
  }

  static RationalNumber fromDecimal(String number, int precision) {
    final regexMatch = _pattern.firstMatch(number);

    if (regexMatch == null) {
      throw ArgumentError('Invalid number format');
    }

    final integerDigits = regexMatch.group(1);

    if (integerDigits == null) {
      throw ArgumentError('Invalid number format');
    }

    var totalDigits = integerDigits.length;

    final floatingPointDigits = regexMatch.group(2);

    if (floatingPointDigits != null) {
      totalDigits += floatingPointDigits.substring(1).length;
    }

    final exponentDigits = regexMatch.group(3);

    if (exponentDigits != null) {
      var exponent = int.parse(exponentDigits.substring(1));
      if (floatingPointDigits != null) {
        exponent -= floatingPointDigits.substring(1).length;
      }
      exponent -= precision;

      if (exponent < 0 && exponent.abs() > totalDigits) {
        return zero();
      }
    }

    return RationalNumber.parse(number);
  }

  static RationalNumber parse(String value) {
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

    int numerator = 0;
    int denominator = 1;

    if (floatingPointDigits != null) {
      for (var i = 1; i < floatingPointDigits.length; i++) {
        denominator = denominator * 10;
      }
      numerator =
          int.parse("$integerDigits${floatingPointDigits.substring(1)}");
    } else {
      numerator = int.parse(integerDigits);
    }

    if (exponentDigits != null) {
      final exponent = int.parse(exponentDigits.substring(1));

      // /// pow(10, 19) = -8446744073709551616
      // /// pow(10, 20) = 7766279631452241920
      if (exponent > 0) {
        String numeratorString = numerator.toString();
        for (var i = 0; i < exponent; i++) {
          numeratorString += '0';
        }
        try {
          numerator = int.parse(numeratorString);
        } catch (e) {
          if (e is FormatException) {
            /// reduce the exponent to 18
            final powerOfTen = (log(denominator) / log(10)).floor() + exponent;
            final diffPrecision = powerOfTen - 18;

            String denominatorString = denominator.toString();

            for (var i = 0; i < diffPrecision; i++) {
              numeratorString =
                  numeratorString.substring(0, numeratorString.length - 1);
              denominatorString = denominatorString.substring(
                  0, denominator.toString().length - 1);
            }

            numerator = int.parse(numeratorString);
            denominator = int.parse(denominatorString);
          }
        }
      } else {
        denominator *= pow(10, -exponent).toInt();
      }
    }

    if (numerator == denominator) {
      return RationalNumber(1, 1);
    }

    return RationalNumber(numerator, denominator)._removeTrailingZeros();
  }

  /// numerator - 10
  /// denominator - 10
  RationalNumber _removeTrailingZeros() {
    int countTrailingZeros(int number) {
      int count = 0;

      while (number % 10 == 0) {
        count++;
        number ~/= 10; // Use integer division to remove the last digit
      }

      return count;
    }

    final numeratorZeros = countTrailingZeros(numerator);
    final denominatorZeros = countTrailingZeros(denominator);

    final zeros = min(numeratorZeros, denominatorZeros);

    int newNumerator = numerator;
    int newDenominator = denominator;

    for (var i = 0; i < zeros; i++) {
      newNumerator ~/= 10;
      newDenominator ~/= 10;
    }

    return RationalNumber(newNumerator, newDenominator);
  }

  static RationalNumber? tryParse(String value) {
    try {
      return parse(value);
    } catch (e) {
      return null;
    }
  }

  RationalNumber operator +(RationalNumber other) {
    int newNumerator =
        numerator * other.denominator + other.numerator * denominator;
    int newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator);
  }

  RationalNumber operator -(RationalNumber other) {
    int newNumerator =
        numerator * other.denominator - other.numerator * denominator;
    int newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator);
  }

  RationalNumber operator *(RationalNumber other) {
    int newNumerator = numerator * other.numerator;
    int newDenominator = denominator * other.denominator;
    return RationalNumber(newNumerator, newDenominator);
  }

  RationalNumber operator /(RationalNumber other) {
    if (other.numerator == 0) {
      throw ArgumentError("Cannot divide by zero");
    }
    int newNumerator = numerator * other.denominator;
    int newDenominator = denominator * other.numerator;
    return RationalNumber(newNumerator, newDenominator);
  }

  int operator %(RationalNumber other) {
    if (other.numerator == 0) {
      throw ArgumentError("Cannot divide by zero");
    }
    return numerator % other.numerator;
  }
}
