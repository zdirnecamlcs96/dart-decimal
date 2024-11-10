/// Get the precision of a double [value].
///
/// For example
/// * 1.005 returns 3
/// * 1.0050 returns 4
/// * 1.2777020353250294e+304 returns 16
int getPrecision(
  num value, {
  bool trailingZeroes = true,
}) {
  String amountStr = value.toString();
  int dotIndex = amountStr.indexOf('.');
  int eIndex = amountStr.indexOf('e');
  if (dotIndex == -1) {
    return 0;
  }

  // If there's an exponent part, calculate precision up to 'e'
  if (eIndex != -1) {
    amountStr = amountStr.substring(0, eIndex);
  }

  if (trailingZeroes) {
    return amountStr.length - dotIndex - 1;
  }

  return amountStr.length - dotIndex - 1 - extractTrailingZeroes(value);
}

int extractTrailingZeroes(num value) {
  final amountStr = value.toString();
  final dotIndex = amountStr.indexOf('.');
  if (dotIndex == -1) {
    return 0;
  }
  var trailingZeroes = 0;
  for (var i = amountStr.length - 1; i > dotIndex; i--) {
    if (amountStr[i] == '0') {
      trailingZeroes++;
    } else {
      break;
    }
  }
  return trailingZeroes;
}
