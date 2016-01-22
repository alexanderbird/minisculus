class TokenRule
  def initialize token_class, pattern
    raise ArgumentError.new("Expected Token, got #{token_class.class}") unless (token_class.is_a?(Class) && token_class.ancestors.include?(Token))
    raise ArgumentError.new("Expected Regexp, got #{pattern.class}") unless (pattern.kind_of?(Regexp))
    raise ArgumentError.new("Empty regexp not permitted") unless pattern.source.length > 0
    string_start = "\\A"
    @pattern = Regexp.new(string_start + pattern.source)
    @token_class = token_class
  end

  def attempt_tokenize input
    matched = @pattern.match(input)
    if matched
      @remainder = input.sub(@pattern, '')
      @matched_portion = matched.to_s
      @token = @token_class.new(@matched_portion)
    end
    matched
  end

  attr_reader :remainder, :token, :matched_portion
end
