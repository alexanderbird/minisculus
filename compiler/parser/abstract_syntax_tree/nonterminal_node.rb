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

    def to_hash
      child_hash = {}
      @children.each do |child|
        child_hash.merge! child.to_hash
      end
      { self.to_s => child_hash }
    end

    attr_reader :children
  end
end
