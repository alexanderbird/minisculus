class Token
  attr_reader :line, :column
  def initialize matched_string
    self.parse_matched_string matched_string
  end

  def parse_matched_string matched_string
    # delegated to subclass
  end

  def location= line_and_column
    @line, @column = line_and_column
  end

  def to_s
    params = ''
    if self.printing_parameters.any?
      params = self.printing_parameters.join(", ")
      params = "(#{params})"
    end
    self.name + params 
  end

  def name
    self.class.to_s.upcase
  end

  def printing_parameters
    []
  end
end
