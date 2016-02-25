describe AbstractSyntaxTree::TerminalNode do
  it "is a node" do
    expect(AbstractSyntaxTree::TerminalNode.new(:nil)).to be_kind_of AbstractSyntaxTree::Node
  end

  it "implements to_hash" do
    number = NumberToken.new(1)
    node = AbstractSyntaxTree::TerminalNode.new(number)
    expect(node.to_hash).to eq({ number.to_s => true })
  end
end
