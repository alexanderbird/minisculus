require 'spec_helper'

describe BaseVisitor do
  context "#initialize" do
    it "must have a SymbolTable as the argument" do
      not_right = double("NotASymbolTable")
      allow(not_right).to receive(:kind_of?).with(SymbolTable).and_return(false)
      allow(not_right).to receive(:class).and_return("WrongClassName")
      expect{BaseVisitor.new(not_right)}.to raise_error ArgumentError, /expected a kind of SymbolTable, got WrongClassName/i
    end

    it "is happy with a SymbolTable as the argument" do
      right = double("SymbolTable")
      allow(right).to receive(:kind_of?).with(SymbolTable).and_return(true)
      expect{BaseVisitor.new(right)}.to_not raise_error
    end
  end

  context "#visit" do
    it "raises NotImplementedError" do
      expect{BaseVisitor.new(SymbolTable.new).visit(nil)}.to raise_error NotImplementedError
    end
  end
end
