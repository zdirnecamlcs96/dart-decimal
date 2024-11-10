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
