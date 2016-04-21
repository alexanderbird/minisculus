require 'spec_helper'

describe SymbolTable do
  let(:symbol_table) { SymbolTable.new }

  context "#[]" do
    it "returns nil if not found" do
      expect(symbol_table[:something]).to eq nil
    end

    it "returns the right SemanticAnalysisSymbol if it is found in scope" do
      symbol_table[:thinger] = 10
      expect(symbol_table[:thinger]).to eq 10
    end

    it "returns the right SemanticAnalysisSymbol if it is found in a higher scope" do
      symbol_table[:name_conflict] = :value
      symbol_table.begin_scope # level 0 => 1
      symbol_table.begin_scope # level 1 => 2
      symbol_table.begin_scope # level 2 => 3
      symbol_table[:name_conflict] = :different_value # level 3
      symbol_table.begin_scope # level 3 => 4
      symbol_table.begin_scope # level 4 => 5
      expect(symbol_table[:name_conflict]).to eq :different_value 
    end
  end

  context "#[]=" do
    it "sets a SemanticAnalysisSymbol that can be accessed with #[]" do
      symbol_table[:foobar] = 'baz'
      expect(symbol_table[:foobar]).to eq 'baz'
    end
  end

  context "#begin_scope" do
    it "allows temporarily overriding previous variables" do
      symbol_table[:var] = 12
      symbol_table.begin_scope
      symbol_table[:var] = 'totally different'
      expect(symbol_table[:var]).to eq 'totally different'
      symbol_table.end_scope
      expect(symbol_table[:var]).to eq 12
    end
  end

  context "#end_scope" do
    it "makes all variables in the current scope inaccessible" do 
      symbol_table.begin_scope
      symbol_table[:foo] = :bar
      symbol_table.end_scope
      expect(symbol_table[:foo]).to eq nil
    end

    it "throws an exception instead of making scope_level < 0" do
      symbol_table[:baz] = :quux
      expect{symbol_table.end_scope}.to raise_error /cannot end the global scope/i
      expect(symbol_table[:baz]).to eq :quux
    end

    it "removes the symbols from the table so future begin_scope calls cannot make them accessible" do
      symbol_table.begin_scope
      symbol_table[:foo] = :bar
      symbol_table.end_scope
      symbol_table.begin_scope
      expect(symbol_table[:foo]).to eq nil
    end

    it "works right when we're nested many levels deep" do
      symbol_table[:scope_level] = :global
      symbol_table.begin_scope
      symbol_table[:scope_level] = :first
      symbol_table.begin_scope
      symbol_table[:scope_level] = :second
      symbol_table.begin_scope
      symbol_table[:scope_level] = :third
      symbol_table.begin_scope
      symbol_table[:scope_level] = :fourth
      symbol_table.begin_scope
      symbol_table[:scope_level] = :fifth
      symbol_table.begin_scope # 6th level
      expect(symbol_table[:scope_level]).to eq :fifth
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :fifth
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :fourth
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :third
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :second
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :first
      symbol_table.end_scope
      expect(symbol_table[:scope_level]).to eq :global
    end
  end
end
