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
   
    #processed_code = Preprocessor.new.process code
    tokens = MinisculusPlusLexer.new.lex code
    all_tokens = tokens.clone
    #grammar = MinisculusGrammar.new
    #ast = grammar.starting_production(tokens).execute
    ast = MinisculusPlusParser.new.parse tokens
    
    return if options[:silent]
    case options[:mode]
    when :parse
      puts all_tokens.to_a.join("\n")
    when :ast
      puts "<ast>#{ast.join()}</ast>"
    when :compile
      puts "TODO: output stack code"
    end
  rescue RLTK::NotInLanguage => e
    print "#{e}\n"
  rescue RLTK::BadToken => e
    print "#{e}\n"
  rescue RLTK::LexingError => e 
    if options[:verbose]
      raise e
    else
      print "#{e.class} on line #{e.line_number}, column #{e.line_offset}: #{e}\n" unless options[:silent]
    end
  end
end
