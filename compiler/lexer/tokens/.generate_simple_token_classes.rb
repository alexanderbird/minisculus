class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

path = File.dirname(__FILE__)

{
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
}.each do |klass, name|
	filename = klass.to_s.underscore
	File.open("#{path}/#{filename}.rb", 'w') do |file| 
    file.write("#WARNING: Auto-generated file. To edit, edit and run #{__FILE__}\n\n")
    file.write("class #{klass.to_s} < Token\n") 
    file.write("  def to_s\n")
    file.write("    \"#{name}\"\n")
    file.write("  end\n")
    file.write("end\n")
  end

end


