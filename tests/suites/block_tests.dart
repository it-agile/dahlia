blockTests() {
  describe('block', () {
    int counter = 0;
    
    beforeAll(() => counter = 10);
    beforeEach(() => counter++);
    
    it('should call beforeAll once before any contained block', () => expect(counter).to(equal(11)));
    it('should call beforeEach once before each contained block', () => expect(counter).to(equal(12)));
  });
}