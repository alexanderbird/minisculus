describe Token do
  it "accepts a string in the constructor" do
    expect{Token.new('foo')}.to_not raise_error
  end

  it "passes the string argument to be passed to #parse_matched_string" do
    unique_error = Exception.new('something unique')
    allow_any_instance_of(Token).to receive(:parse_matched_string).with('foobar').and_raise unique_error
    expect{Token.new('foobar')}.to raise_error(unique_error)
  end

  context "#to_s" do
    it "uses the name instance variable" do
      expect(Token.new(nil).to_s).to eq 'TOKEN'
    end
  end
end
