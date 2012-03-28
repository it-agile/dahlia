#library('dahlia test suites');
#import('../src/dahlia.dart');

#source('suites/general_matcher_tests.dart');
#source('suites/string_matchers_tests.dart');
#source('suites/block_tests.dart');
#source('suites/expectation_tests.dart');
#source('suites/runner_tests.dart');

testSuites() {
  generalMatcherTests();
  stringMatchersTests();
  blockTests();
  expectationTests();
  runnerTests();
}