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

    it "fails gracefully if the rules are inexhaustible" do
      allow_any_instance_of(Preprocessor).to receive(:preprocessing_rules).and_return [
        PreprocessorRule.new(/a/, 'a')
      ]
      expect{preprocessor.process 'a'}.to raise_error /PreprocessorRule.*?a.*?a.*? applied 50 times, will it ever be satisfied\?/
    end
  end

  context "#preprocessing_rules" do
    it "strips multi-line comments" do
      input  = "/foo\nb*ar\nfoo/*\n\n start\n\n\nbad1\nbad2\nbad3\nend */baz\nquux"
      output = "/foo\nb*ar\nfoo  \n\n      \n\n\n    \n    \n    \n      baz\nquux".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end

    it "does not require that multi line comment delimiters are alone on the line" do
      input  = "good/*bad\nbad*/good"
      output = "good     \n     good".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end

    it "properly handles inline multi-line style comments" do
      input  = "good/*bad*/good"
      output = "good       good".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end

    it "removes single line comments first" do
      input  = "% comment /*\nfoo\n*/"
      output = "            \nfoo\n*/".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end

    it "properly handles nested multi-line comments that are on one line" do
      input  = "start/*first/*second*/foo/*third*/first*/end"
      output = "start                                    end".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end

    it "properly handles nested multi-line comments that are on multiple lines" do
      input  = "start\n/*first\n/*second\n*/foo\n/*third\n*/first\n*/end"
      output = "start\n       \n        \n     \n       \n       \n  end".gsub(/ /, '')
      expect(preprocessor.process(input)).to eq output
    end
  end
end
