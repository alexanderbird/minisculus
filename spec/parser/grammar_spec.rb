describe Grammar do
  context "#initialize" do
    it "expects a hash" do
      expect{Grammar.new(1)}.to raise_error ArgumentError, /[Ee]xpected a Hash, got 1/
    end
  end

  context "#production" do
    let(:grammar) {
      Grammar.new({
        first: EndToken,
        second: {
          productions: [
            [BeginToken, NumberToken, EndToken],
            nil
          ]
        }, 
        null: nil
      })
    }

    let(:tokens) { TokenList.new }

    let(:terminal) { double(Terminal, :name= => true) }

    it "creates the appropriate production" do
      expect(Production).to receive(:create_from).with(tokens, anything, EndToken).and_return(terminal)
      expect(grammar.production :first, tokens).to eq terminal
    end

    it "recognizes the null production" do
      expect(Production).to receive(:create_from).with(tokens, anything, nil).and_return(terminal)
      expect(grammar.production :null, tokens).to eq terminal
    end

    it "blows up if there is no matching production" do
      expect{grammar.production :absent, TokenList.new}.to raise_error NoSuchProductionError
    end

    it "sets the production's name" do
      allow(Production).to receive(:create_from).with(tokens, anything, EndToken).and_return(terminal)
      expect(terminal).to receive(:name=).with("first")
      grammar.production :first, tokens
    end
  end

  context "#starting_production" do
    let(:grammar) {
      Grammar.new({
        first: nil,
        second: NumberToken
      })
    }
    
    it "takes the first key in the grammar rules" do
      expect_any_instance_of(NullProduction).to receive(:execute)
      grammar.starting_production(TokenList.new).execute
    end
  end
end
