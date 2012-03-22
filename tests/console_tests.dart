#library('runs all tests on the console');

#import('../src/dahlia.dart');

#source('basic_tests.dart');

main() {
  basicTests();
  new ConsoleRunner().run();  
}