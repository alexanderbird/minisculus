require './autoload'

module Compiler
  def self.compile filename
    file = File.open(filename)
    code = ''
    begin
      code = file.read
    rescue Exception => e
      raise e
    ensure
      file.close
    end
   
    processed_code = Preprocessor.new.process code
    tokens = Lexer.new.lex processed_code
    all_tokens = tokens.clone
    grammar = MinisculusGrammar.new
    grammar.starting_production(tokens).execute
    print all_tokens.to_a.map!(&:to_s).join("\n") + "\n" if all_tokens
  rescue Exception => e
    print "#{e.class}: #{e}\n"
  end
end
