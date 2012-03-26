EqualMatcher equal(var expected) => new EqualMatcher(expected);
NotMatcher not(Matcher matcher) => new NotMatcher(matcher);
ThrowMatcher throwA([Function exceptionChecker, String exceptionType]) => new ThrowMatcher(exceptionChecker, exceptionType);

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

class ThrowMatcher implements Matcher {
  final Function exceptionChecker;
  final String exceptionType;
  const ThrowMatcher([this.exceptionChecker, this.exceptionType]);
  
  matches(var actual) {
    if (!(actual is Function)) {
      throw new Exception('the actual needs to be a function');
    }
    try {
      actual();
    } catch(var exception) {
      if (exceptionChecker != null && !exceptionChecker(exception)) {
        throw exception;
      }
      return true;
    }
    return false;
  }
  
  String describeExpectation(var actual) {
    String typePart = (exceptionType != null ? 'a $exceptionType' : 'something');
    return 'actual to throw $typePart';    
  }
}
