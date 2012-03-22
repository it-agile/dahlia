Expectation expect(var actual) => new Expectation(actual);

class Expectation {
  final actual;
  const Expectation(this.actual);
  
  to(Matcher matcher) {
    if (!matcher.matches(actual)) {
      throw new ExpectationException(matcher.describeExpectation(actual));  
    }
  }  
}

class ExpectationException implements Exception {
  final String failedExpectation;
  const ExpectationException(this.failedExpectation);
  String toString() => "Expectation failed: $failedExpectation";  
}
