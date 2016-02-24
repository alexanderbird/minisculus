class NoSuchProductionError < StandardError
  def initialize production_name, grammar
    @grammar = grammar
    super "Looked for :#{production_name.to_s} in #{grammar.rules.keys}"
  end
end
