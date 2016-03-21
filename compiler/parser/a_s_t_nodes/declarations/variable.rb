class Variable < Declaration
  value :name, String
  child :array_dimensions, [Expression]
  child :type, Type
end
