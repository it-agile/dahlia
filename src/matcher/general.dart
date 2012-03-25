EqualMatcher equal(var expected) => new EqualMatcher(expected);
NotMatcher not(Matcher matcher) => new NotMatcher(matcher);

class EqualMatcher implements Matcher {
  final expected;
  const EqualMatcher(this.expected);
  
  matches(var actual) {
    return (expected == actual);
  }
  
  String describeExpectation(var actual) {
    return 'actual "$actual" to equal the expected "$expected"';
  }
}

class NotMatcher implements Matcher {
  final Matcher matcherToNegate;
  const NotMatcher(this.matcherToNegate);
  
  matches(var actual) {
    return !matcherToNegate.matches(actual);
  }
  
  String describeExpectation(var actual) {
    return 'not(${matcherToNegate.describeExpectation(actual)})';    
  }
}
