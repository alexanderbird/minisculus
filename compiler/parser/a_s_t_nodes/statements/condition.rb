class Condition < Statement
  child :expression, Expression
  child :if_statement, Statement
  child :else_statement, Statement
end
