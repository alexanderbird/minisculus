describe AbstractSyntaxTree::TerminalNode do
  it "is a node" do
    expect(AbstractSyntaxTree::TerminalNode.new(:nil)).to be_kind_of AbstractSyntaxTree::Node
  end
end
