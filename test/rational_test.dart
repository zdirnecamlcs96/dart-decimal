import 'dart:math';

import 'package:test/test.dart';
import 'package:dart_decimal/src/rational.dart';

void main() {
  group("scientific notation", () {
    test("scientific notation", () {
      /// 15 fractional digits
      /// 24 exponent digits
      final a = RationalNumber.parse("9.223372036854776e+24");
      expect(a.numerator, BigInt.parse("9223372036854776000000000"));

      final b = RationalNumber.parse("1.2345e+5"); // 123450.0
      expect(b.numerator, equals(123450.toBigInt()));
      expect(b.denominator, equals(BigInt.one));

      final c = RationalNumber.parse("1.000000000000000000");
      expect(c.numerator, equals(BigInt.one));
      expect(c.denominator, equals(BigInt.one));

      final d = RationalNumber.parse("1.000050000000000000");
      expect(d.numerator, equals(100005.toBigInt()));
      expect(d.denominator, equals(10.toBigInt().pow(5)));

      /// Max precision is 18, so the last 2 digits are ignored
      final e = RationalNumber.parse("0.1234567890123456789");
      expect(e.numerator, equals(123456789012345678.toBigInt()));
      expect(e.denominator, equals(10.toBigInt().pow(18)));

      final f = RationalNumber.parse("0.1999999999999999999");
      expect(f.numerator, equals(199999999999999999.toBigInt()));
      expect(f.denominator, equals(10.toBigInt().pow(18)));
    });

    test("scientific notation with precision", () {
      num amount = 9.223372036854776e+24;
      int precision = 50;

      /// 9.223372036854776e+24
      /// = (9223372036854776 * 10^-15) * 10^24
      /// = 9223372036854776 × 10^(-15+24)
      /// = 9223372036854776 × 10^9

      /// 9223372036854776 × 10^9 / 10^50
      /// = 9223372036854776 × 10^(9-50)
      /// = 9223372036854776 / 10^-41
      final a = RationalNumber.fromDecimal(amount, precision);

      expect(a.numerator, equals(BigInt.zero));
      expect(a.denominator, equals(BigInt.one));

      final b = RationalNumber.parse(
        11440.toStringAsExponential(),
        precision: 2,
      );
      expect(b.numerator, equals(1144.toBigInt()));
      expect(b.denominator, equals(10.toBigInt()));
    });

    test("Subtraction", () {
      final result = RationalNumber.parse("0") -
          RationalNumber.fromDecimal(3.9806763285024154, 4);

      /// 0.00039806763285024154
      /// = 39806763285024154 / 10^(-20)
      /// = 39806763285024154 / 10^(-20)
      expect(result.numerator, equals(-398067632850242.toBigInt()));
      expect(result.denominator,
          equals(BigInt.parse("1000000000000000000"))); // 10^18

      final doubleResult = result.toValidDouble();
      expect(doubleResult, equals(-0.000398067632850242));
    });

    test("Division", () {
      final result = RationalNumber.parse("120") / RationalNumber.parse("228");
      expect(result.numerator, equals(120.toBigInt()));
      expect(result.denominator, equals(228.toBigInt()));
      final doubleResult = result.toValidDouble();
      expect(doubleResult, equals(0.5263157894736842));

      final doubleToRational = RationalNumber.parse(doubleResult.toString());
      expect(doubleToRational.numerator, equals(5263157894736842.toBigInt()));
      expect(doubleToRational.denominator, equals(pow(10, 16).toBigInt()));

      expect(() => RationalNumber.parse("1") / RationalNumber.parse("0"),
          throwsA(predicate((e) => e is AssertionError)));

      final zero1 = RationalNumber.parse("0") / RationalNumber.parse("228");
      expect(zero1.numerator, equals(BigInt.zero));
    });

    test("Multiply", () {
      final zero1 = RationalNumber.parse("1234") * RationalNumber.parse("0");
      expect(zero1.numerator, equals(BigInt.zero));
      expect(zero1.denominator, equals(BigInt.one));

      final zero2 = RationalNumber.parse("0") * RationalNumber.parse("77834");
      expect(zero2.numerator, equals(BigInt.zero));
      expect(zero1.denominator, equals(BigInt.one));
    });

    test("Round Up", () {
      final doubleToRational = RationalNumber.parse("0.5263157894736842");
      expect(doubleToRational.numerator, equals(5263157894736842.toBigInt()));
      expect(doubleToRational.denominator, equals(pow(10, 16).toBigInt()));

      final rounded = doubleToRational.roundTo(10);
      expect(rounded.numerator, equals(5263157895.toBigInt()));
      expect(rounded.denominator, equals(pow(10, 10).toBigInt()));
    });
  });
}
