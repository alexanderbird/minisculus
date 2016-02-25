module AbstractSyntaxTree
  class NonterminalNode < Node
    def initialize *args
      super
      @children = []
    end

    def << rhs
      if rhs.kind_of? AbstractSyntaxTree::Node
        @children << rhs
      elsif rhs == nil
        return
      else
        raise ArgumentError, "Expected AbstractSyntaxTree::Node, got #{rhs.inspect}"
      end
    end

    attr_reader :children
  end
end
