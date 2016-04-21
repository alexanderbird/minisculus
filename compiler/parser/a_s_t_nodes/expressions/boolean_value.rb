class BooleanValue < Expression
  value :value, Object # Ruby has no "boolean" type, but everything can be duck-typed as a boolean
  def data_type
    :Boolean
  end
end
