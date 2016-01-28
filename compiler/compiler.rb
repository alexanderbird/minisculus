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
    print tokens.map!(&:to_s).join("\n") + "\n" if tokens
  end
end
