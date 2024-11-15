BigInt logBase10(BigInt n) {
  assert(n > BigInt.zero, "Logarithm undefined for non-positive values");

  BigInt count = BigInt.zero;
  while (n > BigInt.one) {
    n = n ~/ BigInt.from(10); // Divide by 10
    count = count + BigInt.one; // Increment count
  }

  return count;
}
