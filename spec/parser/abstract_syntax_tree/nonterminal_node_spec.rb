describe AbstractSyntaxTree::NonterminalNode do
  it "is a node" do
    expect(AbstractSyntaxTree::NonterminalNode.new(:nil)).to be_kind_of AbstractSyntaxTree::Node
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
