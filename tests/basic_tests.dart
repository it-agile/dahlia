basicTests() {
  describe('equal matcher', () {
    it('should work for equal ints', () => expect(1).to(equal(1)));
    it('should work for equal Strings', () => expect('test').to(equal('test')));
    it('should work for equal objects', () => expect(new Duration(1, 1, 1, 1, 1)).to(equal(new Duration(1, 1, 1, 1, 1))));
  });

  describe('not matcher', () {
    it('should succeed if the expected value does not match with the actual matcher', () => expect(1).to(not(equal(2))));
  });

  describe('block', () {
    int counter = 0;
    
    beforeAll(() => counter = 10);
    beforeEach(() => counter++);
    
    it('should call beforeAll once before any contained block', () => expect(counter).to(equal(11)));
    it('should call beforeEach once before each contained block', () => expect(counter).to(equal(12)));
  });
}
