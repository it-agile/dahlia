EqualMatcher equal(var expected) => new EqualMatcher(expected);
NotMatcher not(Matcher matcher) => new NotMatcher(matcher);
BeTrueMatcher beTrue() => new BeTrueMatcher();
BeFalseMatcher beFalse() => new BeFalseMatcher();
BeNullMatcher beNull() => new BeNullMatcher();
ThrowMatcher throwA([ExceptionCheckerFunction exceptionChecker, String exceptionType]) => new ThrowMatcher(exceptionChecker, exceptionType);

class EqualMatcher implements Matcher {
  final expected;
  const EqualMatcher(this.expected);
  
  bool matches(var actual) => (expected == actual);
  String describeExpectation(var actual) => 'actual "$actual" to equal the expected "$expected"';
}

class NotMatcher implements Matcher {
  final Matcher matcherToNegate;
  const NotMatcher(this.matcherToNegate);
  
  bool matches(var actual) => !matcherToNegate.matches(actual);
  String describeExpectation(var actual) => 'not(${matcherToNegate.describeExpectation(actual)})';    
}

class BeTrueMatcher implements Matcher {
  bool matches(final actual) => actual == true;
  String describeExpectation(var actual) => 'actual "$actual" to be true';
}

class BeFalseMatcher implements Matcher {
  bool matches(final actual) => actual != true;
  String describeExpectation(var actual) => 'actual "$actual" to be false';
}

class BeNullMatcher implements Matcher {
  bool matches(final actual) => actual == null;
  String describeExpectation(var actual) => 'actual "$actual" to be null';
}

typedef ExceptionCheckerFunction(var thrown);

class ThrowMatcher implements Matcher {
  final ExceptionCheckerFunction exceptionChecker;
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
