describe PreprocessorRule do
  before do
    @regexp = /foo/
    @replacement = 'bar'
    @rule = PreprocessorRule.new(@regexp, @replacement)
  end

  it "allows you to set the pattern in the constructor" do
    expect(@rule.pattern).to eq @regexp
  end

  it "allows you to set the replacement in the constructor" do
    expect(@rule.replacement).to eq @replacement
  end

  it "does not let you set the regexp after construction" do
    expect{@rule.pattern = /foobar/}.to raise_error(NoMethodError)
  end

  it "does not let you set the replacement after construction" do
    expect{@rule.replacement = 'foobar'}.to raise_error(NoMethodError)
  end

end
