class While < Statement
  child :loop_condition, Expression
  child :statement, Statement
end
