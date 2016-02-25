describe NumberToken do
  it "is_significant" do
    expect(NumberToken.new(nil).is_significant?).to be_truthy
  end
end
