module AbstractSyntaxTree
  class Node
    def initialize identifier
      @identifier = identifier
    end

    def to_s 
      @identifier.to_s
    end
  end
end
