class IdentifierToken < Token
  def parse_matched_string matched_string
    @identifier = matched_string
  end

  attr_accessor :identifier

  def name
    "ID"
  end

  def printing_parameters
    super + [self.identifier]
  end

  def is_significant?
    true
  end
end
