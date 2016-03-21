class Variable < Declaration
  value :name, String
  value :array_dimensions, Fixnum
  child :type, Type
end
