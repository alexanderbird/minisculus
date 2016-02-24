describe NullProduction do
  context "#execute" do
    it "doesn nothing" do
      tokens = TokenList.new
      tokens << 1
      tokens << 2
      production = NullProduction.new tokens, Grammar.new
      production.execute
      expect(tokens.first).to eq 1
      expect(tokens.count).to eq 2
    end
  end
end
