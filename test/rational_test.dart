import 'package:test/test.dart';
import 'package:dart_decimal/src/rational.dart';

void main() {
  test('stress test', () {
    final start = 0.001;
    final end = 10;

    for (num i = start; i <= end; i++) {
      for (num j = start; j <= end; j++) {
        final rational1 = RationalNumber.parse(i);
        final rational2 = RationalNumber.parse(j);
        final result = rational1 + rational2;
        print('$i + $j = ${result.numerator}');
        expect(result.numerator, equals(i + j));
        expect(result.denominator, equals(1));
      }
    }
  });
}
