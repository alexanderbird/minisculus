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
    tokens = Lexer.new.lex(code)
    print tokens
  end
end

if __FILE__ == $0
  Compiler.compile ARGV.first
end
