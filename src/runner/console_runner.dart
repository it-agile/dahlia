class ConsoleRunner {
  
  run() {
    processBlock(_rootBlock, 0);
  }
  
  processBlock(Block block, int blockLevel) {
    _switchTo(block);
    print('${blockLevelIndent(blockLevel)}${block.blockDescription}');
    try {
      block.blockFunction();
    } catch(Exception ex, var stack) {
      print('${blockLevelIndent(blockLevel)}  $ex');
    }
    block.startProcessingBlock();
    block.containedBlocks().forEach((Block containedBlock) {
      block.startProcessingContainedBlock();
      processBlock(containedBlock, blockLevel + 1);
      block.finishProcessingContainedBlock();
    });
    block.finishProcessingBlock();
  }
  
  String blockLevelIndent(int blockLevel) {
    StringBuffer buffer = new StringBuffer();
    for(int i = 0; i < blockLevel; i++) {
      buffer.add(' ');
    }
    
    return buffer.toString();
  }
  
}
