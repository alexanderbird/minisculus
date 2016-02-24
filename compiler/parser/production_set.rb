class ProductionSet < Production
  def initialize tokens, grammar, productions
    super tokens, grammar
    raise ArgumentError.new("Expected Array, got #{productions.inspect}") unless productions.respond_to?(:each)
    @productions = productions
  end

  def execute
    any_successful = false
    furthest_parse_index = @tokens.count
    most_relevant_error = nil
    @productions.each do |production|
      state = @tokens.save_state
      begin
        self.fork(production).execute
        any_successful = true
        break
      rescue ParseError => e
        if @tokens.count < furthest_parse_index
          most_relevant_error = e
          furthest_parse_index = @tokens.count
        end
        @tokens.load_state state
      end
    end
    raise most_relevant_error || ParseError.new(self) unless any_successful
  end

  def to_s
    first = @productions.first
    first_to_s = first.respond_to?(:join) ? first.join(', ') : first
    super "[#{first_to_s}], ...]"
  end

  attr_reader :productions
end
