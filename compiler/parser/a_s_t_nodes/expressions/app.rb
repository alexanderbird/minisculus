class App < Expression
  # what the heck is App?? I really don't know.. 
  child :operation, Operation
  child :expressions, [Expression]
end
