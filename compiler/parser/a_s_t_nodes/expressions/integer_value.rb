class IntegerValue < Expression
  value :value, Fixnum
  def data_type
    :IntegerType
  end
end
