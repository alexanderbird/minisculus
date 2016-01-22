class LexError < Exception
  def initialize line, column, context
    super "Unknown token on line #{line}, column #{column} (`#{context}`...)"
  end
end
