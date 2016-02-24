class BoilerplateManager
  SIMPLE_TOKENS = {
    IfToken: 'IF',
    ThenToken: 'THEN',
    WhileToken: 'WHILE',
    DoToken: 'DO',
    InputToken: 'INPUT',
    ElseToken: 'ELSE',
    BeginToken: 'BEGIN',
    EndToken: 'END',
    WriteToken: 'WRITE',
    AddToken: 'ADD',
    AssignToken: 'ASSIGN',
    SubToken: 'SUB',
    MulToken: 'MUL',
    DivToken: 'DIV',
    LeftParenToken: 'LPAR',
    RightParenToken: 'RPAR',
    SemicolonToken: 'SEMICOLON'
  }

  def self.generate_simple_token_classes
    path = File.dirname(__FILE__)

    SIMPLE_TOKENS.each do |token_class, token_name|
      klass = Class.new(Token)
      klass.send(:define_method, :name) do
        "#{token_name}"
      end

      Object.const_set token_class, klass
    end
  end
end
