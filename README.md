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

<!-- ## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more. -->

## Disclaimer

This project is intended for personal use only. Use at your own risk. No warranty or support is provided. However, you are welcome to raise issues or submit pull requests.

## License

This project is licensed under the [MIT License](./LICENSE).

## Acknowledgements

- Inspired by [dart-decimal](https://github.com/a14n/dart-decimal).
- Learned about scientific notation from [MathsIsFun](https://www.mathsisfun.com/numbers/scientific-notation.html).
