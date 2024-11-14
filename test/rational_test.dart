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
      expect(
        () => RationalNumber.parse(a).numerator,
        throwsA(
          predicate((e) =>
              e is FormatException &&
              e.message == 'Positive input exceeds the limit of integer'),
        ),
      );

      String b = "1.2345e+5"; // 123450.0
      expect(RationalNumber.parse(b).numerator, equals(123450));
      expect(RationalNumber.parse(b).denominator, equals(1));

      String c = "1.000000000000000000";
      expect(RationalNumber.parse(c).numerator, equals(1));
      expect(RationalNumber.parse(c).denominator, equals(1));

      String d = "1.000050000000000000";
      expect(RationalNumber.parse(d).numerator, equals(100005));
      expect(RationalNumber.parse(d).denominator, equals(pow(10, 5)));
    });

    test("scientific notation with precision", () {
      String amount = "9.223372036854776e+24";
      int precision = 50;

      /// 9.223372036854776e+24
      /// = (9223372036854776 * 10^-15) * 10^24
      /// = 9223372036854776 × 10^(-15+24)
      /// = 9223372036854776 × 10^9

      /// 9223372036854776 × 10^9 / 10^50
      /// = 9223372036854776 × 10^(9-50)
      /// = 9223372036854776 / 10^-41
      final rational = RationalNumber.fromDecimal(amount, precision);

      expect(rational.numerator, equals(0));
      expect(rational.denominator, equals(1));
    });
  });
}
