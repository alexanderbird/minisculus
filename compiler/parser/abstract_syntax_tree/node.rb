module AbstractSyntaxTree
  class Node
    def initialize identifier
      @identifier = identifier
    end

    def to_s 
      @identifier.to_s
    end

    attr_reader :identifier
  end
end
