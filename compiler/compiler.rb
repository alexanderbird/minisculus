require './autoload'
require 'timeout'

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
   
    tokens = []
    if [:lex, :ast, :compile].include? options[:mode]
      Timeout::timeout(3) do
        tokens = MinisculusPlusLexer.new.lex code
      end
      all_tokens = tokens.clone
    end

    if [:ast, :compile].include? options[:mode]
      ast = MinisculusPlusParser.new.parse tokens
    end

    if [:compile].include? options[:mode]
      # todo
    end
    
    return if options[:silent]
    case options[:mode]
    when :lex
      puts all_tokens.to_a.join("\n")
    when :ast
      puts "<ast>#{ast.declarations.join()}#{ast.statements.join()}</ast>"
    when :compile
      puts "TODO: output stack code"
    end
  rescue Timeout::Error => e
    print "Lex error\n" unless options[:silent]
  rescue RLTK::NotInLanguage => e
    print "#{e}\n" unless options[:silent]
  rescue RLTK::BadToken => e
    print "#{e}\n" unless options[:silent]
  rescue RLTK::LexingError => e 
    if options[:verbose]
      raise e
    else
      print "#{e.class} on line #{e.line_number}, column #{e.line_offset}: #{e}\n" unless options[:silent]
    end
  end
end
