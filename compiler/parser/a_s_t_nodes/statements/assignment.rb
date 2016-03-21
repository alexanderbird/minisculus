class Assignment < Statement
  value :name, String
  child :expressions, [Expression]
  child :expression, Expression
end
