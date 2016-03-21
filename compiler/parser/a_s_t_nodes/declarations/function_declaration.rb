class FunctionDeclaration < Declaration
  value :name, String
  child :expressions, [Expression]
  child :type, Type
end
