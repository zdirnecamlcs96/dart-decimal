import 'package:dart_decimal/dart_decimal.dart';

void main() {
  final a = DartDecimal(amount: 1005, precision: 3);
  final b = DartDecimal.parse(1000);
  final result = a - b;
  print(result); // 1.005
}
