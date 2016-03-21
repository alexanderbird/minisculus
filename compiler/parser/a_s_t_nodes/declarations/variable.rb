class Variable < Declaration
  value :name, String
  child :parameters, [Parameter]
  child :return_type, Type
  child :declarations, [Declaration]
  child :statements, [Statement]
end
