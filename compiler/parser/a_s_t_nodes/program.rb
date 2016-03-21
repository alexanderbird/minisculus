class Program < Node
  child :declaration, [Declaration]
  child :statement, [Statement]
end
