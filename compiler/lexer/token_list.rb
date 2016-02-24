class TokenList < Array
  # Don't expose Array instance methods
  (self.instance_methods - Object.instance_methods).each do |method|
    private method
  end
  
  # except for the following
  public :<<, :shift, :first, :last, :each, :count

  def initialize
    @index = 0
  end

  def shift
    # "soft" shift - don't remove the shifted elements
    head = self.send :[], @index
    @index += 1
    return head
  end

  def save_state
    SavedState.new(@index)
  end

  def load_state saved_state
    @index = saved_state.index
  end
  
  class SavedState
    def initialize(index)
      @index = index
    end

    attr_reader :index
  end
end
