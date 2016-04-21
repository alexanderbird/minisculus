class SymbolTable
  def initialize
    @symbol_table = { 0 => {} }
    @scope_level = 0
  end

  def [] key
    # starting with the current scope, work backwards ending with zero
    @scope_level.step(0, -1) do |i|
      symbol = @symbol_table[i][key]
      return symbol if symbol
    end
    return nil
  end

  def []= key, value
    @symbol_table[@scope_level][key] = value
  end

  def begin_scope
    @scope_level += 1
    # in the case that we previously had something at this scope level, override it
    # otherwise, we're initializing it to an empty hash
    @symbol_table[@scope_level] = {}
  end

  def end_scope
    raise InvalidOperationException, "Cannot end the global scope" if @scope_level == 0
    @scope_level -= 1
  end

  protected
  def to_hash
    # available for debugging
    # SymbolTable.new.send :to_hash to bypass the protected
    @symbol_table.merge({ scope_level: @scope_level })
  end
end
