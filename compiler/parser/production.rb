class Production
  def initialize token_list, grammar
    raise ArgumentError.new("Expected TokenList, got #{token_list.class}") unless token_list.kind_of?(TokenList)
    raise ArgumentError.new("Expected Grammar, got #{grammar.class}") unless grammar.kind_of?(Grammar)
    @tokens = token_list
    @grammar = grammar
  end

  def execute
    raise NotImplementedError
  end

  def fork identifier
    if identifier.is_a? Symbol
      return @grammar.production identifier, @tokens
    elsif identifier.is_a?(Class) && identifier.ancestors.include?(Token)
      return Terminal.new @tokens, @grammar, identifier
    elsif identifier == nil
      return NullProduction.new @tokens, @grammar
    elsif identifier.kind_of?(Hash) && identifier[:productions].respond_to?(:each)
      return ProductionSet.new @tokens, @grammar, identifier[:productions] 
    elsif identifier.respond_to? :each 
      return NonterminalProduction.new @tokens, @grammar, identifier
    else
      raise ArgumentError.new("Couldn't fork #{identifier.inspect}")
    end
  end

  def self.create_from tokens, grammar, identifier
    self.new(tokens, grammar).fork identifier
  end

  def to_s detail = nil
    if @name
      "Production(#{name})"
    else
      "#{self.class}#{ detail ? '(' + detail + ')' : ''}"
    end
  end

  def identifier
    @name || self.class.to_s
  end

  attr_accessor :grammar
  attr_accessor :name
  attr_reader :tokens
end
