class Lexer
  def initialize
    self.token_rules = [
      TokenRule.new(IfToken, /if\b/),
      TokenRule.new(ThenToken, /then\b/),
      TokenRule.new(WhileToken, /while\b/),
      TokenRule.new(DoToken, /do\b/),
      TokenRule.new(InputToken, /input\b/),
      TokenRule.new(ElseToken, /else\b/),
      TokenRule.new(BeginToken, /begin\b/),
      TokenRule.new(EndToken, /end\b/),
      TokenRule.new(WriteToken, /write\b/),
      TokenRule.new(AddToken, /[+]/),
      TokenRule.new(AssignToken, /:=/),
      TokenRule.new(SubToken, /-/),
      TokenRule.new(MulToken, /[*]/),
      TokenRule.new(DivToken, /\//),
      TokenRule.new(LeftParenToken, /\(/),
      TokenRule.new(RightParenToken, /\)/),
      TokenRule.new(SemicolonToken, /;/),
      TokenRule.new(IdentifierToken, /[a-zA-Z][0-9a-zA-Z]*/),
      TokenRule.new(NumberToken, /[0-9]+/),
      TokenRule.new(NonToken, / +/),
      TokenRule.new(NewlineNonToken, /\n/)
    ]
  end

  def lex input
    tokens = []
    current_column = 1
    current_line = 1
    while input.length > 0
      any_match = false
      self.token_rules.each do |rule|
        if rule.attempt_tokenize input
          tokens << rule.token unless rule.token.kind_of? NonToken
          input = rule.remainder
          if rule.token.kind_of? NewlineNonToken
            current_column = 1
            current_line += 1
          else
            current_column += rule.matched_portion.length
          end
          any_match = true
          break
        end
      end
      raise LexError.new(current_line, current_column, input.split(/\n/).first[0..9]) unless any_match
    end
    return tokens
  end

  attr_accessor :token_rules
end
