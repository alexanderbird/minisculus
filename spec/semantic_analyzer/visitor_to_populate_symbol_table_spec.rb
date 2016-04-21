require 'spec_helper'

describe VisitorToPopulateSymbolTable do
  context "#initialize" do
    it "must have a SymbolTable as the argument" do
      not_right = double("NotASymbolTable")
      allow(not_right).to receive(:kind_of?).with(SymbolTable).and_return(false)
      allow(not_right).to receive(:class).and_return("WrongClassName")
      expect{VisitorToPopulateSymbolTable.new(not_right)}.to raise_error ArgumentError, /expected a kind of SymbolTable, got WrongClassName/i
    end
  end

  context "#visit" do
    let(:symbol_table) { SymbolTable.new }
    let(:visitor) { VisitorToPopulateSymbolTable.new(symbol_table) }

    it "does nothing if it gets an irrelevant token type" do
      visitor.visit Identifier.new("variable_identifier", nil) 
      expect(symbol_table["variable_identifier"]).to eq nil
    end

    it "adds to the symbol table with key token#name if it gets a FunctionDeclaration" do
      declaration = FunctionDeclaration.new("first_declaration", [], Boolean.new, [], [])  
      visitor.visit declaration
      expect(symbol_table["first_declaration"]).to be_kind_of SemanticAnalysisSymbol
    end

    it "adds to the symbol table with key token#name if it gets a Variable" do
      variable = Variable.new("one_variable", 0, Boolean.new) 
      visitor.visit variable
      expect(symbol_table["one_variable"]).to be_kind_of SemanticAnalysisSymbol
    end

    it "adds to the symbol table with key token#name if it gets a Parameter" do
      parameter = Parameter.new("first_param", 0, Boolean.new)
      visitor.visit parameter
      expect(symbol_table["first_param"]).to be_kind_of SemanticAnalysisSymbol
    end

    it "sets the data_type based on token#type class as a symbol if possible" do
      visitor.visit Variable.new("one_variable", 0, Boolean.new)
      visitor.visit Parameter.new("first_param", 0, IntegerType.new)
      expect(symbol_table["one_variable"].data_type).to eq :Boolean
      expect(symbol_table["first_param"].data_type).to eq :IntegerType
    end

    it "sets the data_type based on token#return_type class as a symbol if possible" do
      visitor.visit FunctionDeclaration.new("first_declaration", [], Boolean.new, [], [])  
      expect(symbol_table["first_declaration"].data_type).to eq :Boolean
    end

    it "sets the symbol_type based on the token class as a symbol" do
      visitor.visit Variable.new("one_variable", 0, Boolean.new)
      visitor.visit Parameter.new("first_param", 0, IntegerType.new)
      visitor.visit FunctionDeclaration.new("first_declaration", [], Boolean.new, [], [])  

      expect(symbol_table["one_variable"].symbol_type).to eq :Variable
      expect(symbol_table["first_param"].symbol_type).to eq :Parameter
      expect(symbol_table["first_declaration"].symbol_type).to eq :FunctionDeclaration
    end
  end
end
