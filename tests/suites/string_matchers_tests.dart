stringMatchersTests() {
  describe('startWith matcher', () {
    it('should succeed if the actual string starts with the expected string', () => expect('hallo').to(startWith('ha')));
    it('should fail if the actual string does not start with the expected string', () => expect('hallo').to(not(startWith('test'))));
  });
  describe('containSubstring matcher', () {
    it('should succeed if the actual string starts with the expected string', () => expect('hallo').to(containSubstring('ha')));
    it('should succeed if the actual string contains the expected string', () => expect('hallo').to(containSubstring('al')));
    it('should fail if the actual string does not contain the expected string', () => expect('hallo').to(not(containSubstring('test'))));
  });
}
