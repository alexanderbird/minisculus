class NumberToken < Token
  def parse_matched_string matched_string
    @value = matched_string.to_i
  end

  attr_accessor :value

  def name
    "NUM"
  end

  def printing_parameters
    super + [self.value]
  end

  def is_significant?
    true
  end
end
