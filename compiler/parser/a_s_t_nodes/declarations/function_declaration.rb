class FunctionDeclaration < Declaration
  value :name, String
  child :parameters, [Parameter]
  child :return_type, Type
  child :declarations, [Declaration]
  child :function_body, [Statement]
end
