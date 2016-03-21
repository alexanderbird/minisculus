class Parameter < Node
  value :name, String
  value :count, Fixnum
  child :type, Type
end
