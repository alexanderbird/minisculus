describe AbstractSyntaxTree::NonterminalNode do
  it "is a node" do
    expect(AbstractSyntaxTree::NonterminalNode.new(:nil)).to be_kind_of AbstractSyntaxTree::Node
  end

  it "implements to_hash" do
    node = AbstractSyntaxTree::NonterminalNode.new([NumberToken, nil, :other_production])
    node << AbstractSyntaxTree::TerminalNode.new(NumberToken.new(4))
    expect(node.to_hash).to eq({ "[NumberToken, nil, :other_production]" => { "NUM(4)" => true }})
  end

  it "recurses in to_hash" do
    node = AbstractSyntaxTree::NonterminalNode.new([NumberToken, nil, :other_production])
    child_node1 = AbstractSyntaxTree::TerminalNode.new(NumberToken.new(4))
    allow(child_node1).to receive(:to_hash).and_return({foo: :bar})
    node << child_node1
    child_node2 = AbstractSyntaxTree::TerminalNode.new(NumberToken.new(4))
    allow(child_node2).to receive(:to_hash).and_return({baz: :quux})
    node << child_node2
    expect(node.to_hash).to eq({ "[NumberToken, nil, :other_production]" => { foo: :bar, baz: :quux }})
  end

  context "children management" do
    let(:node) { AbstractSyntaxTree::NonterminalNode.new(:nil) }

    it "allows you to add nodes and access them in the children list" do
      child1 = AbstractSyntaxTree::TerminalNode.new(:one)
      child2 = AbstractSyntaxTree::TerminalNode.new(:two)
      node << child1
      node << child2
      expect(node.children).to eq [child1, child2]
    end

    it "does not allow you to add non-node children" do
      expect{node << :not_a_node}.to raise_error ArgumentError, /[Ee]xpected AbstractSyntaxTree::Node, got :not_a_node/
    end

    it "ignores nil assignment" do
      expect{node << nil}.to_not raise_error
      expect(node.children).to be_empty
    end

    it "has an empty child node list to start with" do
      expect(node.children).to eq [] 
    end
  end
end
