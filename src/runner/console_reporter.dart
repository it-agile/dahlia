class ConsoleReporter implements Reporter {
  int _currentBlockLevel;
  
  void blockProcessingStarted(Block block) {
    _currentBlockLevel++;
  }

  void blockProcessingFinshed(Block block) {
    _currentBlockLevel--;
  }
  
  void blockExecutionStarted(Block block) {
    print('${blockLevelIndent(_currentBlockLevel)}${block.blockDescription}');
  }
  
  void blockExecutionFinshed(Block block) {
    
  }
  
  void failureOccurred(Block block, var thrown, var stack) {
    printStacktrace(thrown, stack);
  }
  
  void crashOccurred(Block block, var thrown, var stack) {
    print('${blockLevelIndent(_currentBlockLevel)}  Unhandled error while processing block. Ignoring rest of block.');
    printStacktrace(thrown, stack);
  }
  
  void testRunStarted() {
    _currentBlockLevel = 0;
  }
  
  void testRunFinished(int numberOfSpecs, int numberOfFailures, int numberOfCrashes) {
    print('');
    print('specs: $numberOfSpecs, failures: $numberOfFailures, crashes: $numberOfCrashes');
  }
  
  String blockLevelIndent(int blockLevel) {
    StringBuffer buffer = new StringBuffer();
    for(int i = 0; i < blockLevel; i++) {
      buffer.add(' ');
    }
    
    return buffer.toString();
  }
  
  void printStacktrace(var exception, var stack) {
    print('${blockLevelIndent(_currentBlockLevel)}  $exception');
    print('');
    stack.toString().split(new RegExp(@"^", true)).forEach((stackLine) {
      String trimmedStackLine = stackLine.trim();
      if(trimmedStackLine.length > 0) {
        print('${blockLevelIndent(_currentBlockLevel)}    ${stackLine.trim()}');
      }
    });
    print('');
  }
}
