class Expression < Node
  def data_type
    raise NotImplementedError, self.to_s
  end
end
