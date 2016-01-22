class Lexer
  def lex input
    tokens = []
    while input.length > 0
      any_match = false
      self.token_rules.each do |rule|
        if rule.attempt_tokenize input
          tokens << rule.token
          input = rule.remainder
          any_match = true
        end
      end
      raise LexError.new unless any_match
    end
    return tokens
  end

  private
  attr_accessor :token_rules
end
