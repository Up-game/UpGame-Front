class Pair<T, U> {
  final T first;
  final U second;
  const Pair(this.first, this.second);
  @override
  String toString() => '($first, $second)';
}
