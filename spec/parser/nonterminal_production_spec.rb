describe NonterminalProduction do
  before do
    @symbols = [NumberToken, nil]
  end

  context "#execute" do
    it "calls execute on all of its symbols in order" do
      nonterminal = NonterminalProduction.new(TokenList.new, Grammar.new, @symbols)
      expect_any_instance_of(Terminal).to receive(:execute)
      expect_any_instance_of(NullProduction).to receive(:execute)
      nonterminal.execute
    end

    it "removes tokens" do
      tokens = TokenList.new
      @production_set = NonterminalProduction.new(tokens, Grammar.new, [BeginToken, IfToken])
      tokens << BeginToken.new("begin")
      tokens << IfToken.new("if")
      tokens << EndToken.new("end")
      @production_set.execute
      expect(tokens.count).to eq 1
    end
  end
end
