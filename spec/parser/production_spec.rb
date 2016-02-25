describe Production do
  let(:tokens) { TokenList.new }
  let(:production) { Production.new tokens, Grammar.new}

  context "#initialize" do
    it "requires a TokenList" do
      expect{Production.new}.to raise_error ArgumentError
      expect{Production.new "", nil}.to raise_error ArgumentError, /[Ee]xpected TokenList, got String/
    end

    it "requires a Grammar" do
      expect{Production.new TokenList.new, nil}.to raise_error ArgumentError, /[Ee]xpected Grammar, got (nil|NilClass)/
    end

    it "exposes token list publically" do
      expect{production.tokens}.to_not raise_error
    end

    it "exposes the token list to subclasses" do
      subclass = Class.new(Production) do
        def get_tokens
          return self.tokens
        end
      end
      expect(subclass.new(tokens, Grammar.new).get_tokens).to eq tokens
    end
  end

  context "#execute" do
    it "is abstract" do
      expect{ production.execute }.to raise_error NotImplementedError
    end
  end

  context "#fork" do
    it "blows up if it doesn't recognize the identifier" do
      expect{production.fork(1)}.to raise_error ArgumentError
    end

    it "converts Token to Terminal" do
      terminal = production.fork(NumberToken)
      expect(terminal).to be_kind_of Terminal
      expect(terminal.token_class).to eq NumberToken
    end

    it "converts nil to NullProduction" do
      terminal = production.fork(nil)
      expect(terminal).to be_kind_of NullProduction
    end

    it "converts 1D array to NonterminalProduction" do
      nonterminal = production.fork([nil, nil])
      expect(nonterminal).to be_kind_of NonterminalProduction
      expect(nonterminal.symbols.count).to eq 2
      expect(nonterminal.symbols.first).to eq nil
    end

    it "converts 2D array to ProductionSet" do
      production_set = production.fork({ productions: [
        EndToken, 
        [nil, NumberToken]
      ] })
      expect(production_set).to be_kind_of ProductionSet

      # first production
      terminal_identifier = production_set.productions.first
      expect(terminal_identifier).to eq EndToken

      # second production
      nonterminal_identifier = production_set.productions.last
      expect(nonterminal_identifier).to eq [nil, NumberToken]
    end

    it "searches for symbol in the Grammar" do
      production.grammar = Grammar.new({
        null_prod: nil,
        regular_prod: [EndToken, NumberToken]
      })
      null_production = production.fork(:null_prod)
      expect(null_production).to be_kind_of NullProduction


      nonterminal = production.fork(:regular_prod)
      expect(nonterminal).to be_kind_of NonterminalProduction
      expect(nonterminal.symbols.count).to eq 2
      expect(nonterminal.symbols).to eq [EndToken, NumberToken]
    end
  end

  context ".create_from" do
    it "forks a new Production class" do
      expect_any_instance_of(Production).to receive(:fork).with(NumberToken)
      Production.create_from TokenList.new, Grammar.new, NumberToken
    end
  end

  context "#identifier" do
    it "uses @name if set" do
      production.name = "foo bar"
      expect(production.identifier).to eq "foo bar"
    end

    it "uses class name if @name isn't set" do
      Object.const_set :SpecialProduction, Class.new(Production)
      production = SpecialProduction.new(TokenList.new, Grammar.new)
      production.name = nil
      expect(production.identifier).to eq "SpecialProduction"
      # cleanup
      Object.send :remove_const, :SpecialProduction
    end
  end
end
