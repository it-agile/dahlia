#library('runs all tests on the console');

#import('../src/dahlia.dart');
#import('test_suites.dart');

main() {
  testSuites();
  new Runner([new ConsoleReporter()]).run();  
}