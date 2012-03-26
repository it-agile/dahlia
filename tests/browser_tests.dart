#import('dart:html');
#import('../src/dahlia.dart');

#import('test_suites.dart');

main() {
  testSuites();
  new ConsoleRunner().run();  
}
