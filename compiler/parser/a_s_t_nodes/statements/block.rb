class Block < Statement
  child :declarations, [Declaration]
  child :statements, [Statement]
end
