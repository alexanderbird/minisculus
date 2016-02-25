describe NonterminalProduction do
  before do
    @symbols = [NumberToken, nil]
  end

  let(:tokens) { TokenList.new }
  let(:grammar) { Grammar.new({ symbol: [BeginToken, :symbol, EndToken] }) }
  let(:nonterminal) { NonterminalProduction.new(tokens, grammar, @symbols) }

  context "#execute" do
    it "calls execute on all of its symbols in order" do
      expect_any_instance_of(Terminal).to receive(:execute)
      expect_any_instance_of(NullProduction).to receive(:execute)
      nonterminal.execute
    end

    it "removes tokens" do
      @symbols = [BeginToken, IfToken]
      tokens << BeginToken.new("begin")
      tokens << IfToken.new("if")
      tokens << EndToken.new("end")
      nonterminal.execute
      expect(tokens.count).to eq 1
    end

    it "returns a node with all the nodes returned by children as node children" do
      @symbols = [BeginToken, IdentifierToken, NumberToken, nil]
      tokens << BeginToken.new("begin")
      id = IdentifierToken.new("varName")
      tokens << id 
      number = NumberToken.new("2")
      tokens << number
      node = nonterminal.execute
      expect(node.children.count).to eq 2
    end

    it "returns a node with the correct identifier" do
      tokens << NumberToken.new(1)
      node = nonterminal.execute 
      expect(node.identifier).to eq @symbols
    end
  end

  context "#identifier" do
    it "gives a string representation of the symbol array" do
      nonterminal.symbols << :symbol
      expect(nonterminal.identifier).to eq "NumberToken, symbol"
    end
  end
end
