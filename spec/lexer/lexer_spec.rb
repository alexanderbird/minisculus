describe Lexer do
  context "#lex" do
    let(:lexer) { Lexer.new }

    before do
      allow_any_instance_of(Lexer).to receive(:token_rules).and_return [
        TokenRule.new(IdentifierToken, /foo/),
        TokenRule.new(IdentifierToken, /bar/)
      ]
    end

    it "attempts to match each TokenRule to the input" do
      first_token = lexer.lex("barfoo").first
      expect(first_token).to be_kind_of(IdentifierToken)
      expect(first_token.identifier).to eq 'bar'
    end

    it "continues matching TokenRule s until the input is depleted" do
      tokens = lexer.lex("foobarbar")
      expect(tokens.count).to eq 3
      expect(tokens.first.identifier).to eq 'foo'
      expect(tokens.last.identifier).to eq 'bar'
    end

    it "throws a lexer error if no TokenRule s match" do
      expect{lexer.lex("foobarx")}.to raise_error(LexError)
    end

    it "returns an empty list when given an empty string as input" do
      expect(lexer.lex "").to eq []
    end
  end
end
