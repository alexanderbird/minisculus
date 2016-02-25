module AbstractSyntaxTree
  class Node
    def initialize identifier
      @identifier = identifier
    end

    def to_s 
      @identifier.to_s
    end

    def visualize
      Visualizer.new(self).visualize
    end

    def to_hash
      raise NotImplementedError
    end

    attr_reader :identifier
  end
end
