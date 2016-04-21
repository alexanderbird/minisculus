class VisitorToPopulateSymbolTable
  def initialize symbol_table
    raise ArgumentError, "Expected a kind of SymbolTable, got #{symbol_table.class}" unless symbol_table.kind_of?(SymbolTable)
    @symbol_table = symbol_table
  end

  def visit token
    symbol = SemanticAnalysisSymbol.new
    do_nothing = false
    case token.class.to_s.to_sym
    when :FunctionDeclaration
      symbol.data_type = token.return_type.class.to_s.to_sym # E.g. :Boolean
    when :Variable
      symbol.data_type = token.type.class.to_s.to_sym # E.g. :Boolean
    when :Parameter
      symbol.data_type = token.type.class.to_s.to_sym # E.g. :Boolean
    else
      do_nothing = true
    end
    unless do_nothing
      symbol.symbol_type = token.class.to_s.to_sym # E.g. :Variable or :FunctionDeclaration
      @symbol_table[token.name] = symbol 
    end
  end
end
