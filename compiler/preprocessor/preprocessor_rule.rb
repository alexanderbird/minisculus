class PreprocessorRule
  attr_reader :pattern, :replacement
  def initialize pattern, replacement
    @pattern = pattern
    @replacement = replacement
  end

  def apply_to input
    @matched = !!@pattern.match(input)
    if @replacement.respond_to? :apply_to
      input.gsub @pattern do |match|
        @replacement.apply_to match
      end
    else
      input.gsub @pattern, @replacement.to_s
    end
  end

  def apply_to! input
    input.replace self.apply_to input
  end

  def matched?
    @matched
  end
end
