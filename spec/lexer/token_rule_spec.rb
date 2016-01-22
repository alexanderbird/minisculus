describe TokenRule do
  context "#initialize" do
    it "throws an error if the first argument isn't a token class" do
      expect{TokenRule.new(:symbol, /regexp/)}.to raise_error(ArgumentError, /[Ee]xpected Token, got Symbol/)
    end

    it "throws an error if the second argument isn't a regular expression" do
      expect{TokenRule.new(Token, 'string')}.to raise_error(ArgumentError, /[Ee]xpected Regexp, got String/)
    end

    it "throws an error if the second argument is an empty regular expression" do
      expect{TokenRule.new(Token, //)}.to raise_error(ArgumentError, /[Ee]mpty regexp not permitted/)
    end

    it "is happy if a class and a regex are provided" do
      expect{TokenRule.new(Token, /regexp/)}.to_not raise_error
    end
  end

  context "#attempt_tokenize" do
    before do 
      @token = double(Token)
      allow(Token).to receive(:new).with(String).and_return @token
    end

    it "returns false if the pattern doesn't match" do
      expect(TokenRule.new(Token, /a/).attempt_tokenize("b")).to be_falsey
    end

    it "returns false if the pattern doesn't match the start of the string" do
      expect(TokenRule.new(Token, /a/).attempt_tokenize("ba")).to be_falsey
    end

    it "returns true if the pattern matches the start of the string" do
      expect(TokenRule.new(Token, /a/).attempt_tokenize("a")).to be_truthy
    end

    it "returns true if the pattern matches the start of a longer string" do
      expect(TokenRule.new(Token, /a/).attempt_tokenize("abc")).to be_truthy
    end

    it "gives access to the remainder of the string if a match was made" do
      rule = TokenRule.new(Token, /[0-9]*/)
      rule.attempt_tokenize "123abc"
      expect(rule.remainder).to eq "abc"
    end

    it "gives access to the token if a match was made" do
      rule = TokenRule.new(Token, /foo/)
      rule.attempt_tokenize "foobar"
      expect(rule.token).to eq @token
    end

    it "gives access to the matched portion if a match was made" do
      rule = TokenRule.new(Token, /foo/)
      rule.attempt_tokenize "foobar"
      expect(rule.matched_portion).to eq 'foo'
    end
  end
end
