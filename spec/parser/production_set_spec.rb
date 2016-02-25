describe ProductionSet do
  let(:tokens) { TokenList.new }
  before do
    productions = [
      EndToken,
      [BeginToken, AddToken, EndToken]
    ]
    @production_set = ProductionSet.new(tokens, Grammar.new, productions)
  end

  context "#initialize" do
    it "complains if productions arg isn't iterable" do
      expect{ProductionSet.new(TokenList.new, Grammar.new, 1)}.to raise_error ArgumentError, /[Ee]xpected Array, got 1/
    end
  end

  context "#execute" do
    let(:terminal) { Terminal.new(TokenList.new, Grammar.new, IfToken) }

    it "delegates #execute to the productions" do
      expect_any_instance_of(Terminal).to receive(:execute)
      @production_set.execute
    end

    it "returns the node from the successful sub-production" do
      node = AbstractSyntaxTree::TerminalNode.new(:foo)
      allow_any_instance_of(Terminal).to receive(:execute).and_return node
      returned_node = @production_set.execute
      expect(returned_node).to eq node
    end

    it "stops after the first successful production" do
      expect_any_instance_of(Terminal).to receive(:execute)
      expect_any_instance_of(NonterminalProduction).to_not receive(:execute)
      @production_set.execute
    end

    it "continues after unsuccessful productions" do
      allow_any_instance_of(Terminal).to receive(:execute).and_raise(ParseError.new(terminal))
      expect_any_instance_of(NonterminalProduction).to receive(:execute)
      @production_set.execute
    end

    it "restores the token list to its pre-parsing state if a rule fails" do
      @production_set = ProductionSet.new(tokens, Grammar.new, [
        EndToken,
        [BeginToken, IfToken, AddToken, EndToken]
      ])
      tokens << BeginToken.new("begin")
      tokens << IfToken.new("if")
      tokens << AddToken.new("+")
      tokens << EndToken.new("end")
      expect{@production_set.execute}.to_not raise_error
    end

    it "raises a ParseError if no productions executed successfully" do
      allow_any_instance_of(Terminal).to receive(:execute).and_raise(ParseError.new(terminal))
      allow_any_instance_of(NonterminalProduction).to receive(:execute).and_raise(ParseError.new(terminal))
      expect{@production_set.execute}.to raise_error ParseError
    end

    it "functions correctly with nested productions and null productions" do
      @production_set = ProductionSet.new(tokens, Grammar.new, [
        BeginToken,
        nil,
        [ { productions: [
          BeginToken, 
          nil
        ]}, EndToken ]
      ])
      tokens << BeginToken.new("begin")
      tokens << EndToken.new("end")
      expect{@production_set.execute}.to_not raise_error
    end

    it "handles begin statement end blocks correctly" do
      grammar = Grammar.new({
        start: { productions: [
          [IdentifierToken, AssignToken, NumberToken],
          [BeginToken, :stmtlist, EndToken]
        ]},
        stmtlist: { productions: [
          [:start, SemicolonToken, :stmtlist],
          nil
        ]}
      })
      tokens << BeginToken.new("begin")
      tokens << IdentifierToken.new('x')
      tokens << AssignToken.new(':=')
      tokens << NumberToken.new('45')
      tokens << SemicolonToken.new(";")
      tokens << EndToken.new("end")
      expect{grammar.starting_production(tokens).execute}.to_not raise_error
    end

    it "handles multiple statements correctly" do
      grammar = Grammar.new({
        start: { productions: [
          [IdentifierToken, AssignToken, NumberToken],
          [IdentifierToken, AssignToken, NumberToken],
          [BeginToken, :stmtlist, EndToken]
        ]},
        stmtlist: { productions: [
          [:start, SemicolonToken, :stmtlist],
          nil
        ]}
      })
      tokens << BeginToken.new("begin")
      tokens << IdentifierToken.new('x')
      tokens << AssignToken.new(':=')
      tokens << NumberToken.new('45')
      tokens << SemicolonToken.new(";")
      tokens << IdentifierToken.new('y')
      tokens << AssignToken.new(':=')
      tokens << NumberToken.new('0')
      tokens << SemicolonToken.new(";")
      tokens << EndToken.new("end")
      expect{grammar.starting_production(tokens).execute}.to_not raise_error
    end

    it "assumes grammar is LL(1)" do
      grammar = Grammar.new({
        start: { productions: [
          [IdentifierToken, AssignToken],
          [IdentifierToken, NumberToken]
        ]}
      })
      tokens << IdentifierToken.new('x')
      tokens << NumberToken.new('45')
      expect{grammar.starting_production(tokens).execute}.to raise_error ParseError
    end
  end
end
