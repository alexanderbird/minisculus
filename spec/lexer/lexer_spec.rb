describe Lexer do
  context "#lex" do
    let(:lexer) { Lexer.new }

    it "returns a set of tokens when given valid Minisculus input"

    it "returns an empty array when given an empty string as input" do
      expect(lexer.lex "").to eq []
    end

    it "throws a lexer error if given invalid input"
  end
end
