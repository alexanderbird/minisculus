class Condition < Statement
  child :condition, Expression
  child :if_statement, Statement
  child :else_statement, Statement
end
