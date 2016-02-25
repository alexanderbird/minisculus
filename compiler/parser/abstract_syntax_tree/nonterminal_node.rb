module AbstractSyntaxTree
  class NonterminalNode < Node
    def initialize *args
      super
      @children = []
    end

    def << rhs
      raise ArgumentError, "Expected AbstractSyntaxTree::Node, got #{rhs.inspect}" unless rhs.kind_of?(AbstractSyntaxTree::Node)
      @children << rhs
    end

    attr_reader :children
  end
end
