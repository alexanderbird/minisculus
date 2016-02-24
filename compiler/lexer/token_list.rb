class TokenList
  def initialize list = []
    @index = 0
    @list = list.to_a
  end

  def shift
    # "soft" shift - don't remove the shifted elements
    head = @list[@index]
    @index += 1
    return head
  end

  def << val
    @list << val
  end

  def first
    @list[@index]
  end

  def last
    @list.last
  end

  def each &block
    self.to_a.each &block
  end

  def count
    @list.count - @index
  end

  def == val
    @list == val.to_a
  end

  def to_a
    @list[@index..-1]
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
