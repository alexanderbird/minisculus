class NumberToken < Token
  def parse_matched_string matched_string
    @value = matched_string.to_i
  end

  attr_accessor :value
end
