StartWithMatcher startWith(var expected) => new StartWithMatcher(expected);
ContainSubstringMatcher containSubstring(var expected) => new ContainSubstringMatcher(expected);

class StartWithMatcher implements Matcher {
  final expected;
  const StartWithMatcher(this.expected);
  
  matches(var actual) {
    return (actual.startsWith(expected));
  }
  
  String describeExpectation(var actual) {
    return 'actual "$actual" to start with the expected "$expected"';
  }
}

class ContainSubstringMatcher implements Matcher {
  final expected;
  const ContainSubstringMatcher(this.expected);

  matches(var actual) {
    return (actual.contains(expected));
  }
  
  String describeExpectation(var actual) {
    return 'actual "$actual" to contain the expected "$expected"';
  }
}
