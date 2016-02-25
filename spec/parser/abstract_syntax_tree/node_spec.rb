describe AbstractSyntaxTree::Node do
  let(:node) { AbstractSyntaxTree::Node.new :foo }
  it "uses the constructor argument for to_s" do
    expect(node.to_s).to eq 'foo'
  end

  it "gives access to the identifier object" do
    expect(node.identifier).to eq :foo
  end

  it "has abstract to_hash method" do
    expect{node.to_hash}.to raise_error NotImplementedError
  end
end
