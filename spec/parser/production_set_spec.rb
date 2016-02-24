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
        [BeginToken, EndToken],
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

    it "raises the most relevant ParseError if not productions executed successfully" do
      @production_set = ProductionSet.new(tokens, Grammar.new, [
        [BeginToken, EndToken],
        [BeginToken, IfToken, EndToken],
        [BeginToken, IfToken, AddToken, EndToken]
      ])
      tokens << BeginToken.new("begin")
      tokens << IfToken.new("if")
      tokens << AddToken.new("+")
      tokens << AddToken.new("+")
      tokens << EndToken.new("end")
      expect{@production_set.execute}.to raise_error ParseError, /EndToken.*ADD/
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
  end
end
