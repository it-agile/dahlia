class ConsoleRunner {
  
  void run() {
    processBlock(_rootBlock, 0);
  }
  
  void processBlock(Block block, int blockLevel) {
    _switchTo(block);
    executeBlock(block, blockLevel);
    block.startProcessingBlock();
    processContainedBlocks(block, blockLevel);
    block.finishProcessingBlock();
  }
  
  void executeBlock(Block block, int blockLevel) {
    print('${blockLevelIndent(blockLevel)}${block.blockDescription}');
    try {
      block.blockFunction();
    } catch(var ex, var stack) {
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
    print('$stackString');
  }
  
}
