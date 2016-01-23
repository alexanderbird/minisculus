class Preprocessor
  attr_reader :preprocessing_rules

  def initialize
    open_multi_line_comment = /\/\*/
    close_multi_line_comment = /\*\//
    @preprocessing_rules = [
      # remove single-line comment
      PreprocessorRule.new(/%.*$/, ''), 

      # remove multi-line style comment on one line
      PreprocessorRule.new(/#{open_multi_line_comment}((?!#{open_multi_line_comment})(?!#{close_multi_line_comment}).)*#{close_multi_line_comment}/, ''), 

      # remove multi-line comment content (but leave newlines intact)
      PreprocessorRule.new(/(?<=#{open_multi_line_comment})\n*((?!#{open_multi_line_comment})(?!#{close_multi_line_comment}).\n*)+(?=#{close_multi_line_comment})/, 
        PreprocessorRule.new(/.*(?=\n|\z)/, '')), 

      # remove multi-line without content (except for newlines)
      PreprocessorRule.new(/#{open_multi_line_comment}(\n*)#{close_multi_line_comment}/, '\1'), 
    ]
  end

  def process input
    try_again = true
    history = []
    while try_again
      try_again = false
      if history.count >= 50
        raise "#{history.last.inspect} applied 50 times, will it ever be satisfied? Current value is '#{input}'"
      end
      self.preprocessing_rules.each do |rule|
        rule.apply_to! input
        if rule.matched?
          history << rule
          try_again = true
          break
        end
      end
    end
    input
  end
end
