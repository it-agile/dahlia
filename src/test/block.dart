describe(String description, Function function) => _addBlock(new DescribeBlock(description, function));
it(String description, Function function) => _addBlock(new ItBlock(description, function));
beforeEach(Function function) => _currentBlock.beforeEach(function);
beforeAll(Function function) => _currentBlock.beforeAll(function);
afterEach(Function function) => _currentBlock.afterEach(function);
afterAll(Function function) => _currentBlock.afterAll(function);

class Block {
  final String blockDescription;
  final Function blockFunction;
  Block parent;
  Function beforeEachFunction;
  Function beforeAllFunction;
  Function afterEachFunction;
  Function afterAllFunction;
  
  
  Block(this.blockDescription, this.blockFunction);

  startProcessingBlock(){}
  finishProcessingBlock(){}
  List<Block> containedBlocks() => [];
  startProcessingContainedBlock(){}
  finishProcessingContainedBlock(){}
  abstract addBlock(Block block);

  abstract beforeEach(Function function);
  abstract beforeAll(Function function);
  abstract afterEach(Function function);
  abstract afterAll(Function function);
}

class DescribeBlock extends Block {
  List<Block> blocks;
  
  DescribeBlock(String description, Function function) : super(description, function);
  
  beforeEach(Function function) => beforeEachFunction = function;
  beforeAll(Function function) => beforeAllFunction = function;
  afterEach(Function function) => afterEachFunction = function;
  afterAll(Function function) => afterAllFunction = function;
  
  startProcessingBlock() {
    if (beforeAllFunction !== null) beforeAllFunction(); 
  }
  finishProcessingBlock() {
    if (afterAllFunction !== null) afterAllFunction();
  }
  List<Block> containedBlocks() {
    return blocks;
  }
  startProcessingContainedBlock() {
    if (beforeEachFunction !== null) beforeEachFunction();
  }
  finishProcessingContainedBlock() {
    if (afterEachFunction !== null) afterEachFunction();
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
    throw new Exception('Cannot add a block to a leaf block');
  }

  beforeEach(Function function) {
    throw new Exception('Cannot set a beforEaach function for an it-block');
  }
  
  beforeAll(Function function) {
    throw new Exception('Cannot set a beforeAll function for an it-block');
  }
  
  afterEach(Function function) {
    throw new Exception('Cannot set a afterEach function for an it-block');
  }
  afterAll(Function function) {
    throw new Exception('Cannot set a afterAll function for an it-block');
  }
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
