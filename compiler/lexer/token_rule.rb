class TokenRule
  def initialize token_class, pattern
    raise ArgumentError.new("Expected Token, got #{token_class.class}") unless (token_class.is_a?(Class) && token_class.ancestors.include?(Token))
    raise ArgumentError.new("Expected Regexp, got #{pattern.class}") unless (pattern.kind_of?(Regexp))
    @pattern = Regexp.new("^#{pattern.source}")
    @token_class = token_class
  end

  def attempt_tokenize input
    matched = @pattern.match(input)
    if matched
      @remainder = input.sub(@pattern, '')
      @token = @token_class.new(matched.to_s)
    end
    matched
  end

  attr_reader :remainder, :token
end
