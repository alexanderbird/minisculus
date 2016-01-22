class PreprocessorRule
  attr_reader :pattern, :replacement
  def initialize pattern, replacement
    @pattern = pattern
    @replacement = replacement
  end

  def apply_to input
    @matched = !!@pattern.match(input)
    input.gsub(@pattern, @replacement)
  end

  def apply_to! input
    input.replace self.apply_to input
  end

  def matched?
    @matched
  end
end
