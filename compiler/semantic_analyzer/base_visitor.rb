class BaseVisitor
  def initialize symbol_table
    raise ArgumentError, "Expected a kind of SymbolTable, got #{symbol_table.class}" unless symbol_table.kind_of?(SymbolTable)
    @symbol_table = symbol_table
  end

  def visit token
    raise NotImplementedError
  end

  def pre_visit token
  end
end
