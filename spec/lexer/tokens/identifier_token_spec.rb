describe IdentifierToken do
  it "is a token" do
    expect(IdentifierToken.ancestors).to include Token
  end

  it "stores the identifier" do
    expect(IdentifierToken.new('one_variable').identifier).to eq 'one_variable'
  end

  it "is_significant" do
    expect(IdentifierToken.new(nil).is_significant?).to be_truthy
  end
end
