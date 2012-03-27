interface Matcher {
  bool matches(var actual);
  String describeExpectation(var actual);
}