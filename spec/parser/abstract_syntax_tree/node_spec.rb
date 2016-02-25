describe AbstractSyntaxTree::Node do
  it "uses the constructor argument for to_s" do
    node = AbstractSyntaxTree::Node.new :foo
    expect(node.to_s).to eq 'foo'
  end
end
