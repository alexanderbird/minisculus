class Terminal < Production
  def initialize token_list, grammar, token_class
    @token_class = token_class
    super token_list, grammar
  end

  def execute
    if @tokens.first.kind_of? @token_class
      @tokens.shift
    else
      raise ParseError, self
    end
  end

  def to_s
    super @token_class.to_s
  end

  attr_reader :token_class
end
