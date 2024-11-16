<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Dart Decimal

## Features

Dart Library that solve the floating point issue by using `BigInt`.

**Note:** `DartDecimal` supports precision up to 18 digits because it uses `int` instead of `BigInt`. The purpose is to avoid unnecessarily large numbers or high precision, as they weren't needed for my use case. Additionally, `int` uses a fixed amount of memory and may be more efficient than `BigInt`.

## Getting started

```yaml
# pubspec.yaml
dependencies:
  dart_decimal:
    git:
      url: git@github.com:zdirnecamlcs96/dart-decimal.git
      ref: main
```

```bash
$ flutter pub upgrade dart_decimal
```

## Usage

<!-- TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. -->

```dart
// 1.005 * 1000 = 1004.9999999999999
final a = DartDecimal(amount: 1005, precision: 3);
final b = DartDecimal.parse(1000);
final result = a - b; // 1.005
```

## Edge Cases

### Intermediate rounding with limited precision

When performing calculations with limited precision (e.g., rounding to 10 decimal places), discrepancies can arise if intermediate results are rounded too early. Rounding early may cause small errors when those rounded values are used in subsequent calculations, leading to minor discrepancies in the final result.

#### Example 1: Continuous Calculation (No Intermediate Rounding)

```dart
// No rounding until the final result (a / b * c)
final a = DartDecimal.parse(114.4);
final b = DartDecimal.parse(15.2);
final c = a / b; // 7.526315789473684 (full precision)
final result = c * b; // 114.4 (exact result)
```

#### Example 2: Intermediate Rounding (Round After Division)

```dart
// Intermediate rounding (a / b).roundTo(10) * c
final a = DartDecimal.parse(114.4);
final b = DartDecimal.parse(15.2);
final c = (a / b)roundToPrecision(10); // 7.5263157895 (rounded to 10 decimal places)
final result = c * b; // 114.4000000004 (slight discrepancy due to rounding)
```

### How to handle it

1. **Avoid Intermediate Rounding** to prevent such discrepancies.
2. For the use case above, **check if `b` is the same as the `c`** and return `a` directly without further manipulation to ensure the expected outcome.

## Disclaimer

This project is intended for personal use only. Use at your own risk. No warranty or support is provided. However, you are welcome to raise issues or submit pull requests.

## License

This project is licensed under the [MIT License](./LICENSE).

## Acknowledgements

- Inspired by [dart-decimal](https://github.com/a14n/dart-decimal).
- Learned about scientific notation from [MathsIsFun](https://www.mathsisfun.com/numbers/scientific-notation.html).
