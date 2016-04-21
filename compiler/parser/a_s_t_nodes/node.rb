class Node < RLTK::ASTNode

  def traverse_depth_first visitors
    if visitors.respond_to?(:to_a)
      visitors = visitors.to_a
    else
      visitors = [visitors]
    end
    # pre-visit
    visitors.each do |visitor|
      visitor.pre_visit self
    end
    # visit each child
    self.children.each do |child|
      # if it's a collection, visit each
      if child.kind_of? Array # yeah, I really do mean "kind_of?" not "respond_to?"... if Node#to_a is defined, I still don't want this expression to evaluate to true
        child.each do |grandchild|
          grandchild.traverse_depth_first visitors
        end
      # otherwise visit the only child
      else
        child.traverse_depth_first visitors
      end
    end
    # accept both singular visitor and sets of visitors
    visitors.each do |visitor|
      visitor.visit self
    end
  end

  def to_s
    all_children = self.values + self.children
    children_list = []
    values_list = []
    all_children.compact.each do |child|
      if child.class.ancestors.include?(Node)
        children_list << child
      elsif child.respond_to? :each
        child.each do |grandchild|
          if grandchild.class.ancestors.include?(Node)
            children_list << grandchild
          end
        end
      else
        values_list << child
      end
    end
    values_section = values_list.any? ? " values='#{values_list.join(", ")}'" : ""
    "<#{self.class}#{values_section}>#{children_list.map(&:to_s).join()}</#{self.class}>"
  end
end
