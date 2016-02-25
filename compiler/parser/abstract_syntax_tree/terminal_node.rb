module AbstractSyntaxTree
  class TerminalNode < Node
    def to_hash
      { @identifier.to_s => true }
    end
  end
end
