blockTests() {
  describe('block', () {
    int afterAllCounter = 0;
    int beforeAllCounter = 0;

    describe('contained block', () {
      int beforeEachCounter = 0;
      int afterEachCounter = 0;
      
      beforeAll(() => beforeAllCounter++);
      beforeEach(() => beforeEachCounter++);
      afterEach(() => afterEachCounter++);
      afterAll(() => afterAllCounter++);
      
      it('should call beforeAll once before any contained block', () => expect(beforeAllCounter).to(equal(1)));
      it('should not call afterAll before all contained blocks are processed', () => expect(afterAllCounter).to(equal(0)));
      it('should call beforeEach once before each contained block', () => expect(beforeEachCounter).to(equal(3)));
      it('should call afterEach once after each contained block', () => expect(afterEachCounter).to(equal(3)));
    });
    it('should call beforeAll once before any contained block', () => expect(beforeAllCounter).to(equal(1)));
    it('should call afterAll once after all contained blocks', () => expect(afterAllCounter).to(equal(1)));
  });
}