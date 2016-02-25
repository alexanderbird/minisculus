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

    it "returns nil if the `shift`ed token is not significant" do
      allow(number).to receive(:is_significant?).and_return false
      expect(@terminal.execute).to eq nil
    end
    
    it "returns a AbstractSyntaxTree::Node.new(@token) if the token is significant" do
      allow(number).to receive(:is_significant?).and_return true
      node = @terminal.execute
      expect(node).to be_kind_of AbstractSyntaxTree::TerminalNode
      expect(node.identifier).to eq number
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
