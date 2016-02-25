class NonterminalProduction < Production
  def initialize token_list, grammar, symbols
    super token_list, grammar
    @symbols = symbols
  end

  def execute
    node = AbstractSyntaxTree::NonterminalNode.new(@symbols)
    @symbols.each do |symbol|
      node << self.fork(symbol).execute
    end
    node
  end

  def to_s
    super "[#{@symbols.join(', ')}]"
  end

  def identifier
    @symbols.compact.join(", ")
  end
  attr_reader :symbols
end
