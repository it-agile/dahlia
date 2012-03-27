generalMatcherTests() {
  describe('equal matcher', () {
    it('should succeed for equal ints', () => expect(1).to(equal(1)));
    it('should succeed for equal Strings', () => expect('test').to(equal('test')));
    it('should succeed for equal objects', () => expect(new Duration(1, 1, 1, 1, 1)).to(equal(new Duration(1, 1, 1, 1, 1))));
    it('should have a description based on the actual and excepted values', () => expect(equal('ex').describeExpectation('ac')).to(equal('actual "ac" to equal the expected "ex"')));
  });

  describe('not matcher', () {
    it('should succeed if the expected value does not match with the actual matcher', () => expect(1).to(not(equal(2))));
  });

  describe('throw matcher', () {
    describe('with no parameters', () {
      ThrowMatcher throwMatcher = throwA();
      it('should succeed for anything that can be thrown', () => expect(() {throw 3;}).to(throwMatcher));
      it('should succeed for an exception', () => expect(() {throw new Exception('e');}).to(throwMatcher));
      it('should fail if nothing is thrown', () => expect(() {}).to(not(throwMatcher)));
      it('should have a generic description', () => expect(throwMatcher.describeExpectation(null)).to(equal('actual to throw something')));
    });
    describe('with an exception checker', () {
      ThrowMatcher throwMatcher = throwA((thrown) => thrown is Exception);
      it('should succeed for an instance of the exact type checked', () => expect(() {throw new Exception('e');}).to(throwMatcher));
      it('should succeed for an instance of a subtype of the type checked', 
        () => expect(() {throw new IllegalArgumentException('e');}).to(throwMatcher));
      it('should rethrow anything that does not succeed in the checker', () => expect(() {throwMatcher.matches((){throw 3;});}).to(throwA()));
      it('should fail if nothing is thrown', () => expect(() {}).to(not(throwMatcher)));
      it('should have a generic description', () => expect(throwMatcher.describeExpectation(null)).to(equal('actual to throw something')));
    });
    describe('with an exception checker and an exception type', () {
      ThrowMatcher throwMatcher = throwA((thrown) => thrown is Exception, 'exception');
      it('should succeed for an instance of the exact type checked', () => expect(() {throw new Exception('e');}).to(throwMatcher));
      it('should succeed for an instance of a subtype of the type checked', 
        () => expect(() {throw new IllegalArgumentException('e');}).to(throwMatcher));
      it('should rethrow anything that does not succeed in the checker', () => expect(() {throwMatcher.matches((){throw 3;});}).to(throwA()));
      it('should fail if nothing is thrown', () => expect(() {}).to(not(throwMatcher)));
      it('should have a description based on the given exception type', 
        () => expect(throwMatcher.describeExpectation(null)).to(equal('actual to throw a exception')));
    });
  });

}
