class Node < RLTK::ASTNode
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
