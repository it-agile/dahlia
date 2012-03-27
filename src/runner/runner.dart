class Runner {
  int _numberOfSpecs;
  int _numberOfFailures;
  int _numberOfCrashes;
  List<Reporter> _reporters;
  BlockSwitcher _blockSwitcher;
  
  Runner([List<Reporter> reporters]) {
    _reporters = new List<Reporter>();
    if (reporters != null) {
      _reporters.addAll(reporters);
    }
    _blockSwitcher = new DefaultBlockSwitcher();
  }
  
  void addReporter(Reporter reporter) => _reporters.add(reporter);
  set blockSwitcher(BlockSwitcher blockSwitcher) => _blockSwitcher = blockSwitcher;
  
  void run() {
    _numberOfSpecs = 0;
    _numberOfFailures = 0;
    _numberOfCrashes = 0;
    _reporters.forEach((Reporter reporter) => reporter.testRunStarted());
    processBlock(_blockSwitcher.rootBlock);
    _reporters.forEach((Reporter reporter) => reporter.testRunFinished(numberOfSpecs, numberOfFailures, numberOfCrashes));
  }
  
  void processBlock(Block block) {
    _blockSwitcher.switchTo(block);
    _reporters.forEach((Reporter reporter) => reporter.blockProcessingStarted(block));
    executeBlock(block);
    try {
      block.startProcessingBlock();
      processContainedBlocks(block);
      block.finishProcessingBlock();
    } catch(var thrown, var stack) {
      addToNumberOfCrashes(block);
      _reporters.forEach((Reporter reporter) => reporter.crashOccurred(block, thrown, stack));
    }
    _reporters.forEach((Reporter reporter) => reporter.blockProcessingFinshed(block));
  }
  
  void executeBlock(Block block) {
    addToNumberOfSpecs(block);
    _reporters.forEach((Reporter reporter) => reporter.blockExecutionStarted(block));
    try {
      block.blockFunction();
    } catch(var thrown, var stack) {
      addToNumberOfFailures(block);
      _reporters.forEach((Reporter reporter) => reporter.failureOccurred(block, thrown, stack));
    }
    _reporters.forEach((Reporter reporter) => reporter.blockExecutionFinshed(block));
  }
  
  void processContainedBlocks(Block block) {
    if(block.containedBlocks != null) {
      block.containedBlocks.forEach((Block containedBlock) {
        block.startProcessingContainedBlock();
        processBlock(containedBlock);
        block.finishProcessingContainedBlock();
      });
    }
  }
  
  void addToNumberOfSpecs(Block block) {
    if (block.countableAsSpec) {
      _numberOfSpecs++;
    }
  }
  
  void addToNumberOfFailures(Block block) {
    if (block.countableAsSpec) {
      _numberOfFailures++;
    }
  }
  
  void addToNumberOfCrashes(Block block) {
    _numberOfCrashes++;
  }
  
  int get numberOfSpecs() => _numberOfSpecs;
  int get numberOfFailures() => _numberOfFailures;
  int get numberOfCrashes() => _numberOfCrashes;  
}

interface Reporter {
  void blockProcessingStarted(Block block);
  void blockProcessingFinshed(Block block);
  void blockExecutionStarted(Block block);
  void blockExecutionFinshed(Block block);
  void failureOccurred(Block block, var thrown, var stack);
  void crashOccurred(Block block, var thrown, var stack);
  void testRunStarted();
  void testRunFinished(int numberOfSpecs, int numberOfFailures, int numberOfCrashes);
}

interface BlockSwitcher {
  void switchTo(Block block);
  Block get rootBlock();
}
