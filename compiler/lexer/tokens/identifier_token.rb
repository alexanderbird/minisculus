class IdentifierToken < Token
  def parse_matched_string matched_string
    @identifier = matched_string
  end

  attr_accessor :identifier

  def to_s
    "ID(#{self.identifier})"
  end
end
