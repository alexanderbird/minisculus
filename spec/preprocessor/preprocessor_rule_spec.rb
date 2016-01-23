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

    it "uses the to_s method for replacement in case it isn't actually a string" do
      replacement = double("Not A String", to_s: 'STRINGIFIED')
      rule = PreprocessorRule.new(/a/, replacement)
      expect(rule.apply_to('abc')).to eq 'STRINGIFIEDbc'
    end

    it "replaces all occurances of the pattern with the result of replacement.apply_to if replacement.respond_to? :apply_to" do
      sub_rule = double("Sub-PreprocessorRule", apply_to: 'SWAP', to_s: 'FAIL')
      rule = PreprocessorRule.new(/cat/, sub_rule)
      expect(rule.apply_to("cats and dogs and cats")).to eq "SWAPs and dogs and SWAPs"
    end

    it "recurses well with real PreprocessorRules as replacement objects" do
      rule = PreprocessorRule.new(/dog food is good/, PreprocessorRule.new(/foo.*ood/, PreprocessorRule.new(/o/, ''))) 
      expect(rule.apply_to("you know dog food is good")).to eq "you know dog fd is gd"
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
