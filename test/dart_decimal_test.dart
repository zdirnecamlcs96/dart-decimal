import 'package:dart_decimal/dart_decimal.dart';
import 'package:test/test.dart';

void main() {
  group("Addition / Subtraction", () {
    test('0 - 0.00039806763285024154', () {
      final left = DartDecimal(amount: 0, precision: 0);
      final right =
          DartDecimal.fromDecimal(amount: -3.9806763285024154, precision: 4);
      final result = left + right;
      expect(result.amount, -398067632850242);
      expect(result.precision, 18);
    });

    test('0.3824 - 0.00039806763285024154 = 0.3820019324', () {
      final left =
          DartDecimal.fromDecimal(amount: 3824, precision: 4); // 3824 / 10000
      final right = DartDecimal.fromDecimal(
          amount: -3.9806763285024154,
          precision: 4); // -39806763285024154 / 100000000000000000000
      final result = left + right;
      expect(result.amount, 382001932367149758); // 0.3824 - 0.0004 = 0.3820
      expect(result.precision, 18);
    });

    test('1 + 0.5 == 1.5', () {
      final a = DartDecimal(amount: 1, precision: 0);
      final b = DartDecimal(amount: 5, precision: 1);
      final result = a + b;
      expect(result.amount, 15);
      expect(result.precision, 1);
    });

    test('1 - 0.5 == 0.5', () {
      final a = DartDecimal(amount: 1, precision: 0);
      final b = DartDecimal(amount: 5, precision: 1);
      final result = a - b;
      expect(result.amount, 5);
      expect(result.precision, 1);
    });
  });

  group("Multiplication", () {
    test('10 * 0.3 == 3', () {
      final left = DartDecimal(amount: 10, precision: 0);
      final right = DartDecimal(amount: 3, precision: 1);

      final result = left * right;
      expect(result.amount, 30);
      expect(result.precision, 1);
    });

    test('10 * 1 == 1', () {
      final left = DartDecimal(amount: 10, precision: 0);
      final right = DartDecimal(amount: 1, precision: 0);

      final result = left * right;
      expect(result.amount, 10);
      expect(result.precision, 0);
    });

    test('0.3 * 0.3 == 0.09', () {
      final left = DartDecimal(amount: 3, precision: 1);
      final right = DartDecimal(amount: 3, precision: 1);

      final result = left * right;
      expect(result.amount, 9);
      expect(result.precision, 2);
    });

    test('3 * 3 == 9', () {
      final left = DartDecimal(amount: 3, precision: 0);
      final right = DartDecimal(amount: 3, precision: 0);

      final result = left * right;
      expect(result.amount, 9);
      expect(result.precision, 0);
    });

    test('0.002 / 3 == 0', () {
      final left = DartDecimal(amount: 2, precision: 3);
      final right = DartDecimal(amount: 3, precision: 0);

      final result = left / right;
      expect(result.toDouble().truncateToDouble(), 0);
    });
  });
}
