describe Compiler do
  context "#compile" do
    before do
      @file_double = double(File)
      @filename = 'foobar.baz'
      allow(File).to receive(:open).with(@filename).and_return(@file_double)
      allow(@file_double).to receive(:read).and_return ''
      allow_any_instance_of(Lexer).to receive(:lex)
      # make sure it's always always always closed
      expect(@file_double).to receive(:close)
    end

    it "lexes from a file" do
      content = "begin\nend"
      allow(@file_double).to receive(:read).and_return content 
      expect_any_instance_of(Lexer).to receive(:lex).with(content).and_return []
      Compiler.compile @filename
    end
    
    it "calls the preprocessor first" do
      content = "begin\nend"
      processed_content = "foobar"
      allow(@file_double).to receive(:read).and_return content 
      expect_any_instance_of(Preprocessor).to receive(:process).with(content).and_return processed_content
      expect_any_instance_of(Lexer).to receive(:lex).with(processed_content).and_return []
      Compiler.compile @filename
    end

    it "closes the file if the read operation fails" do
      some_error = ArgumentError.new('some error message generated by File.read')
      allow(@file_double).to receive(:read).and_raise some_error
      expect{ Compiler.compile @filename }.to raise_error(some_error)
    end

    it "prints the result" do
      content = "begin\nend"
      allow(@file_double).to receive(:read).and_return content 
      tokens = [:foo, :bar]
      allow_any_instance_of(Lexer).to receive(:lex).and_return tokens
      expect{ Compiler.compile @filename }.to output("foo\nbar\n").to_stdout
    end
  end
end
