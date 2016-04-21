require 'spec_helper'

describe SemanticAnalysisVisitor do
  context "#visit" do
    let(:symbol_table) { SymbolTable.new }
    let(:visitor) { SemanticAnalysisVisitor.new(symbol_table) }
    let(:symbol) { SemanticAnalysisSymbol.new }

    it "does nothing with unrelated tokens" do
      expect{visitor.visit(Node.new)}.to_not raise_error
    end

    it "checks that an identifier has been defined" do
      symbol_table["foo"] = symbol
      foo_assignment = Identifier.new("foo", ArrayDimensions.new(0), IntegerValue.new)
      bar_assignment = Identifier.new("bar", ArrayDimensions.new(0), IntegerValue.new)
      expect{visitor.visit(foo_assignment)}.to_not raise_error
      expect{visitor.visit(bar_assignment)}.to raise_error UndefinedIdentifierException, /bar/
    end

    it "type checks on assignment" do
      symbol.data_type = :IntegerType
      symbol_table["foo"] = symbol
      foo_variable = Assignment.new("foo", [], RealValue.new(1.0))
      expect{visitor.visit(foo_variable)}.to raise_error MinisculusTypeError, /foo/
      expect{visitor.visit(foo_variable)}.to raise_error MinisculusTypeError, /IntegerType/
      expect{visitor.visit(foo_variable)}.to raise_error MinisculusTypeError, /Real/
    end

    it "begins scope at the start of blocks" do
      expect(symbol_table).to receive(:begin_scope)
      block = Block.new([], [])  
      visitor.pre_visit(block)
    end

    it "ends scope at the end of blocks" do
      expect(symbol_table).to receive(:end_scope)
      block = Block.new([], [])  
      visitor.visit(block)
    end

    it "checks function return types"
    it "checks function signatures"
    it "checks array dimensions"
  end
end
