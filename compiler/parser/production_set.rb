class ProductionSet < Production
  def initialize tokens, grammar, productions
    super tokens, grammar
    raise ArgumentError.new("Expected Array, got #{productions.inspect}") unless productions.respond_to?(:each)
    @productions = productions
  end

  def execute
    any_successful = false
    initial_parse_index = @tokens.count
    node = nil
    @productions.each do |production|
      state = @tokens.save_state
      begin
        node = self.fork(production).execute
        any_successful = true
        break
      rescue ParseError => e
        if @tokens.count < initial_parse_index
          # that means that at least the first token was matched. Don't bother with any other rules
          raise e
        end
        @tokens.load_state state
      end
    end
    raise ParseError.new(self) unless any_successful
    node
  end

  def to_s
    first = @productions.first
    first_to_s = first.respond_to?(:join) ? first.join(', ') : first
    super "[#{first_to_s}], ...]"
  end

  attr_reader :productions
end
