#import('dart:html');
#import('../src/dahlia.dart');

#source('basic_tests.dart');

void main() {
  basicTests();
  new ConsoleRunner().run();  
}
