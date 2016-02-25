class MinisculusGrammar < Grammar
  def initialize 
  super({
      prog: :stmt, 
      stmt: { productions: [
        [IfToken, :expr, :thenpart],
        [WhileToken, :expr, DoToken, :stmt],
        [InputToken, IdentifierToken],
        [IdentifierToken, AssignToken, :expr],
        [WriteToken, :expr],
        [BeginToken, :stmtlist, EndToken]
      ]},
      thenpart: [ThenToken, :stmt, :elsepart],
      elsepart: [ElseToken, :stmt],
      stmtlist: { productions: [
        [:stmt, SemicolonToken, :stmtlist],
        nil
      ]},
      expr: [:term, :expr_],
      expr_: { productions: [
        [AddToken, :term, :expr_],
        [SubToken, :term, :expr_],
        nil
      ]},
      term: [:factor, :term_],
      term_: { productions: [
        [MulToken, :factor, :term_],
        [DivToken, :factor, :term_],
        nil
      ]},
      factor: { productions: [
        [LeftParenToken, :expr, RightParenToken],
        IdentifierToken,
        NumberToken,
        [SubToken, NumberToken],
      ]}
    })
  end
end
