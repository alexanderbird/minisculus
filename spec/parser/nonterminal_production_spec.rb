describe NonterminalProduction do
  before do
    @symbols = [NumberToken, nil]
  end

  let(:grammar) { Grammar.new({ symbol: [BeginToken, :symbol, EndToken] }) }
  let(:nonterminal) { NonterminalProduction.new(TokenList.new, grammar, @symbols) }

  context "#execute" do
    it "calls execute on all of its symbols in order" do
      expect_any_instance_of(Terminal).to receive(:execute)
      expect_any_instance_of(NullProduction).to receive(:execute)
      nonterminal.execute
    end

    it "removes tokens" do
      tokens = TokenList.new
      @production_set = NonterminalProduction.new(tokens, grammar, [BeginToken, IfToken])
      tokens << BeginToken.new("begin")
      tokens << IfToken.new("if")
      tokens << EndToken.new("end")
      @production_set.execute
      expect(tokens.count).to eq 1
    end
  end

  context "#identifier" do
    it "gives a string representation of the symbol array" do
      nonterminal.symbols << :symbol
      expect(nonterminal.identifier).to eq "NumberToken, symbol"
    end
  end
end
