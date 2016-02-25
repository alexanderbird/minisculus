describe NullProduction do
  context "#execute" do
    let(:tokens) { TokenList.new }
    let(:production) { NullProduction.new tokens, Grammar.new }
    it "does not shift any tokens of the TokenList" do
      tokens << 1
      tokens << 2
      production.execute
      expect(tokens.first).to eq 1
      expect(tokens.count).to eq 2
    end

    it "returns nil" do
      expect(production.execute).to eq nil
    end
  end
end
