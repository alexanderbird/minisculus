describe Token do
  it "accepts a string in the constructor" do
    expect{Token.new('foo')}.to_not raise_error
  end

  it "passes the string argument to be passed to #parse_matched_string" do
    unique_error = Exception.new('something unique')
    allow_any_instance_of(Token).to receive(:parse_matched_string).with('foobar').and_raise unique_error
    expect{Token.new('foobar')}.to raise_error(unique_error)
  end

  context "#location=" do
    it "accepts line and column" do
      token = Token.new('foo')
      expect{token.location = 1, 2}.to_not raise_error
      expect(token.line).to eq 1
      expect(token.column).to eq 2
    end
  end

  context "#to_s" do
    it "uses the name method in the to_s" do
      allow_any_instance_of(Token).to receive(:name).and_return "FooBar"
      expect(Token.new(nil).to_s).to eq 'FooBar'
    end

    it "defaults to the name 'TOKEN' with no empty parens" do
      expect(Token.new(nil).to_s).to eq 'TOKEN'
    end

    it "adds a the printing_parameters in a comma sepparated list" do
      allow_any_instance_of(Token).to receive(:printing_parameters).and_return ['foo', 'bar', 'baz', 50]
      expect(Token.new(nil).to_s).to eq 'TOKEN(foo, bar, baz, 50)'
    end
  end

  context "#is_significant?" do
    it "isn't" do
      expect(Token.new(nil).is_significant?).to_not be_truthy
    end
  end
end
