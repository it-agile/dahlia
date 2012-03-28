# dahlia - BDD unit testing for Dart
dahlia is a behavior-driven-development unit testing framework for the programming language Dart. It is highly inspired by Jasmine and RSpec.

## Example
```dart
#import('../src/dahlia.dart');

main() {
  describe('two equal strings', () {
    it('should be equal', () => expect('test').to(equal('test')));
  });
  new Runner([new ConsoleReporter()]).run();  
}
```
This will produce the following output

```
 All tests
  two equal strings
   should be equal

specs: 1, failures: 0, crashes: 0
```

For futher information take a look at the tests in the tests-directory. They show what is currently possible with dahlia and are continuously expanded as new features are added.

## Maintainers
* [Robert Beeger](mailto:robert.beeger@it-agile.de), it-agile GmbH

Copyright © 2012 by it-agile GmbH. This software is licensed under the MIT license. See the included LICENSE.txt for further information.