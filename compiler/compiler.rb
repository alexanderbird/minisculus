require './autoload'

module Compiler
  def self.compile filename, options = {}
    raise ArgumentError, "Missing filename" unless filename
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
    ast = grammar.starting_production(tokens).execute
    
    return if options[:silent]
    case options[:mode]
    when :parse
      puts all_tokens.to_a.join("\n")
    when :ast
      puts ast.visualize
    when :compile
      puts "TODO: output stack code"
    end
  rescue StandardError => e
    if options[:verbose]
      raise e
    else
      print "#{e.class}: #{e}\n" unless options[:silent]
    end
  end
end
