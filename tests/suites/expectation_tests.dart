class ExpectationTestMatcher implements Matcher {
  bool match;
  
  bool matches(var actual) {
    return match;  
  }
  
  String describeExpectation(var actual) {
    return 'desc';
  }
}

expectationTests() {
  describe('Expectation', () {
    Expectation expectation = new Expectation(null);
    ExpectationTestMatcher matcher = new ExpectationTestMatcher();
    
    it("should throw an expectation exception when the matcher doesn't match", () {
      matcher.match = false;
      expect(() {expectation.to(matcher);}).to(throwA((thrown) => thrown is ExpectationException));
      expect(() {expectation.to(matcher);}).to(throwA((thrown) => thrown.toString() == 'Expectation failed: desc'));
    });
    it("should not throw an expectation exception when the matcher matches", () {
      matcher.match = true;
      expectation.to(matcher);
    });
  });  
}
