class While < Statement
  child :expression, Expression
  child :statement, Statement
end
