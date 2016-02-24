class ParseError < StandardError 
  def initialize production
    token = production.tokens.first
    if token && token.kind_of?(Token)
      super "Line #{token.line || '?'}, column #{token.column || '?'}: Expected #{production}, got #{token}"
    else
      super "#{production} failed... maybe because there were no tokens?"
    end
  end
end
