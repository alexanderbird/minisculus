class Terminal < Production
  def initialize token_list, grammar, token_class
    @token_class = token_class
    super token_list, grammar
  end

  def execute
    if @tokens.first.kind_of? @token_class
      @token = @tokens.shift
    else
      raise ParseError, self
    end
    return @token.is_significant? ? AbstractSyntaxTree::TerminalNode.new(@token) : nil
  end

  def to_s
    super @token_class.to_s
  end

  def identifier
    @token || @token_class
  end

  attr_reader :token_class
end
