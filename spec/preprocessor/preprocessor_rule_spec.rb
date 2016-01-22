describe PreprocessorRule do
  context "#initialize and accessors" do
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

  context "#apply_to" do
    it "returns the input if the pattern doesn't match" do
      rule = PreprocessorRule.new(/q/, 'Q')
      expect(rule.apply_to("apples and bananas")).to eq "apples and bananas"
    end

    it "replaces all occurances of the pattern with the replacement and returns that string" do
      rule = PreprocessorRule.new(/a/, 'A')
      expect(rule.apply_to("apples and bananas")).to eq "Apples And bAnAnAs"
    end
  end

  context "#apply_to!" do
    it "changes the input string" do
      rule = PreprocessorRule.new(/a/, 'A')
      string = "apples and bananas"
      rule.apply_to! string
      expect(string).to eq "Apples And bAnAnAs"
    end
  end

  context "matched?" do
    let(:rule) { PreprocessorRule.new(/a/, '') }

    it "is false if no match has been attempted" do
      expect(rule).to_not be_matched
    end

    it "is false if no match was made" do
      rule.apply_to 'b'
      expect(rule).to_not be_matched
    end

    it "is true if a match was made" do
      rule.apply_to 'a'
      expect(rule).to be_matched
    end

    it "is true when there are multiple matches" do
      rule.apply_to 'aaaaaaafooaaabaraaaa'
      expect(rule).to be_matched
    end
     
    it "is false when there is a long unmatched string" do
      rule.apply_to "foo\nquux\nbAz\n\n\n\nFOO"
      expect(rule).to_not be_matched
    end
  end

end
