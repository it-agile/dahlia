describe(String description, Function function) => _addBlock(new DescribeBlock(description, function));
it(String description, Function function) => _addBlock(new ItBlock(description, function));
beforeEach(Function function) => _currentBlock.beforeEach = function;
beforeAll(Function function) => _currentBlock.beforeAll = function;
afterEach(Function function) => _currentBlock.afterEach = function;
afterAll(Function function) => _currentBlock.afterAll = function;

class Block {
  final String blockDescription;
  final Function blockFunction;
  Block parent;
    
  Block(this.blockDescription, this.blockFunction);

  startProcessingBlock(){}
  finishProcessingBlock(){}
  List<Block> containedBlocks() => [];
  startProcessingContainedBlock(){}
  finishProcessingContainedBlock(){}
  abstract addBlock(Block block);

  abstract set beforeEach(Function function);
  abstract set beforeAll(Function function);
  abstract set afterEach(Function function);
  abstract set afterAll(Function function);
  
  bool get countableAsSpec() => false;
}

class DescribeBlock extends Block {
  List<Block> blocks;
  Function _beforeEach;
  Function _beforeAll;
  Function _afterEach;
  Function _afterAll;

  
  DescribeBlock(String description, Function function) : super(description, function);
  
  set beforeEach(Function function) => _beforeEach = function;
  set beforeAll(Function function) => _beforeAll = function;
  set afterEach(Function function) => _afterEach = function;
  set afterAll(Function function) => _afterAll = function;
  
  startProcessingBlock() {
    if (_beforeAll !== null) _beforeAll(); 
  }
  finishProcessingBlock() {
    if (_afterAll !== null) _afterAll();
  }
  List<Block> containedBlocks() {
    return blocks;
  }
  startProcessingContainedBlock() {
    if (_beforeEach !== null) _beforeEach();
  }
  finishProcessingContainedBlock() {
    if (_afterEach !== null) _afterEach();
  }
  
  addBlock(Block block) {
    if (blocks === null) {
      blocks = [];
    }
    blocks.add(block);
    block.parent = this;
  }

}

class ItBlock extends Block {
  ItBlock(String description, Function function) : super(description, function);
  
  addBlock(Block block) {
    throw new Exception('Cannot add a block to an it-block');
  }

  set beforeEach(Function function) {
    throw new Exception('Cannot set a beforEaach function for an it-block');
  }
  
  set beforeAll(Function function) {
    throw new Exception('Cannot set a beforeAll function for an it-block');
  }
  
  set afterEach(Function function) {
    throw new Exception('Cannot set a afterEach function for an it-block');
  }
  set afterAll(Function function) {
    throw new Exception('Cannot set a afterAll function for an it-block');
  }
  
  bool get countableAsSpec() => true;
}

Block _rootBlock;
Block _currentBlock;

_addBlock(Block block) {
  if (_rootBlock === null) {
    _rootBlock = new DescribeBlock('All tests', (){});
    _currentBlock = _rootBlock;
  }
  _currentBlock.addBlock(block);
}

_switchTo(Block block) => _currentBlock = block;
