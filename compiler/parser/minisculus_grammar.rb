class MinisculusGrammar < Grammar
  def initialize 
  super({
      prog: :stmt, 
      stmt: { productions: [
        [IfToken, :expr, ThenToken, :stmt, ElseToken, :stmt],
        [WhileToken, :expr, DoToken, :stmt],
        [InputToken, IdentifierToken],
        [IdentifierToken, AssignToken, :expr],
        [WriteToken, :expr],
        [BeginToken, :stmtlist, EndToken]
      ]},
      stmtlist: { productions: [
        [:stmt, SemicolonToken, :stmtlist],
        nil
      ]},
      expr: [:term, :expr_],
      expr_: { productions: [
        [:addop, :term, :expr_],
        nil
      ]},
      addop: { productions: [
        AddToken,
        SubToken
      ]},
      term: [:factor, :term_],
      term_: { productions: [
        [:mulop, :factor, :term_],
        nil
      ]},
      mulop: { productions: [
        MulToken,
        DivToken
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
