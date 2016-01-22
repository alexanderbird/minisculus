describe Preprocessor do
  let(:preprocessor) { Preprocessor.new }

  context "#process" do
    it "accepts and returns text" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return []
      expect(preprocessor.process 'foobar').to eq 'foobar'
    end

    it "returns the input if no PreprocessorRules match ever" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return [
        PreprocessorRule.new(/baz/, 'FAIL')
      ]
      expect(preprocessor.process 'foobar').to eq 'foobar'
    end

    it "attempts to apply the PreprocessorRules" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return [
        PreprocessorRule.new(/foo/, 'PASS')
      ]
      expect(preprocessor.process 'foobar').to eq 'PASSbar'
    end

    it "applies the rules until no more can be applied" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return [
        PreprocessorRule.new(/ab/, '')
      ]
      expect(preprocessor.process 'aaabbb').to eq ''
    end

    it "restarts from the beginning once a rule matches, so that it respects the rule order" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return [
        PreprocessorRule.new(/b/, 'PASS'),
        PreprocessorRule.new(/a/, 'b'),
        PreprocessorRule.new(/b/, 'FAIL')
      ]
      expect(preprocessor.process 'a').to eq 'PASS'
    end
  end
end
