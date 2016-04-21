class SemanticAnalysisVisitor < BaseVisitor
  def pre_visit token
    case token.class.to_s.to_sym
    when :Block
      @symbol_table.begin_scope
    end
  end

  def visit token
    case token.class.to_s.to_sym
    when :Identifier
      symbol = @symbol_table[token.name]
      raise UndefinedIdentifierException, "#{token.name} has not been defined" unless symbol
    when :Assignment
      symbol = @symbol_table[token.name]
      raise UndefinedIdentifierException, "#{token.name} has not been defined" unless symbol
      raise MinisculusTypeError, "Cannot assign #{token.expression.data_type} type to #{token.name}:#{symbol.data_type}" unless symbol.data_type == token.expression.data_type 
    when :Block
      @symbol_table.end_scope
    end
  end
end
