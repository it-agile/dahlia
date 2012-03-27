class ConsoleRunner {
  int _numberOfSpecs;
  int _numberOfFailures;
  int _numberOfCrashes;
  
  void run() {
    _numberOfSpecs = 0;
    _numberOfFailures = 0;
    _numberOfCrashes = 0;
    processBlock(_rootBlock, 0);
    print('');
    print('specs: $numberOfSpecs, failures: $numberOfFailures, crashes: $numberOfCrashes');
  }
  
  void processBlock(Block block, int blockLevel) {
    _switchTo(block);
    executeBlock(block, blockLevel);
    try {
      block.startProcessingBlock();
      processContainedBlocks(block, blockLevel);
      block.finishProcessingBlock();
    } catch(var thrown, var stack) {
      addToNumberOfCrashes(block);
      print('${blockLevelIndent(blockLevel)}  Unhandled error while processing block. Ignoring rest of block.');
      printStacktrace(blockLevel, thrown, stack);
    }
  }
  
  void executeBlock(Block block, int blockLevel) {
    addToNumberOfSpecs(block);
    print('${blockLevelIndent(blockLevel)}${block.blockDescription}');
    try {
      block.blockFunction();
    } catch(var ex, var stack) {
      addToNumberOfFailures(block);
      printStacktrace(blockLevel, ex, stack);
    }
  }
  
  void processContainedBlocks(Block block, int blockLevel) {
    block.containedBlocks().forEach((Block containedBlock) {
      block.startProcessingContainedBlock();
      processBlock(containedBlock, blockLevel + 1);
      block.finishProcessingContainedBlock();
    });
  }
  
  String blockLevelIndent(int blockLevel) {
    StringBuffer buffer = new StringBuffer();
    for(int i = 0; i < blockLevel; i++) {
      buffer.add(' ');
    }
    
    return buffer.toString();
  }
  
  void printStacktrace(int blockLevel, var exception, var stack) {
    print('${blockLevelIndent(blockLevel)}  $exception');
    String stackString = stack.toString().replaceAll(new RegExp(@"^ ", true), '${blockLevelIndent(blockLevel)}    ');
    stackString = stackString.toString().replaceAll(new RegExp(@"^E", true), '${blockLevelIndent(blockLevel)}   E');
    print('$stackString');
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
