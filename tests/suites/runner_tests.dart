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
    DescribeBlock describeBlock;
    

    beforeAll(() {
      reporter = new RunnerTestReporter();
      blockSwitcher = new RunnerTestBlockSwitcher();
      runner = new Runner([reporter]);
      runner.blockSwitcher = blockSwitcher; 
    });
    
    beforeEach(() { 
      reporter.createNewRunLog();
      describeBlock = new DescribeBlock('r', () {});
      blockSwitcher.rootBlock = describeBlock;
    });
    
    ItBlock addEmptyItBlockToDescribeBlock(String name) => describeBlock.addBlock(new ItBlock(name, () {}));
    ItBlock addItBlockThrowingAnEToDescribeBlock(String name) => describeBlock.addBlock(new ItBlock(name, () {throw 'e';}));

    describe('with an empty describe block', () {
      beforeAll(() {
        runner.run();
      });
      it('should run the expected sequence', () => expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bpf(r)|tf(0,0,0)')));
    });
    describe('with a describe block containing an empty it block', () {
      beforeAll(() {
        addEmptyItBlockToDescribeBlock('i');
        runner.run();
      });
      
      it('should run the expected sequence', () => 
        expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|bef(i)|bpf(i)|bpf(r)|tf(1,0,0)')));
    });
    describe('with a describe block containing an it block throwing something', () {
      beforeAll(() {
        addItBlockThrowingAnEToDescribeBlock('i');
        runner.run();
      });
      
      it('should report one failure and count that failure', () => 
        expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|fo(i,e)|bef(i)|bpf(i)|bpf(r)|tf(1,1,0)')));
    });
    describe('with a describe block containing an it block throwing something and an empty it block', () {
      beforeAll(() {
        addItBlockThrowingAnEToDescribeBlock('i');
        addEmptyItBlockToDescribeBlock('s');
        runner.run();
      });
      
      it('should report two specs and one failure and count them', () => 
        expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|fo(i,e)|bef(i)|bpf(i)|bps(s)|bes(s)|bef(s)|bpf(s)|bpf(r)|tf(2,1,0)')));
    });
    describe('with a describe block containing two empty it blocks', () {
      beforeAll(() {
        addEmptyItBlockToDescribeBlock('i');
        addEmptyItBlockToDescribeBlock('s');
      });
      
      afterEach(() {
        reporter.createNewRunLog();
        describeBlock.beforeAll = null;
        describeBlock.afterAll = null;
        describeBlock.beforeEach = null;
        describeBlock.afterEach = null;
      });
      
      describe('and a beforeEach function throwing something', () {
        beforeAll(() {
          describeBlock.beforeEach = () {throw 'e';};
          runner.run();
        });
        
        it('should report one crash and count that crash', () => 
          expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|co(r,e)|bpf(r)|tf(0,0,1)')));
      });
      describe('and an afterEach function throwing something', () {
        beforeAll(() {
          describeBlock.afterEach = () {throw 'e';};
          runner.run();
        });
        
        it('should report one crash and count that crash', () => 
          expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|bef(i)|bpf(i)|co(r,e)|bpf(r)|tf(1,0,1)')));
      });
      describe('and a beforeAll function throwing something', () {
        beforeAll(() {
          describeBlock.beforeAll = () {throw 'e';};
          runner.run();
        });
        
        it('should report one crash and count that crash', () => 
          expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|co(r,e)|bpf(r)|tf(0,0,1)')));
      });
      describe('and an afterAll function throwing something', () {
        beforeAll(() {
          describeBlock.afterAll = () {throw 'e';};
          runner.run();
        });
        
        it('should report one crash and count that crash', () => 
          expect(reporter.runLog.toString()).to(equal('|ts|bps(r)|bes(r)|bef(r)|bps(i)|bes(i)|bef(i)|bpf(i)|bps(s)|bes(s)|bef(s)|bpf(s)|co(r,e)|bpf(r)|tf(2,0,1)')));
      });
    });
  });
}