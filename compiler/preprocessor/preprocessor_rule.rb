class PreprocessorRule
  def initialize pattern, replacement
    @pattern = pattern
    @replacement = replacement
  end

  attr_reader :pattern, :replacement
end
