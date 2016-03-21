class Identifier < Expression
  value :name, String
  child :expressions, [Expression]
end
