class Read < Statement
  value :name, String
  child :expressions, [Expression]
end
