import 'dart:math';

import 'package:test/test.dart';
import 'package:dart_decimal/src/rational.dart';

void main() {
  // test('stress test', () {
  //   final start = 0.001;
  //   final end = 10;

  //   for (num i = start; i <= end; i++) {
  //     for (num j = start; j <= end; j++) {
  //       final rational1 = RationalNumber.parse(i);
  //       final rational2 = RationalNumber.parse(j);
  //       final result = rational1 + rational2;
  //       print('$i + $j = ${result.numerator}');
  //       expect(result.numerator, equals(i + j));
  //       expect(result.denominator, equals(1));
  //     }
  //   }
  // });

  group("scientific notation", () {
    test("scientific notation", () {
      /// 15 fractional digits
      /// 24 exponent digits
      String a = "9.223372036854776e+24";
      expect(RationalNumber.parse(a).numerator,
          BigInt.parse("9223372036854776000000000"));

      String b = "1.2345e+5"; // 123450.0
      expect(RationalNumber.parse(b).numerator, equals(123450.toBigInt()));
      expect(RationalNumber.parse(b).denominator, equals(BigInt.one));

      String c = "1.000000000000000000";
      expect(RationalNumber.parse(c).numerator, equals(BigInt.one));
      expect(RationalNumber.parse(c).denominator, equals(BigInt.one));

      String d = "1.000050000000000000";
      expect(RationalNumber.parse(d).numerator, equals(100005.toBigInt()));
      expect(RationalNumber.parse(d).denominator, equals(10.toBigInt().pow(5)));

      /// Max precision is 18, so the last 2 digits are ignored
      String e = "0.1234567890123456789";
      expect(RationalNumber.parse(e).numerator,
          equals(123456789012345678.toBigInt()));
      expect(
          RationalNumber.parse(e).denominator, equals(10.toBigInt().pow(18)));

      final f = RationalNumber.parse("0.1999999999999999999");
      expect(f.numerator, equals(199999999999999999.toBigInt()));
      expect(f.denominator, equals(10.toBigInt().pow(18)));
    });

    test("toScientificNotation", () {
      expect(0.1234567890123456789.toStringAsExponential(),
          equals("1.2345678901234568e-1"));
      // expect(1234567890123456789.toScientificNotation()[0],
      //     equals("1.234567890123456789"));
      // expect(1234567890123456789.toScientificNotation()[1], equals("18"));
      // expect(0.1234567890123456789.toScientificNotation()[0],
      //     equals("1.234567890123456789"));
      // expect(0.1234567890123456789.toScientificNotation()[1], equals("-1"));
      // expect(0.0000000000000000001.toScientificNotation()[0], equals("1.0"));
      // expect(0.0000000000000000001.toScientificNotation()[1], equals("-19"));
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
      final rational = RationalNumber.fromDecimal(amount, precision);

      expect(rational.numerator, equals(9223372036854776.toBigInt()));
      expect(
          rational.denominator,
          equals(BigInt.parse(
              "100000000000000000000000000000000000000000"))); // 10^41
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
    });
  });
}
