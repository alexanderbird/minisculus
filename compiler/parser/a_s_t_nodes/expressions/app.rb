class App < Expression
  # an App is a built in function or similar. I don't know why it's called App
  child :operation, Operation
  child :expressions, [Expression]
end
