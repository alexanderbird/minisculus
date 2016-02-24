class Grammar
  def initialize grammar_rules = {}
    raise ArgumentError.new "Expected a Hash, got #{grammar_rules.inspect}" unless grammar_rules.kind_of? Hash
    @rules = grammar_rules
  end

  def production identifier, token_list
    if @rules.has_key? identifier
      production = Production.create_from token_list, self, @rules[identifier]
      production.name = identifier.to_s
      return production
    else 
      raise NoSuchProductionError.new(identifier, self)
    end
  end

  def starting_production token_list
    starting_production_identifier = @rules.keys.first
    self.production starting_production_identifier, token_list
  end

  attr_reader :rules
end
