require 'spec_helper'

class NodeForTest < Node
  value :value, Symbol
  child :array_child, [Node]
  child :single_child, Node
end

class LeafNodeForTest < Node
  value :value, Symbol
end

class VisitorForTest
  attr_reader :visited

  def initialize
    @visited = []
  end

  def visit object
    @visited << object.value
  end
end

describe Node do
  context "#traverse_depth_first" do
    let(:visitor) { VisitorForTest.new }

    it "visits each child" do
      nephew = LeafNodeForTest.new(:nephew)
      mother = LeafNodeForTest.new(:mother)
      father = LeafNodeForTest.new(:father)
      root = NodeForTest.new(:root, [mother, father], nephew)

      order = [:mother, :father, :nephew, :root]

      root.traverse_depth_first(visitor)

      expect(visitor.visited).to eq order
    end

    it "visits itself" do
      one = LeafNodeForTest.new(:one)
      one.traverse_depth_first visitor
      expect(visitor.visited).to eq [:one]
    end

    it "visits depth first" do
      nephew = LeafNodeForTest.new(:nephew)

      son1 = LeafNodeForTest.new(:son1)
      son2 = LeafNodeForTest.new(:son2)
      son3 = LeafNodeForTest.new(:son3)
      dog = LeafNodeForTest.new(:dog)
      father = NodeForTest.new(:father, [son1, son2, son3], dog)

      daughter1 = LeafNodeForTest.new(:daughter1)
      daughter2 = LeafNodeForTest.new(:daughter2)
      cat = LeafNodeForTest.new(:cat)
      mother = NodeForTest.new(:mother, [daughter1, daughter2], cat)

      root = NodeForTest.new(:root, [father, mother], nephew)
      
      root.traverse_depth_first(visitor)

      order = [
        :son1, :son2, :son3, :dog, :father, 
        :daughter1, :daughter2, :cat, :mother, 
        :nephew,
        :root
      ]

      expect(visitor.visited).to eq order
    end

    it "visits with each visitor at each node" do
      nephew = LeafNodeForTest.new(:nephew)
      mother = LeafNodeForTest.new(:mother)
      father = LeafNodeForTest.new(:father)
      root = NodeForTest.new(:root, [mother, father], nephew)

      order = [:mother, :father, :nephew, :root]

      visitors = [
        VisitorForTest.new,
        VisitorForTest.new,
        VisitorForTest.new
      ]

      root.traverse_depth_first(visitors)

      visitors.each do |visitor|
        expect(visitor.visited).to eq order
      end
    end
  end
end
