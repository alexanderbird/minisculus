class Token
  def initialize matched_string
    self.parse_matched_string matched_string
  end

  def parse_matched_string matched_string
    # delegated to subclass
  end

  def to_s
    self.class.to_s.upcase
  end
end