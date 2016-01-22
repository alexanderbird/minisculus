class Preprocessor
  attr_reader :preprocessing_rules

  def process input
    try_again = true
    while try_again
      try_again = false
      self.preprocessing_rules.each do |rule|
        rule.apply_to! input
        if rule.matched?
          try_again = true
          break
        end
      end
    end
    input
  end
end
