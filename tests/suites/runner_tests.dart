class RunnerTestReporter implements Reporter {
  StringBuffer runLog;
  
  RunnerTestReporter(): runLog = new StringBuffer();
  
  void blockProcessingStarted(Block block) {
    runLog.add('|bps(${block.blockDescription})');
  }
  
  void blockProcessingFinshed(Block block) {
    runLog.add('|bpf(${block.blockDescription})');
  }
  
  void blockExecutionStarted(Block block) {
    runLog.add('|bes(${block.blockDescription})');
  }
  
  void blockExecutionFinshed(Block block) {
    runLog.add('|bef(${block.blockDescription})');
  }
  
  void failureOccurred(Block block, var thrown, var stack) {
    runLog.add('|fo(${block.blockDescription},$thrown)');
  }
  
  void crashOccurred(Block block, var thrown, var stack) {
    runLog.add('|co(${block.blockDescription},$thrown)');
  }
  
  void testRunStarted() {
    runLog.add('|ts');
  }
  
  void testRunFinished(int numberOfSpecs, int numberOfFailures, int numberOfCrashes) {
    runLog.add('|tf($numberOfSpecs,$numberOfFailures,$numberOfCrashes)');
  }
  
  void createNewRunLog() {
    runLog = new StringBuffer();
  }
}

class RunnerTestBlockSwitcher implements BlockSwitcher {
  Block _rootBlock;
  void switchTo(Block block) {}
  Block get rootBlock()            => _rootBlock;
        set rootBlock(Block block) => _rootBlock = block;
}

runnerTests() {
  describe('Runner', () {
    RunnerTestReporter reporter;
    Runner runner;
    RunnerTestBlockSwitcher blockSwitcher;
    
    beforeAll(() {
      reporter = new RunnerTestReporter();
      blockSwitcher = new RunnerTestBlockSwitcher();
      runner = new Runner([reporter]);
      runner.blockSwitcher = blockSwitcher; 
    });
    
    beforeEach(() => reporter.createNewRunLog());
    
    describe('with an empty describe block', () {
      beforeAll(() {
        blockSwitcher.rootBlock = new DescribeBlock('r', () {});
        runner.run();
      });
      it('should run the expected sequence', () => expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bpf(r)|tf(0,0,0)')));
    });
    describe('with a describe block containing an empty it block', () {
      beforeAll(() {
        DescribeBlock describeBlock = new DescribeBlock('r', () {});
        ItBlock itBlock = new ItBlock('i', () {});
        describeBlock.addBlock(itBlock);
        blockSwitcher.rootBlock = describeBlock;
        runner.run();
      });
      it('should run the expected sequence', () => 
        expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|bef(i)|bpf(i)|bpf(r)|tf(1,0,0)')));
    });
  });
}