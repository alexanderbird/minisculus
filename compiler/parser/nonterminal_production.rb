class NonterminalProduction < Production
  def initialize token_list, grammar, symbols
    super token_list, grammar
    @symbols = symbols
  end

  def execute
    @symbols.each do |symbol|
      self.fork(symbol).execute
    end
  end

  def to_s
    super "[#{@symbols.join(', ')}]"
  end

  attr_reader :symbols
end
