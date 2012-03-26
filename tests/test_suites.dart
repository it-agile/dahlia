#library('dahlia test suites');
#import('../src/dahlia.dart');

#source('suites/general_matcher_tests.dart');
#source('suites/block_tests.dart');
#source('suites/expectation_tests.dart');


testSuites() {
  generalMatcherTests();
  blockTests();
  expectationTests();
}