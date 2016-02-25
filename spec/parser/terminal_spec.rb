describe Terminal do
  let(:number) { NumberToken.new("5") }
  before do
    @tokens = TokenList.new
    @tokens << number
    @tokens << EndToken.new("end")
    
    @terminal = Terminal.new(@tokens, Grammar.new, NumberToken)
  end

  context "#execute" do
    it "shifts the first token" do
      expect(@tokens.count).to eq 2
      @terminal.execute
      expect(@tokens.count).to eq 1
    end

    it "raises ParseError if the `shift`ed token is not of the same type as the terminal token" do
      terminal = Terminal.new(@tokens, Grammar.new, IfToken)
      expect{terminal.execute}.to raise_error ParseError
    end
  end

  context "#identifier" do
    it "returns the token class before executing" do
      expect(@terminal.identifier).to eq NumberToken
    end

    it "returns the token proper after executing" do
      @terminal.execute
      expect(@terminal.identifier).to eq number
    end
  end
end
