module AbstractSyntaxTree
  class Visualizer
    def initialize node
      @node = node
    end

    def visualize
			vis = Rubyvis::Panel.new()
        .width(5000)
        .height(3000)
        .left(0)
        .right(0)
        .top(0)
        .bottom(0)

			tree = vis.add(Rubyvis::Layout::Tree)
        .nodes(Rubyvis.dom(@node.to_hash).nodes())
				.orient('radial')
				.depth(150)
				.breadth(75)

			tree.link.add(Rubyvis::Line)

			tree.node.add(Rubyvis::Dot)
        .fill_style(lambda {|n| n.first_child ? "#aec7e8" : "#ff7f0e"})
        .title(lambda {|n| n.node_name})

			tree.node_label.add(Rubyvis::Label)

			vis.render
			vis.to_svg
    end
  end
end
